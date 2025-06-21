#If we want to establish the communicationbetween the two services internally in azure we have concept
# called as Managed identities.
# 1) System assigned identities 2) user assigned identities.
# system assigned identities is one to one mapping between the resource and identity, like if you enable on enable on server level identity is mapped to the that particular server if you delete that server the identity also will deleted.
# user assigned identity is stand alone identity it we can create alone and use it's not depended on one resource, we can assign this to multiple resources.

# we store the secret key and  aws access key in key vaults service.
# we can connect the aws services from the azure server by accessing the key-vaults informations or credentials.
# server==>> key-vaults==>>connects to internet publicly. and get the information from the aws.
# with out connecting to internet we can go with private endpointsubnet it will create one interface it will used to connect the services through the public ip's.
#keyvault create
az keyvault create   --name keyvault1-mahesh  --resource-group HUB-RG-1   --location eastus
#keyvault: adding aws keys
az keyvault secret set \
  --vault-name keyvault1-mahesh \
  --name "AWSAccessKeyID" \
  --value "AKIA4K2UAPDWQMKI4KUM"
#----------------------------------------------------------------------
az keyvault secret set \
  --vault-name keyvault1-mahesh \
  --name "AWSSecretAccessKey" \
  --value "seegheh"

# If a VM with system-assigned identity needs to read secrets from a Key Vault:

# Assign Key Vault Secrets User role to the VM’s identity on that Key Vault using IAM.

# disable the public acccess in the azure key-vault networking dropdown.

# privateendpointsubnet interface directly connected to key-vaults.
# jumpserver traffic routed to privateendpoint interface through name resolution(Private dns zone will be created) than reached to key-valults directly.

apt update && apt install -y python3-pip
pip3 install azure-keyvault-secrets 

pip3 install azure.identity

pip3 install boto3

pip3 install ipython 

# enter this one if the traffic is routed to public or ptivate below one
   nslookup azureb46kv.vault.azure.net    -- #it will show you

# from azure.keyvault.secrets import SecretClient
from azure.identity import DefaultAzureCredential
import boto3
key_vault_name = "azureb46kv"
key_vault_uri = f"https://azureb46kv.vault.azure.net"
secret_name2 = "aws-access-key"
secret_name3 = "aws-secret-key"
credential = DefaultAzureCredential()
client = SecretClient(vault_url=key_vault_uri, credential=credential)
retrieved_secret2 = client.get_secret(secret_name2)
retrieved_secret3 = client.get_secret(secret_name3)

print(f"The value of secret '{secret_name2}' in '{key_vault_name}' is: '{retrieved_secret2.value}'")
print(f"The value of secret '{secret_name3}' in '{key_vault_name}' is: '{retrieved_secret3.value}'")

client = boto3.client('ec2',region_name="us-east-1",
                    	aws_access_key_id=retrieved_secret2.value,
                    	aws_secret_access_key=retrieved_secret3.value)

#List VPC
vpcs = client.describe_vpcs().get('Vpcs',[])
for vpc in vpcs:
  print(vpc['VpcId'],'----->',vpc['CidrBlock'])

#List S3 Bucket
client = boto3.client('s3',region_name="us-east-1",
     	aws_access_key_id=retrieved_secret2.value,
     	aws_secret_access_key=retrieved_secret3.value)
bucks = client.list_buckets().get('Buckets')
for bucket in bucks:
 print(bucket['Name'])


#  same we can connect to sp1 and sp2 resources.
#  to connect sp1 and sp2 we have to add private links in the ==>> private dns zones service for name resolution purpose.





