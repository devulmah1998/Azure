#We have two type of security groups 1) Network security group 2) Application security group.

# NSG (Network security groups) are applicable for on subnet leval and Interface level (NIc's) on vm's.
# Create one new RG
#Application security groups is nothing but group of vm's based on their roles like web,app,db.
#Service tags: grouping of public ip's based on their service.
#We we want to establish a communications between the vm's, The firewall would be use.1
#cloud-config


package_upgrade: true
packages:
- nginx
- stress
- unzip
- jq
- net-tools
- curl
- tree

runcmd:
- service nginx restart
- systemtl enable nginx
- echo "<h1>$(cat /etc/hostname)</h1>" >>/var/www/html/index.nginx-debian.html

RG="NSG_RG"
echo "Creating Azure Resource Group"
az group create --location eastus -n ${RG}
 
echo "Creating Azure Virtual Network"
az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.1.0.0/16 \
--subnet-name ${RG}-Subnet-1 --subnet-prefix 10.1.1.0/24 -l eastus

az network nsg create -g ${RG} -n ${RG}_NSG1 --location eastus

RG="NSG_RG"
LOCATION="eastus"
VNET_NAME="${RG}-vNET1"
SUBNET_NAME="${RG}-Subnet-1"
NSG_NAME="${RG}_NSG1"
ADMIN_USERNAME="devulmah"
ADMIN_PASSWORD='~!Mahesh@123'  # single quotes prevent Bash expansion
IMAGE="Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest"
CLOUD_INIT="cloud-init.txt"
STORAGE_SKU="StandardSSD_LRS"

# Create Web VM
az vm create \
  --resource-group $RG \
  --name WEBVM1 \
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

# Create App VM
az vm create \
  --resource-group $RG \
  --name APPVM1 \
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

# Create DB VM
az vm create \
  --resource-group $RG \
  --name DBVM1 \
  --image $IMAGE \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --admin-username $ADMIN_USERNAME \
  --authentication-type password \
  --admin-password "$ADMIN_PASSWORD" \
  --size Standard_B2s \
  --storage-sku $STORAGE_SKU \
  --nsg $NSG_NAME \
  --custom-data $CLOUD_INIT \
  --location $LOCATION



#Application security Groups:
# Arbitarily grouping of vm's ( Selceting vm's and grouping them like app vm's, db vm's).
az vm create -g ${RG} -n WEBVM2 --image $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s --storage-sku StandardSSD_LRS --nsg ${RG}_NSG1 --asgs WEB_ASG --custom-data cloud-init.txt

az vm create -g ${RG} -n APPVM2 --image $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s --storage-sku StandardSSD_LRS --nsg ${RG}_NSG1 --asgs APP_ASG --custom-data cloud-init.txt

az vm create -g ${RG} -n DBVM2 --image $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s --storage-sku StandardSSD_LRS --nsg ${RG}_NSG1 --asgs DB_ASG --custom-data cloud-init.txt


watch ls

az network asg create --name WEB_ASG --resource-group ${RG} --location eastus
az network asg create --name APP_ASG --resource-group ${RG} --location eastus
az network asg create --name DB_ASG --resource-group ${RG} --location eastus

sudo apt install mysql-server -y
sudo systemctl start mysql.service
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
bind-address            = *
sudo systemctl restart mysql.service
telnet 10.1.1.6 3306# Variables
