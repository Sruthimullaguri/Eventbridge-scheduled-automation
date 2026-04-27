import boto3
import os
import logging
from datetime import datetime
from zoneinfo import ZoneInfo

# setup logging (visible in CloudWatch)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# AWS clients
ec2 = boto3.client("ec2")
sns = boto3.client("sns")

# environment variables injected from Terraform
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

# using US Eastern time (important for real-world scheduling clarity)
TIMEZONE = ZoneInfo("America/New_York")

def get_dev_instances():
    """
    Fetch EC2 instances tagged Environment=Dev
    """
    response = ec2.describe_instances(
        Filters=[
            {
                "Name": "tag:Environment",
                "Values": ["Dev"]
            },
            {
                "Name": "instance-state-name",
                "Values": ["running", "stopped"]
            }
        ]
    )
    instance_ids = []
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            instance_ids.append(instance["InstanceId"])
    return instance_ids

def lambda_handler(event, context):
    logger.info("Starting EC2 scheduler automation")
    now = datetime.now(TIMEZONE)
    current_hour = now.hour
    logger.info(f"Current time (Eastern): {now}")
    instance_ids = get_dev_instances()

    if not instance_ids:
        logger.info("No Dev-tagged instances found")
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject="EC2 Scheduler Report",
            Message="No instances found with tag Environment=Dev"
        )
        return "No instances found"

    stopped_instances = []
    started_instances = []

    # stop instances after 6 PM
    if 18 <= current_hour <= 23:
        logger.info("Stopping instances (after 6 PM policy)")
        ec2.stop_instances(InstanceIds=instance_ids)
        stopped_instances = instance_ids

    # start instances after 9 AM
    elif 9 <= current_hour < 18:
        logger.info("Starting instances (after 9 AM policy)")
        ec2.start_instances(InstanceIds=instance_ids)
        started_instances = instance_ids
    else:
        logger.info("Outside automation window — no action taken")
    report_message = f"""
EC2 Scheduler Automation Report
Timestamp: {now}

Started Instances:
{started_instances}

Stopped Instances:
{stopped_instances}
"""

    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject="EC2 Scheduler Execution Report",
        Message=report_message
    )

    logger.info("Automation completed successfully")
    return report_message