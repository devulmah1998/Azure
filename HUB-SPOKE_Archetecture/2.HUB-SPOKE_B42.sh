#HUG RG CREATION
RG='AZB42-HUB-RG'

az group create --location eastus -n ${RG}

az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.42.0.0/16 \
    --subnet-name jump-svr-subnet-1 --subnet-prefix 10.42.1.0/24 -l eastus
az network vnet subnet create -g ${RG} --vnet-name ${RG}-vNET1 -n AzureFirewallSubnet \
    --address-prefixes 10.42.10.0/24
az network vnet subnet create -g ${RG} --vnet-name ${RG}-vNET1 -n AzureBastionSubnet \
    --address-prefixes 10.42.20.0/24
az network vnet subnet create -g ${RG} --vnet-name ${RG}-vNET1 -n GatewaySubnet \
    --address-prefixes 10.42.30.0/24
az network vnet subnet create -g ${RG} --vnet-name ${RG}-vNET1 -n EP-Subnet-1 \
    --address-prefixes 10.42.40.0/24

echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name HUBLINUXVM01 --image $IMAGE --vnet-name ${RG}-vNET1 \
    --subnet jump-svr-subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.42.1.4 \
    --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete --security-type Standard

az vm create --resource-group ${RG} --name HUBVM1 --image Win2022Datacenter --vnet-name ${RG}-vNET1 \
    --subnet jump-svr-subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2ms \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.42.1.5 \
    --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete --security-type Standard

#AZB42-SP1-RG CREATION
RG='AZB42-SP1-RG'

az group create --location eastus -n ${RG}

az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 172.16.0.0/16 \
    --subnet-name ${RG}-Subnet-1 --subnet-prefix 172.16.1.0/24 -l eastus

echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name SP1-LNXSVR1 --image $IMAGE --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.1.10 \
    --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete --security-type Standard --public-ip-address ""

az vm create --resource-group ${RG} --name SP1-WINSVR1 --image Win2022Datacenter --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2ms \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.1.11 \
    --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete --security-type Standard --public-ip-address ""

#AZB42-SP2-RG CREATION
RG='AZB42-SP2-RG'

az group create --location westus -n ${RG}

az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 172.17.0.0/16 \
    --subnet-name ${RG}-Subnet-1 --subnet-prefix 172.17.1.0/24 -l westus

echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1 -l westus
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name SP2-LNXSVR1 --location westus --image $IMAGE --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.17.1.10 \
    --os-disk-delete-option Delete --nic-delete-option Delete --security-type Standard --public-ip-address ""

az vm create --resource-group ${RG} --name SP2-WINSVR1 --image Win2022Datacenter --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2ms \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.17.1.11 \
    --os-disk-delete-option Delete --nic-delete-option Delete --security-type Standard --public-ip-address ""

##################################################
#VNET-PEERINGS
VNet1Id=$(az network vnet show --resource-group AZB40-HUB-RG --name AZB40-HUB-RG-vNET1 --query id --out tsv)
VNet2Id=$(az network vnet show --resource-group AZB40-SP1-RG --name AZB40-SP1-RG-vNET1 --query id --out tsv)
VNet3Id=$(az network vnet show --resource-group AZB40-SP2-RG --name AZB40-SP2-RG-vNET1 --query id --out tsv)

#HUBRG-to-SPOKE1
az network vnet peering create -g AZB40-HUB-RG -n HUB-to-SPOKE1 --vnet-name AZB40-HUB-RG-vNET1 --remote-vnet $VNet2Id --allow-vnet-access
az network vnet peering create -g AZB40-SP1-RG -n SPOKE1-to-HUB --vnet-name AZB40-SP1-RG-vNET1 --remote-vnet $VNet1Id --allow-vnet-access
#HUBRG-to-SPOKE2
az network vnet peering create -g AZB40-HUB-RG -n HUB-to-SPOKE2 --vnet-name AZB40-HUB-RG-vNET1 --remote-vnet $VNet3Id --allow-vnet-access
az network vnet peering create -g AZB40-SP2-RG -n SPOKE2-to-HUB --vnet-name AZB40-SP2-RG-vNET1 --remote-vnet $VNet1Id --allow-vnet-access

##################################################
#ROUTE TABLES
az network route-table create -g AZB40-SP1-RG -n SPOKE1-RT
az network route-table create -g AZB40-SP2-RG -n SPOKE2-RT

#ADDING ROUTES
az network route-table route create -g AZB40-SP1-RG --route-table-name SPOKE1-RT -n TO-FIREWALL --next-hop-type VirtualAppliance --address-prefix 0.0.0.0/0 --next-hop-ip-address 10.1.10.4
az network route-table route create -g AZB40-SP2-RG --route-table-name SPOKE2-RT -n TO-FIREWALL --next-hop-type VirtualAppliance --address-prefix 0.0.0.0/0 --next-hop-ip-address 10.1.10.4

#ADD ROUTE TABLE TO SUBNETS
az network vnet subnet update --name AZB40-SP1-RG-Subnet-1 --vnet-name AZB40-SP1-RG-vNET1 --route-table SPOKE1-RT -g AZB40-SP1-RG
az network vnet subnet update --name AZB40-SP2-RG-Subnet-1 --vnet-name AZB40-SP2-RG-vNET1 --route-table SPOKE2-RT -g AZB40-SP2-RG

#DEPLOY AZURE FIREWALL
#az network firewall create --name AZ-FW1 -g AZB40-HUB-RG --private-ranges 10.1.0.0/16 --location eastus --sku AZFW_VNet

az network vnet-gateway create -g AZB40-HUB-RG -n VNG1 --public-ip-address VNG1-PIP \
    --vnet AZB40-HUB-RG-vNET1 --gateway-type Vpn --sku VpnGw1 --vpn-type RouteBased --no-wait

globaladmin@mavrick202gmail.onmicrosoft.com
Xaxo052422

vpnuser1@mavrick202gmail.onmicrosoft.com
Qafo777145
