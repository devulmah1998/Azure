Topics :
---------
1) Types of disks
2) Assigning disk to both linux and winodws servers.
3) Formatting and creating partitions.
------------------------------------------------------------------------------
* When you create a Virtual Machine (VM) in Microsoft Azure, several components and resources are provisioned by default one is disks.
1. OS Disk
   Type: Managed Disk (Standard HDD, Standard SSD, Premium SSD, Ultra Disk depending on VM size and performance needs).

   Purpose: Contains the operating system, system files, and is used to boot the VM.

  Persistence: Persistent – data is retained even after the VM is deallocated or stopped.

  Size: Typically 30–128 GB (default is 127 GB for Windows, 30 GB for Linux, but it can be resized).

 2. Temporary Disk
    Type: Locally attached disk on the physical server hosting the VM (not managed by Azure storage).

    Purpose: Used for page file/swap file, temporary files, or caching.

    Persistence: Non-persistent – data is lost when the VM is deallocated, stopped, or moved to another host (e.g., during maintenance).

    Drive letter: On Windows, it's typically the D:\ drive; on Linux, it's usually mounted to /dev/sdb1 or /mnt.

3. Data Disks
   Type: Managed disks, added manually during or after VM creation.

   Purpose: Store application data, databases, logs, media files, etc.

   Persistence: Persistent – data is retained even if the VM is stopped or deallocated.

   Flexibility: You can attach multiple data disks, depending on the VM size. Each disk can be up to 32 TiB.

Creating Disk:
---------------
  Steps 1: Go to "Disks"
  Steps 2: Click on “+ Create and attach a new disk”.
  Steps 3: select satandard.
* Based on iops and throughput the disk speed is determined.
Throughput: The maximum amount of data that can be transferred per second.
Measured in Megabytes per second (MB/s).
iops: The number of read/write operations the disk can handle per second.

steps 3: encryption make it as default.
steps 4: networking -->> enable allow publicly.
Step  5: shared disk -->> nothing but sharing disk among  multiple vm's. no ( we can make it as yes when we creating the cluster).
steps 6: Create.

Azure CLI:
-----------
# Variables
vmName="myVM"
resourceGroup="myResourceGroup"
diskName="myDataDisk1"
diskSize=128  # in GB
location="eastus"

# Step 1: Create the managed disk
az disk create \
  --resource-group $resourceGroup \
  --name $diskName \
  --size-gb $diskSize \
  --location $location \
  --sku Standard_LRS

# Step 2: Attach the disk to the VM
az vm disk attach \
  --resource-group $resourceGroup \
  --vm-name $vmName \
  --name $diskName

===>> Created disk
===>> Attched disk to VM
===>> Connect VM through putty
===>> type lsblk
===>> check disk added or not.

Formatting steps:
------------------
Example: devulmah@Linux-machine-01:~$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda       8:0    0   30G  0 disk
├─sda1    8:1    0   29G  0 part /
├─sda14   8:14   0    4M  0 part
├─sda15   8:15   0  106M  0 part /boot/efi
└─sda16 259:0    0  913M  0 part /boot
sdb       8:16   0    4G  0 disk
└─sdb1    8:17   0    4G  0 part /mnt
sdc       8:32   0    4G  0 disk
sr0      11:0    1  628K  0 rom
devulmah@Linux-machine-01:~$ sudo fdisk /dev/sdc

Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0x687be824.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-8388607, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-8388607, default 8388607):

Created a new partition 1 of type 'Linux' and of size 4 GiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

devulmah@Linux-machine-01:~$

===>> Enter lsblk command to check the partion under sdc. 
===>> Every partion will have a unique partion I'd.
===>> Enter blkid  ==>> copy the newly created partion id.
===>> mkfs.ext4 /dev/sdc1   ===>> it will create the file system on sdc1 partion.
Mounting:
---------
 1)  Create mount point ===>> sudo mkdir /mnt/datadisk
 2)  Mount the disk    ===>>  sudo mount /dev/sdc1 /mnt/datadisk
 3)  Make the mount persistent ====>> sudo blkid /dev/sdc1

    Edit /etc/fstab: 
    UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /mnt/datadisk ext4 defaults,nofail 0 2

Check after restarting the linux machine.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Creating Windows :-
-----------------
===>> Create one windows machine 
===>> Create one disk which same campatable with windows machine.
===>> Connect through RDP.
===>> Open cmd and enter diskmgmt.msc
===>> add disk to windows vm through azure portal.
===>> verify in windows disk added or not.
===>> Right click on new added  disk and click on initialize disk.
===>> select MBR.
===>> GPT option only taken when ever size is 2 terrabyte size of disk added.
===>> Click on partion and add new volume.
===>> open file explorer --> click on this pc and check.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Increase Size of the Disk:
--------------------------
   1)  If you want to increase the size of the disk -->> go to disk service.
   2)  Click on disk which wants to change .
   3)  Click on size + performances.
   4)  We can give custom disk size.
   5) diskmgmt.msc => right click on the unallocated size. extends it.

    Linux :
  -----------
  Resize the disk in portal.
  login linux machine'
  check lsblk
  if you notice size of the disk increased.
  enter resize2fs /dev/sdc1
  If we want to decrease the size of the disk we can not do.

  
  
  




  
  


    


     