import boto3
import os
import logging
from datetime import datetime, timedelta, timezone

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.client("ec2")
sns = boto3.client("sns")

SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]
DRY_RUN = os.environ.get("DRY_RUN", "false").lower() == "true"

RETENTION_DAYS = 30


def publish_notification(subject, message):
    try:
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject=subject,
            Message=message
        )
        logger.info("sns_notification_sent")
    except Exception as error:
        logger.error(f"sns_publish_failed: {error}")


def is_snapshot_untagged(snapshot):
    return "Tags" not in snapshot or len(snapshot["Tags"]) == 0


def lambda_handler(event, context):
    logger.info("snapshot_cleanup_started")

    cutoff_date = datetime.now(timezone.utc) - timedelta(days=RETENTION_DAYS)
    logger.info(f"retention_cutoff_timestamp: {cutoff_date}")

    deleted_snapshots = []
    skipped_snapshots = []

    paginator = ec2.get_paginator("describe_snapshots")
    snapshots = []

    for page in paginator.paginate(OwnerIds=["self"]):
        snapshots.extend(page["Snapshots"])

    for snapshot in snapshots:
        snapshot_id = snapshot["SnapshotId"]
        start_time = snapshot["StartTime"]

        if start_time < cutoff_date:
            if is_snapshot_untagged(snapshot):
                if DRY_RUN:
                    logger.info(f"dry_run_enabled: snapshot would be deleted -> {snapshot_id}")
                else:
                    try:
                        ec2.delete_snapshot(SnapshotId=snapshot_id)
                        deleted_snapshots.append(snapshot_id)
                        logger.info(f"snapshot_deleted: {snapshot_id}")
                    except Exception as error:
                        logger.error(f"snapshot_delete_failed: {snapshot_id} error={error}")
            else:
                skipped_snapshots.append(snapshot_id)
                logger.info(f"snapshot_tagged_protected: {snapshot_id}")

    report_message = f"""
Snapshot Cleanup Automation Report

Retention Policy:
Snapshots older than {RETENTION_DAYS} days

Deleted Snapshots:
{deleted_snapshots}

Skipped Tagged Snapshots:
{skipped_snapshots}

Total Deleted:
{len(deleted_snapshots)}
"""

    if DRY_RUN:
        logger.info("dry_run_enabled: skipping SNS notification")
    else:
        publish_notification("Snapshot Cleanup Execution Report", report_message)

    logger.info("snapshot_cleanup_completed")
    return report_message