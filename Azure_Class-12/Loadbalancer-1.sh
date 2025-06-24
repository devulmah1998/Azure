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

RG=LB-1
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

az vm create -g ${RG} -n WebSvr1 --image  $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s --storage-sku StandardSSD_LRS --private-ip-address 10.47.1.100 --zone 1 --nsg ${RG}_NSG1 --nic-delete-option Delete --os-disk-delete-option Delete --custom-data cloud-init.txt

az vm create -g ${RG} -n WebSvr2 --image  $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s --storage-sku StandardSSD_LRS --private-ip-address 10.47.1.101 --zone 2 --nsg ${RG}_NSG1 --nic-delete-option Delete --os-disk-delete-option Delete --custom-data cloud-init.txt

az vm create -g ${RG} -n WebSvr3 --image  $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s --storage-sku StandardSSD_LRS --private-ip-address 10.47.1.102 --zone 3 --nsg ${RG}_NSG1 --nic-delete-option Delete --os-disk-delete-option Delete --custom-data cloud-init.txt

az vm create -g ${RG} -n WebSvr4 --image  $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s --storage-sku StandardSSD_LRS --private-ip-address 10.1.1.103 --zone 3 --nsg ${RG}_NSG1 --nic-delete-option Delete --os-disk-delete-option Delete --custom-data ./clouddrive/cloud-init.txt

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
