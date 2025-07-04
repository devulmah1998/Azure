#azure bastion host
#How to make subnets private and disable deafault outbound access.
#allow internet access for private subnets using NAT GATEWAY.
#Craete log analytics work space and enable logging for bastion.


#Creating HUB-RG and With HUB-RG creating HUB-VNET and Subnets.
 #!/bin/bash

RG="HUB-RG"
VNET_NAME="${RG}-vNET1"
LOCATION="eastus"

echo "Creating Azure Resource Group"
az group create --location $LOCATION --name $RG

echo "Creating Azure Virtual Network"
az network vnet create \
  --resource-group $RG \
  --name $VNET_NAME \
  --location $LOCATION \
  --address-prefix 10.50.0.0/16 \
  --subnet-name ${RG}-Subnet-1 \
  --subnet-prefix 10.50.1.0/24

echo "Creating Gateway Subnet"
az network vnet subnet create \
  --name GatewaySubnet \
  --resource-group $RG \
  --vnet-name $VNET_NAME \
  --address-prefix 10.50.254.0/27

echo "Creating Azure Firewall Subnet"
az network vnet subnet create \
  --name AzureFirewallSubnet \
  --resource-group $RG \
  --vnet-name $VNET_NAME \
  --address-prefix 10.50.255.0/26

echo "Creating Azure Bastion Subnet"
az network vnet subnet create \
  --name AzureBastionSubnet \
  --resource-group $RG \
  --vnet-name $VNET_NAME \
  -address-prefix 10.50.256.0/26

echo "Creating Azure Jumpserver subnet"
az network vnet subnet create \
  --name Jumpserversubnet \
  --resource-group $RG \
  --vnet-name $VNET_NAME \
  -address-prefix 10.50.257.0/26

#NSG Creating:
 RG='HUB-RG'
 echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"


#Creating Azure Bastion host
# Variables
RG="HUB-RG"
LOCATION="eastus"
VNET_NAME="HUB-RG-vNET1"
BASTION_NAME="myBastionHost"
PUBLIC_IP_NAME="myBastionIP"

# Create Public IP for Bastion
az network public-ip create \
  --resource-group $RG \
  --name $PUBLIC_IP_NAME \
  --sku Standard \
  --location $LOCATION \
  --allocation-method Static

# Deploy Bastion Host
az network bastion create \
  --name $BASTION_NAME \
  --resource-group $RG \
  --vnet-name $VNET_NAME \
  --location $LOCATION \
  --public-ip-address $PUBLIC_IP_NAME \
  --subnet AzureBastionSubnet



#Creating SPOKE -1-RG And SPOKE-1-vNET1 With one subnet.

RG="SPOKE-1-RG"
VNET_NAME="SPOKE-1-RG-vNET1"
LOCATION="eastus"

echo "Creating Azure Resource Group"
az group create --location $LOCATION --name $RG

echo "Creating Azure Virtual Network"
az network vnet create \
  --resource-group $RG \
  --name $VNET_NAME \
  --location $LOCATION \
  --address-prefix 172.10.0.0/16 \
  --subnet-name ${RG}-PublicSubnet-1 \
  --subnet-prefix 172.10.1.0/24

  #Creating Private subnet for spoke-2
  RG="SPOKE-1-RG"
  VNET_NAME="SPOKE-1-RG-vNET1"
  az network vnet subnet create -g ${RG} --vnet-name ${VNET_NAME} -n ${RG}-PrivateSubnet-1 \
    --address-prefixes 172.10.2.0/24

    #Creating NSG for spoke-1
RG="SPOKE-1-RG"
echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

    #Creating VM's On public subnet and private subnet
    
RG="SPOKE-1-RG"
IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'
echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name SPOKE-1-pub-LNXSVR1 --image $IMAGE --vnet-name SPOKE-1-RG-vNET1 \
--subnet   --subnet-name ${RG}-PublicSubnet-1  --admin-username devulmah --admin-password "Mahesh@123456" --size Standard_B1s \
--nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.10.1.100 \
--os-disk-delete-option Delete --nic-delete-option Delete

