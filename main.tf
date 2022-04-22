provider "aws" {
  region = var.aws_region
}

data "archive_file" "lambda_test" {
  type = "zip"

  source_file = "${path.module}/lambda_code/lambda_sso_permissions.py"
  output_path = "lambda_code.zip"
}

resource "aws_iam_role" "iam_lambda_sso" {
  name = "iam_lambda_sso"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam_lambda_policy" {
  name = "iam_lambda_policy"
  role = aws_iam_role.iam_lambda_sso.id
  policy = templatefile("${path.module}/iam-policy.tpl", {
    data_aws_region_current_name                = data.aws_region.current.name
    data_aws_caller_identity_current_account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_lambda_function" "lambda_sso" {
  filename      = "lambda_code.zip"
  function_name = "lambda_sso_permissions"
  role          = aws_iam_role.iam_lambda_sso.arn
  handler       = "lambda_sso_permissions.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("lambda_code.zip")
  timeout           = 180
}

resource "aws_ssm_parameter" "AFT_lambda_ssm" {
  name  = "AFT_lambda_SSO_list"
  type  = "StringList"
  value = var.ssm_value
}


resource "aws_cloudwatch_event_rule" "lambda_event_rule" {
  name          = "lambda-event-rule"
  description   = "run at every account creation"
  event_pattern = <<EOF
  {
    "eventName": [
        "CreateAccountResult"
    ],
    "source": [
        "aws.controltower"
    ],
    "state": [
        "SUCCEEDED"
    ],
    "eventsource": [
        "organizations.amazonaws.com"
    ]
  }
  EOF
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  arn  = aws_lambda_function.lambda_sso.arn
  rule = aws_cloudwatch_event_rule.lambda_event_rule.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_trigger_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_sso.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_event_rule.arn
}

