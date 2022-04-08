{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "ssm:Describe*",
            "ssm:Get*",
            "ssm:List*"
          ],
            "Resource": [
            "arn:aws:ssm:${data_aws_region_current_name}:${data_aws_caller_identity_current_account_id}:*"
            ]
    },
    {
            "Sid": "AWSSSOReadOnly",
            "Effect": "Allow",
            "Action": [
                "ds:DescribeDirectories",
                "ds:DescribeTrusts",
                "iam:ListPolicies",
                "organizations:DescribeOrganization",
                "organizations:DescribeAccount",
                "organizations:ListParents",
                "organizations:ListChildren",
                "organizations:ListAccounts",
                "organizations:ListRoots",
                "organizations:ListAccountsForParent",
                "organizations:ListOrganizationalUnitsForParent",
                "sso:Describe*",
                "sso:Get*",
                "sso:List*",
                "sso:Search*",
                "sso-directory:DescribeDirectory"
            ],
            "Resource": [
            "arn:aws:sso:${data_aws_region_current_name}:${data_aws_caller_identity_current_account_id}:*"
            ]
        }
    
  ]
}
