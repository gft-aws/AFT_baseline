
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
  arn  = var.LambdaARN
  rule = aws_cloudwatch_event_rule.lambda_event_rule.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_trigger_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.LambdaName
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_event_rule.arn
}
