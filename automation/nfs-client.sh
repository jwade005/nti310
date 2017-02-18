
#!/bin/bash

#this script installs the ubuntu client side of nfs and mounts the volumes -- run as root

#install the nfs client packages
apt-get -y install nfs-common nfs-kernel-server
service nfs-kernel-server start

#create mount directories
mkdir -p /mnt/nfs/home
mkdir -p /mnt/nfs/var/dev
mkdir -p /mnt/nfs/var/config

#start the mapping service
service nfs-idmapd start

#mount the volumes
mount -v -t nfs 10.128.0.2:/home /mnt/nfs/home
mount -v -t nfs 10.128.0.2:/var/dev /mnt/nfs/var/dev
mount -v -t nfs 10.128.0.2:/var/config /mnt/nfs/var/config

#make changes mounting the nfs volumes permanent by editing fstab
echo "10.128.0.2:/home /mnt/nfs/home   nfs     defaults 0 0" >> /etc/fstab
echo "10.128.0.2:/var/dev /mnt/nfs/var/dev    nfs     defaults 0 0" >> /etc/fstab
echo "10.128.0.2:/var/config /mnt/nfs/var/config    nfs     defaults 0 0" >> /etc/fstab

#install tree to verify mount
apt-get -y install tree

#verify the mount
df -h
tree /mnt
