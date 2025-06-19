#We have two type of security groups 1) Network security group 2) Application security group.

# NSG (Network security groups) are applicable for on subnet leval and Interface level (NIc's) on vm's.
# Create one new RG
#Application security groups is nothing but group of vm's based on their roles like web,app,db.
#Service tags: grouping of public ip's based on their service.
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

RG=AZB48ASG
echo "Creating Azure Resource Group"
az group create --location eastus -n ${RG}
 
echo "Creating Azure Virtual Network"
az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.1.0.0/16 \
--subnet-name ${RG}-Subnet-1 --subnet-prefix 10.1.1.0/24 -l eastus

az network nsg create -g ${RG} -n ${RG}_NSG1 --location eastus

IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'

az vm create -g ${RG} -n WEBVM1 --image $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s --storage-sku StandardSSD_LRS --nsg ${RG}_NSG1 --custom-data cloud-init.txt

az vm create -g ${RG} -n APPVM1 --image $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s --storage-sku StandardSSD_LRS --nsg ${RG}_NSG1 --custom-data cloud-init.txt

az vm create -g ${RG} -n DBVM1 --image $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2s --storage-sku StandardSSD_LRS --nsg ${RG}_NSG1 --custom-data cloud-init.txt

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
telnet 10.1.1.6 3306