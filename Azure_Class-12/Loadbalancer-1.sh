echo '#cloud-config
package_upgrade: true
packages:
- nginx
- stress
- unzip
- jq
- net-tools
- curl

runcmd:
- service nginx restart
- systemtl enable nginx
- echo "<h1>$(cat /etc/hostname)</h1>" >>/var/www/html/index.nginx-debian.html' > cloud-init.txt

RG="LB-1"
echo "Creating Azure Resource Group"
az group create --location eastus -n ${RG}
 
echo "Creating Azure Virtual Network"
az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.47.0.0/16 \
--subnet-name ${RG}-Subnet-1 --subnet-prefix 10.47.1.0/24 -l eastus

az network nsg create -g ${RG} -n ${RG}_NSG1 --location eastus
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'     --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow     --protocol Tcp --description "Allowing All Traffic For Now"

RG="LB-1"
LOCATION="eastus"
VNET_NAME="${RG}-vNET1"
SUBNET_NAME="${RG}-Subnet-1"
NSG_NAME="${RG}_NSG1"
ADMIN_USERNAME="devulmah"
ADMIN_PASSWORD='~!Mahesh@123'  # single quotes prevent Bash expansion
IMAGE="Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest"
CLOUD_INIT="cloud-init.txt"
STORAGE_SKU="StandardSSD_LRS"

#Create the VM's webser1, webser2,webser3.
az vm create \
  --resource-group $RG \
  --name WEBser1 \
  --image $IMAGE \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --admin-username $ADMIN_USERNAME \
  --authentication-type password \
  --admin-password "$ADMIN_PASSWORD" \
  --size Standard_B1s \
  --storage-sku $STORAGE_SKU \
  --nsg $NSG_NAME \
  --custom-data $CLOUD_INIT \
  --location $LOCATION


az vm create \
  --resource-group $RG \
  --name WEBser2 \
  --image $IMAGE \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --admin-username $ADMIN_USERNAME \
  --authentication-type password \
  --admin-password "$ADMIN_PASSWORD" \
  --size Standard_B1s \
  --storage-sku $STORAGE_SKU \
  --nsg $NSG_NAME \
  --custom-data $CLOUD_INIT \
  --location $LOCATION

az vm create \
  --resource-group $RG \
  --name WEBser3 \
  --image $IMAGE \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --admin-username $ADMIN_USERNAME \
  --authentication-type password \
  --admin-password "$ADMIN_PASSWORD" \
  --size Standard_B1s \
  --storage-sku $STORAGE_SKU \
  --nsg $NSG_NAME \
  --custom-data $CLOUD_INIT \
  --location $LOCATION
az vm create \
  --resource-group $RG \
  --name WEBser4 \
  --image $IMAGE \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --admin-username $ADMIN_USERNAME \
  --authentication-type password \
  --admin-password "$ADMIN_PASSWORD" \
  --size Standard_B1s \
  --storage-sku $STORAGE_SKU \
  --nsg $NSG_NAME \
  --custom-data $CLOUD_INIT \
  --location $LOCATION

# Create the load balancer create public ip, and add above server as backend pool. 
# Add inbound rule as 80 as of now.
# Create the load balancer add het the public ip of the SLB.
# I am able to see webser1 and webser2 by using SLB public ip.
# By using GO dadDY DNS we will test the LB traffic using dns name, not with slb public ip address.
# We can do load balancing for TCP 22 port also ssh.( randomly connecting the servers through slb public ip).
while true
do
curl -sL http://135.237.54.12/ | grep -i WEBser
sleep 1
done

# when ever we removing Public ip address on the all vm's , SLB load balancer Ip address assigned to it.
# Create inbound NAT rules to connect the servers through SLB , with public ip of the servers.
# 

watch ls

for I in {1..4}
do
az network nic create -g AZB48SLB --vnet-name ${RG}-vNET1 --subnet ${RG}-Subnet-1 -n WebSvr${I}VMNic${I}
done

Adding additinal NICs and Secondary IPs for existing NIC didnt resoslved the issue with NAT Rules.



# For Private Link Setup
RG=ALPHACUST
echo "Creating Azure Resource Group"
az group create --location eastus -n ${RG}
 
echo "Creating Azure Virtual Network"
az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.47.0.0/16 \
--subnet-name ${RG}-Subnet-1 --subnet-prefix 10.47.1.0/24 -l eastus

az network nsg create -g ${RG} -n ${RG}_NSG1 --location eastus
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'     --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow     --protocol Tcp --description "Allowing All Traffic For Now"

IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'

az vm create -g ${RG} -n AlphaSvr --image  $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s --storage-sku StandardSSD_LRS --private-ip-address 10.47.1.100 --zone 1 --nsg ${RG}_NSG1 --nic-delete-option Delete --os-disk-delete-option Delete 

watch ls