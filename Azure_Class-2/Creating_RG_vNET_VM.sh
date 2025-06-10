#! /bin/bash
RG=AZURESQL
echo "Creating Azure Resource Group"
az group create --location eastus -n ${RG}
 
echo "Creating Azure Virtual Network"
az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.1.0.0/16 \
--subnet-name ${RG}-Subnet-1 --subnet-prefix 10.1.1.0/24 -l eastus


az vm create --resource-group ${RG} --name WINVM1 --image Win2022Datacenter --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2ms --storage-sku StandardSSD_LRS \
--nsg ""


#az group delete --name <YourResourceGroupName> --yes --no-wait

#az vm delete --name MyVM --resource-group MyGroup --yes

#az disk delete --name MyDisk --resource-group MyGroup --yes

#az network vnet delete --name MyVNet --resource-group MyGroup

#az storage account delete --name mystorageacct --resource-group MyGroup --yes
