# EventBridge Scheduled Automation
## Task:
Create scheduled tasks that perform AWS resource management
## What to Do:
●    Create EventBridge rule that runs every 5 minutes
●    Lambda function does:
●    Find all EC2 instances with the tag "Environment: Dev."
●    Check current time
●    Stop instances after 6 pm
●    Start instances at 9 am
●    Send report to SNS (how many stopped/started)
●    Create a second rule for weekly cleanup:
●    Runs every Sunday at 2 am
●    Finds snapshots older than 30 days
●    Deletes untagged snapshots
●    Sends summary report
●    Create a third rule for security:
●    Runs hourly
●    Finds security groups with 0.0.0.0/0 on port 22
●    Sends alert to SNS
●    Test by manually triggering rules
## Success Criteria:
●    Scheduled rules execute on time
●    EC2 instances stop/start correctly
●    Reports are sent via SNS
●    Security checks identify risky SGs
