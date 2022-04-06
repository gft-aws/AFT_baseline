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



"Version": "2012-10-17",
"Statement": [
{
"Action": "sts:AssumeRole",
"Principal": {
"Service": "lambda.amazonaws.com"
},
"Effect": "Allow",
"Sid": ""
}
]
})
}



resource "aws_lambda_function" "lambda_sso" {
filename = "lambda_code.zip"
function_name = "lambda_sso_permissions"
role = aws_iam_role.iam_lambda_sso.arn
handler = "lambda_sso_permissions.lambda_handler"



runtime = "python3.9"
source_code_hash = filebase64sha256("lambda_code.zip")

}



resource "aws_iam_role_policy_attachment" "lambda_sso_policy" {
role = aws_iam_role.iam_lambda_sso.name
policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



resource "aws_iam_role_policy_attachment" "lambda_sso_policy2" {
role = aws_iam_role.iam_lambda_sso.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}



resource "aws_iam_role_policy_attachment" "lambda_sso_policy3" {
role = aws_iam_role.iam_lambda_sso.name
policy_arn = "arn:aws:iam::aws:policy/AWSSSOReadOnly"
}



resource "aws_iam_role_policy_attachment" "lambda_sso_policy4" {
role = aws_iam_role.iam_lambda_sso.name
policy_arn = "arn:aws:iam::aws:policy/AWSSSODirectoryAdministrator"
}



resource "aws_iam_role_policy_attachment" "lambda_sso_policy5" {
role = aws_iam_role.iam_lambda_sso.name
policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
