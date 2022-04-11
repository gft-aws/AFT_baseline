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
                "arn:aws:ssm:us-east-1:308710073022:*"
            ]
        },
        {
            "Sid": "AWSSSOReadOnly",
            "Effect": "Allow",
            "Action": [
                "ds:DescribeDirectories",
                "ds:DescribeTrusts",
                "iam:ListPolicies",
                "identitystore:*",
                "sso:Describe*",
                "sso:Get*",
                "sso:List*",
                "sso:Create*",
                "sso:Search*",
                "sso-directory:DescribeDirectory"
            ],
            "Resource": "*"
        }
    ]
}
