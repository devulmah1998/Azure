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
# by using routing table we are changing the trafic which is going to internet directly to firewall
# Add routes to subnet means traffic should go to firewall sp1 and sp2
# We are not able to connect sp-1 vm's and sp-2 vm's directly. only option we have that is through bastion host or just serer.
# connect through bastion host. sp1 server and sp2 server, type mstsc in bastion server it will trigger rdp.
#check internet connection of the server by using chrome after connecting through bstion host RDP.
#in firewall we have 3 types of rules
    #1) Network firewall rule --->> based on IP addesses and ports we can block. internal communications. like frontend  to back end and backend to database.

    #2) Application firewall rule. -->> which is configured application level ouside. like we can block facebook.

    #3) DNAT rules --->> coenncting to Internet.
#if you want to allow internet to sp-1 and sp-2 we have to change policies of the firewall.
# Click on Fire policy which is created at the time of Creating Firewall.
# Createing Network rules. network collection group -->> rule-group-->> rule collections-->> rules
# You can network watcher HOP it will route to firewall.





