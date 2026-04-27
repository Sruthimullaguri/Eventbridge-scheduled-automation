# EC2 Scheduler Rule (Runs every 5 minutes)

resource "aws_cloudwatch_event_rule" "ec2_scheduler_rule" {
  name = "${var.project_name}-ec2-schedule"
  description = "Runs EC2 start/stop automation every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "ec2_scheduler_target" {
  rule = aws_cloudwatch_event_rule.ec2_scheduler_rule.name
  target_id = "ec2SchedulerLambda"
  arn = aws_lambda_function.ec2_scheduler.arn
}

# Snapshot Cleanup Rule (Sunday 2 AM)

resource "aws_cloudwatch_event_rule" "snapshot_cleanup_rule" {
  name = "${var.project_name}-snapshot-cleanup"
  description = "Weekly cleanup of old untagged snapshots"
  schedule_expression = "cron(0 2 ? * SUN *)"
}

resource "aws_cloudwatch_event_target" "snapshot_cleanup_target" {
  rule = aws_cloudwatch_event_rule.snapshot_cleanup_rule.name
  target_id = "snapshotCleanupLambda"
  arn = aws_lambda_function.snapshot_cleanup.arn
}

# Security Group Audit Rule (Hourly)

resource "aws_cloudwatch_event_rule" "security_group_audit_rule" {
  name = "${var.project_name}-security-audit"
  description = "Detect security groups with open SSH access"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "security_group_audit_target" {
  rule = aws_cloudwatch_event_rule.security_group_audit_rule.name
  target_id = "securityAuditLambda"
  arn = aws_lambda_function.security_group_audit.arn
}