# DNAT changes the destination IP address of incoming traffic, allowing external clients to access internal resources 
# We can connect to a Windows server in a spoke virtual network from outside the network range using DNAT (Destination Network Address Translation) firewall rules — but it requires proper configuration.
# Typical Use Case:
# You want to:

# Connect to a Windows server in a spoke VNet (e.g., using RDP 3389)

# From the internet or another external network (like on-premises)

# Through an Azure Firewall deployed in the hub network

#  Required Architecture :
# 🔹1. Hub-Spoke Topology
# Hub VNet contains the Azure Firewall

# Spoke VNet contains the Windows Server

# VNet peering is established between Hub ↔ Spoke

# 🔹2. Public IP for Azure Firewall
# The firewall must have a Public IP to receive traffic from the internet

########################################################################################
# Inbound traffic on a specific port (e.g., RDP 3389)

# From the public IP of the firewall

# To the private IP of the Windows server in the spoke

# Source : Our system public ip.
# Destination Firewall add: Public ip of the Firewall. port is as our wish.
# Translated ip addr: Private ip of the Spoke windows server with port 3389  for windows.ping3
