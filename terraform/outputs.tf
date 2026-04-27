# SNS Topic ARN

output "sns_topic_arn" {
  description = "SNS topic used for automation notifications"
  value = aws_sns_topic.automation_topic.arn
}

# Lambda Function Names

output "ec2_scheduler_lambda_name" {
  description = "EC2 scheduler Lambda function name"
  value = aws_lambda_function.ec2_scheduler.function_name
}

output "snapshot_cleanup_lambda_name" {
  description = "Snapshot cleanup Lambda function name"
  value = aws_lambda_function.snapshot_cleanup.function_name
}

output "security_group_audit_lambda_name" {
  description = "Security group audit Lambda function name"
  value = aws_lambda_function.security_group_audit.function_name
}

# EventBridge Rule Names

output "ec2_schedule_rule_name" {
  description = "EventBridge rule for EC2 scheduler"
  value = aws_cloudwatch_event_rule.ec2_scheduler_rule.name
}

output "snapshot_cleanup_rule_name" {
  description = "EventBridge rule for snapshot cleanup"
  value = aws_cloudwatch_event_rule.snapshot_cleanup_rule.name
}

output "security_audit_rule_name" {
  description = "EventBridge rule for security group audit"
  value = aws_cloudwatch_event_rule.security_group_audit_rule.name
}