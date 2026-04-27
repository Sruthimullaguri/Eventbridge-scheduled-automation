# Allow EventBridge to invoke EC2 Scheduler Lambda

resource "aws_lambda_permission" "allow_eventbridge_ec2_scheduler" {
  statement_id = "AllowEventBridgeInvokeEC2Scheduler"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_scheduler.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.ec2_scheduler_rule.arn
}

# Allow EventBridge to invoke Snapshot Cleanup Lambda

resource "aws_lambda_permission" "allow_eventbridge_snapshot_cleanup" {
  statement_id = "AllowEventBridgeInvokeSnapshotCleanup"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.snapshot_cleanup.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.snapshot_cleanup_rule.arn
}

# Allow EventBridge to invoke Security Group Audit Lambda

resource "aws_lambda_permission" "allow_eventbridge_security_audit" {
  statement_id = "AllowEventBridgeInvokeSecurityAudit"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.security_group_audit.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.security_group_audit_rule.arn
}