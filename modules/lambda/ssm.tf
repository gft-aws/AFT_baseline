resource "aws_ssm_parameter" "test_ssm_ao" {
  name  = "AFT_lambda_SSO_list"
  type  = "StringList"
  value = var.ssm_value
}
