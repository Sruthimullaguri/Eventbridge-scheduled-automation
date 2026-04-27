resource "aws_sns_topic" "automation_topic" {
  name = "${var.project_name}-notifications"
  tags = {
    Name        = "${var.project_name}-sns-topic"
    Environment = var.environment
    Purpose     = "eventbridge-automation-reporting"
  }
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.automation_topic.arn
  protocol  = "email"
  endpoint  = var.email_endpoint
}