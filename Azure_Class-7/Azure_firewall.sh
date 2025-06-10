#Azure firewall restrict the incoming and outgoing traffic through firewall subnet.
#ingress/inbound traffic  and Egress/outbound traffic


#create azure firewall in HUB-RG on azure Firewall subnet.


#Create windows server SP-1 and linux make sure srvers are should be public.
RG="SPOKE-1-RG"

az vm create --resource-group ${RG} --name SP1-WINSVR1 --image Win2022Datacenter --vnet-name ${RG}-vNET1 \
    --subnet SPOKE-1-Private-subnet-1 --admin-username devulmah --admin-password "Mahesh@123456" --size Standard_B2ms \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.10.2.11 \
    --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete --security-type Standard --public-ip-address ""

#Create windows server sp-2
RG="SPOKE-2-RG"

az vm create --resource-group ${RG} --name SP1-WINSVR1 --image Win2022Datacenter --vnet-name ${RG}-vNET1 \
    --subnet SPOKE-2-Private-subnet-1 --admin-username devulmah --admin-password "Mahesh@123456" --size Standard_B2ms \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 192.168.2.11 \
    --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete --security-type Standard --public-ip-address ""

#connect sp-1 windows servers 
#check browser it is connecting or not.
#connect sp-2 windows server.
#check the sp-2 windows server connctivity.
#for checking download any files. you will get clarity.
#check whaether the servers go to internet or not through network watcher 
#network watcher -->> hop -->> select RG-->> vnet-->> vm ip-->> destination-->> 8.8.8.8-->> next hop

# if the next hop type is looking as internet -->> means traffic  directly connected to internet with out any disruption.

# system table id looks like system route.
# so we are using route table to avoid this direct connnection to internet.
# create route table. for sp-1

# WE can apply route table at subnet level.
# go to route table -->> setting -->> routes -->>add routes -->> add internet ip 0.0.0.0/0 -->> next hop Click on virtual applience -->> provide the Firewall ip.
# add to subnets.subnet-1 and subnet-2
#Create the route same as above one for spoke-2-RG.
#We can not use same route table for routing firewall traffic on sp-1 and sp-2 if both are different region.

