variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable ssm_value {
    type = string
    description = "Stringlist of group names and corresponding permissions names in an AFT created account"
    default = "SSO:DataEngineer,SSO:AdministratorAccess,SSO:PowerUserAccess,DataEngineer:DataEngineer,DataEngineer:AdministratorAccess,test-mk:AdministratorAccess,test-mk:PowerUserAccess"
}