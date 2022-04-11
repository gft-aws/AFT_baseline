resource "aws_ssm_parameter" "AFT_lambda_ssm" {
  name  = "AFT_lambda_SSO_list"
  type  = "StringList"
  value = var.ssm_value
}
