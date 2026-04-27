# EC2 Scheduler Lambda

resource "aws_lambda_function" "ec2_scheduler" {
  function_name = "${var.project_name}-ec2-scheduler"
  role = aws_iam_role.lambda_execution_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  filename = "../lambdas/ec2_scheduler/ec2_scheduler.zip"
  source_code_hash = filebase64sha256(
    "../lambdas/ec2_scheduler/ec2_scheduler.zip"
  )
  timeout = 30
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.automation_topic.arn
      ENVIRONMENT   = var.environment
    }
  }
  tags = {
    Name        = "${var.project_name}-ec2-scheduler"
    Environment = var.environment
  }
}

# Snapshot Cleanup Lambda

resource "aws_lambda_function" "snapshot_cleanup" {
  function_name = "${var.project_name}-snapshot-cleanup"
  role = aws_iam_role.lambda_execution_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  filename = "../lambdas/snapshot_cleanup/snapshot_cleanup.zip"
  source_code_hash = filebase64sha256(
    "../lambdas/snapshot_cleanup/snapshot_cleanup.zip"
  )
  timeout = 60
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.automation_topic.arn
      ENVIRONMENT   = var.environment
    }
  }
  tags = {
    Name        = "${var.project_name}-snapshot-cleanup"
    Environment = var.environment
  }
}

# Security Group Audit Lambda

resource "aws_lambda_function" "security_group_audit" {
  function_name = "${var.project_name}-security-group-audit"
  role = aws_iam_role.lambda_execution_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  filename = "../lambdas/security_group_check/security_group_check.zip"
  source_code_hash = filebase64sha256(
    "../lambdas/security_group_check/security_group_check.zip"
  )
  timeout = 30
  environment {
    variables = {
     SNS_TOPIC_ARN = aws_sns_topic.automation_topic.arn
     ENVIRONMENT   = var.environment
     DRY_RUN       = "false"
    }
  }
  tags = {
    Name        = "${var.project_name}-security-group-audit"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops-team"
  }
}