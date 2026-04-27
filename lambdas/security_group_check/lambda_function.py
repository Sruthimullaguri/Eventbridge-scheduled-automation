import boto3
import os
import logging
from datetime import datetime, timedelta, timezone

# setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# AWS clients
ec2 = boto3.client("ec2")
sns = boto3.client("sns")

# environment variables from Terraform
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]
DRY_RUN = os.environ.get("DRY_RUN", "false").lower() == "true"

def is_ssh_open_to_world(permission):
    """
    Returns True if security group rule allows
    SSH access from 0.0.0.0/0
    """
    if permission.get("FromPort") != 22:
        return False
    for ip_range in permission.get("IpRanges", []):
        if ip_range.get("CidrIp") == "0.0.0.0/0":
            return True
    return False
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

def lambda_handler(event, context):

    logger.info("security_scan_started")
    risky_security_groups = []
    paginator = ec2.get_paginator("describe_security_groups")

    security_groups = []

    for page in paginator.paginate():
        security_groups.extend(page["SecurityGroups"])

    for sg in security_groups:
        group_id = sg["GroupId"]
        group_name = sg.get("GroupName", "unknown")
        for permission in sg["IpPermissions"]:
            if is_ssh_open_to_world(permission):
                logger.warning(
                    f"Security risk detected: {group_id} ({group_name}) allows SSH from internet"
                )
                risky_security_groups.append(
                    f"{group_id} ({group_name})"
                )
    if not risky_security_groups:
        message = "No security groups allow SSH from 0.0.0.0/0"
        logger.info(message)
    else:
        message = f"""
Security Group Exposure Alert

Total security groups with open SSH access:
{len(risky_security_groups)}

Example affected group:
{risky_security_groups[0] if risky_security_groups else "None"}

Full details available in CloudWatch logs.

Recommendation:
Restrict SSH access to trusted IP ranges or use SSM Session Manager instead.
"""
        logger.warning("security_scan_completed_with_findings")
    if DRY_RUN:
        logger.info("dry_run_enabled: skipping SNS notification")
    else:
        publish_notification(
            "Security Alert: Open SSH Access Detected",
            message
    )

    logger.info("Security group audit completed successfully")
    return message