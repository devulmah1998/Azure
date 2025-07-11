#Establish the connection between the AWS and azure.
#create hub and spoke in azure
#create one vpc and 2 virtual machines with the ip address range 19.168.0.0/16, vm1-192.168.1.100, vm2-192.168.1.200
#Create linux server in HUB vnet, windows servers for spoke 1 and spoke 2.
#Change spoke-1 vnet  DNS server -->>custom DNS with 192.168.1.100. [aws server ip]. same as Spoke-2.
#JumpServerSubnet
#create bstion host in hub.
#go to windows server which is crated on aws.
#Open cmd type ipconfig /all it will give all the info , dns info.
#type ncpa.cpl it will promt to network connection page.
#Go to ipv4 option change dns adress which is own server ip. 192.168.1.100 and give on dns ip address 192.168.0.2.
#install active directory and telnet client in the aws windows server using server manager console.
#when install active directory we will get one yelow color pop-up, click on promote this service to domain controller.
#




