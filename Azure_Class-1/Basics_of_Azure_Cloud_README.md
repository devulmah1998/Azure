Azure basics:-
—------------------
An Azure region is a geographical area where Microsoft has one or more data centers, used to deploy and manage cloud resources.

Each region is isolated and independent.


Microsoft has 60+ regions worldwide (more than any other cloud provider).


You choose a region based on compliance, latency, and availability.

What is an Availability Zone?
—-----------------------------------------
An Availability Zone is a physically separate data center within an Azure region. Each zone is made up of:
Independent power


Cooling


Networking


Most regions that support AZs have at least 3 zones.




⇒ Every region interconnected with each other.

⇒ Every region may have multiple data centers based on capacity and        availability.
         Azure provides High availability based on region architecture and multi data centers.
Inside an Azure data center, Microsoft deploys a highly controlled and secure environment that hosts the physical infrastructure for all Azure services. 
⇒ Components are 1) racks , network components, storage.
⇒ Azure data centers are hyper-scale environments that provide:
Compute (VMs, containers)


Storage (disks, blobs, databases)


Networking (public/private connectivity)


All with redundant, secure, and scalable infrastructure
Logical Hierarchy : 
+++++++++++++++++++
⇒ Whenever we create an Azure account one tenant will be created.
⇒ We can use tenant id for multiple business purposes.
⇒  1) ms 360 (saas) 2) ms azure public cloud 3) ms dynamics (saas CRM)
Microsoft azure public cloud
   ||
   ||
Subscriptions
   ||
   ||
Resource groups
  ||
  ||
Resources.


               
Note: If we create resource groups in Eastus, we can create the resources under resource groups in different regions.
