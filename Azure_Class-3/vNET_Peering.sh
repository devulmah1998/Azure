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

#Creating VM in JUMserverSubnet public
RG="HUB-RG"
IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'
echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name HUB-LINUXSVR-1-JMP --image $IMAGE --vnet-name HUB-RG-vNET1 \
--subnet  Jumpserversubnet  --admin-username devulmah --admin-password "Mahesh@123456" --size Standard_B1s \
--nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.50.257.1 \
--os-disk-delete-option Delete --nic-delete-option Delete --public-ip-address ""


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




