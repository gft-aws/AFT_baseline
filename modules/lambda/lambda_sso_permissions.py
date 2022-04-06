import json
import boto3
def lambda_handler(event, context):
    # Calling group and permission set from perameter store
    client = boto3.client('ssm')
    resp = client.get_parameter( Name = 'sso_list')
    list_group_and_permission_set = resp['Parameter']['Value']
    # Converting StringList into list
    list_group_and_permission_set = list_group_and_permission_set.split(",")
    # Spliting list string into two 
    b=[]
    for i in list_group_and_permission_set:
     b+=i.split(":")
    new_list = b
    # Converting list into two seperate lists - i) GroupNames and ii) Permission Set
    group_list_names = []
    permission_set_names = []
    for i in range(0, len(new_list), 2):
        group_list_names.append(new_list[i])
    for i in range(1, len(new_list), 2):
        permission_set_names.append(new_list[i])
    print(group_list_names)
    print(permission_set_names)
  ###########################################################  
    ## Instance arn & Identity store 
    client = boto3.client('sso-admin')
    instance = client.list_instances()
    for d in instance["Instances"]:
       instance_arn = (d['InstanceArn'])
       identitystore_id = (d['IdentityStoreId'])
    ## Target id 
    target_id=(event['serviceEventDetails']['createAccountStatus']['accountId'])
    ## Feching group Ids for corresponding group name
    client = boto3.client('identitystore')
    list_group_id=[]
    for gn in group_list_names:
        groups = client.list_groups(
            IdentityStoreId = identitystore_id,
            Filters=[
                {
                    'AttributePath': 'DisplayName',
                    'AttributeValue': gn
                },
            ]
        )
        for g in groups['Groups']:
            groupid = (g["GroupId"])
        list_group_id.append(groupid)
    ## Feching permission ARN for corresponding Permission set
    client = boto3.client('sso-admin')
    list_permission_set_arn=[]
    permissions = client.list_permission_sets(
        InstanceArn= instance_arn
    )
    for p in permission_set_names:
        for pn in permissions['PermissionSets']:
            response = client.describe_permission_set(
                InstanceArn=instance_arn,
                PermissionSetArn=pn
            )
            if (response['PermissionSet']['Name']==p):
                list_permission_set_arn.append(pn),
    ## Assigning permissions sets and groups to the account created 
    for i in range(len(group_list_names)):
        response = client.create_account_assignment(
            InstanceArn= instance_arn,
            TargetId=target_id,
            TargetType='AWS_ACCOUNT',
            PermissionSetArn=list_permission_set_arn[i],
            PrincipalType='GROUP',
            PrincipalId=list_group_id[i]
        )
    #print('event:', json.dumps(event))