#Creating private vm with out public ip.
IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'
echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name SPOKE-1-private-LNXSVR1 --image $IMAGE --vnet-name SPOKE-1-RG-vNET1 \
--subnet   --subnet-name ${RG}-PrivateSubnet-1  --admin-username devulmah --admin-password "Mahesh@123456" --size Standard_B1s \
--nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.10.2.200 \
--os-disk-delete-option Delete --nic-delete-option Delete --public-ip-address ""


#Creating SPOKE-2-RG And SPOKE-2-vNET1

#!/bin/bash
RG="SPOKE-2-RG"
VNET_NAME="SPOKE-2-RG-vNET1"
LOCATION="westus"

echo "Creating Azure Resource Group"
az group create --location $LOCATION --name $RG

echo "Creating Azure Virtual Network"
az network vnet create \
  --resource-group $RG \
  --name $VNET_NAME \
  --location $LOCATION \
  --address-prefix 192.168.0.0/16 \
  --subnet-name ${RG}-PublicSubnet-1 \
  --subnet-prefix 192.168.1.0/24

#Creating private subnet for spoke-2 RG
az network vnet subnet create -g ${RG} --vnet-name ${VNET_NAME} -n ${RG}-PrivateSubnet-1 \
    --address-prefixes 192.168.2.0/24

#Creating NSG for spoke-2
RG="SPOKE-2-RG"
echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1 -l westus
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

#Creating VM on BOth subnets
RG="SPOKE-2-RG"
IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'
echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name SPOKE-2-pub-LNXSVR1 --image $IMAGE --vnet-name SPOKE-1-RG-vNET1 \
--subnet   --subnet-name ${RG}-PublicSubnet-1  --admin-username devulmah --admin-password "Mahesh@123456" --size Standard_B1s \
--nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 192.168.1.100 \
--os-disk-delete-option Delete --nic-delete-option Delete

#Creating private vm with out public ip.
IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'
echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name SPOKE-2-private-LNXSVR1 --image $IMAGE --vnet-name SPOKE-2-RG-vNET1 \
--subnet   --subnet-name ${RG}-PrivateSubnet-1  --admin-username devulmah --admin-password "Mahesh@123456" --size Standard_B1s \
--nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 192.168.2.200 \
--os-disk-delete-option Delete --nic-delete-option Delete --public-ip-address ""


#Vnet peering among hub and spoke 1
#Vnet peering among hub and spoke 2
#vnet peering among spoke and spoke 2

#test the connection amonfg them and server connection.


#Establish the password less communication over the servers.

#Connect the bastion host to public server 
# for private subnets we should crrate NAT gate way to connect internet.
#  note : if Public ip not avaialbel for servers it will connect to internet though Bastion hot.
#  If public ip not available for server and outbound access diable on Subnet called as private subnets and private server
#  If we want to connect the private servers we have to create the NAT Gateway on private subnet.(Every NAT GAteway will have one public ip).

#  we can connect to internet for private servers through using Nate gateway
#  with out need of bastion host we can directly connect the server to internet through NATGATEWAY.

#NATE GATWAY Creation.
RG="SPOKE-1-RG"
LOCATION="eastus"
NAT_GW_NAME="SPOKE-1-NAT-GW"
PUBLIC_IP_NAME="SPOKE-1-NAT-PIP"
VNET_NAME="SPOKE-1-RG-vNET"
SUBNET_NAME="${RG}-PrivateSubnet-1"

# Create Public IP
az network public-ip create \
  --resource-group $RG \
  --name $PUBLIC_IP_NAME \
  --sku Standard \
  --allocation-method Static \
  --location $LOCATION

# Create NAT Gateway
az network nat gateway create \
  --resource-group $RG \
  --name $NAT_GW_NAME \
  --public-ip-addresses $PUBLIC_IP_NAME \
  --location $LOCATION \
  --idle-timeout 10

# Associate NAT Gateway with subnet
az network vnet subnet update \
  --resource-group $RG \
  --vnet-name $VNET_NAME \
  --name $SUBNET_NAME \
  --nat-gateway $NAT_GW_NAME



#Example:
#-----------
#If we can not connect to Vm all settings configured sucssfully. it's up and running also.
# open vm-->>  boot Diagnostics settings -->> enable  with custom storage account --->> underhelp section of VM -->> serial console -->> 
# -->> then it will connected to vm  

# to get the public ip of the server use curl ip config.io
#try to download any file from internet through wget url 



