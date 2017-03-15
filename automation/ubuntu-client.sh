#!/bin/bash


#update ubuntu
apt-get --yes update && apt-get --yes upgrade && apt-get --yes dist-upgrade

export DEBIAN_FRONTEND=noninteractive
apt-get --yes install libpam-ldap nscd
unset DEBIAN_FRONTEND


git clone https://github.com/ashand01/nti310.git /tmp/NTI310


cp /tmp/NTI310/config_files/ldap.conf /etc/ldap.conf


sed -i 's,passwd:         compat,passwd:         ldap compat,g' /etc/nsswitch.conf
sed -i 's,group:          compat,group:          ldap compat,g' /etc/nsswitch.conf
sed -i 's,shadow:         compat,shadow:         ldap compat,g' /etc/nsswitch.conf


sed -i '$ a\session required    pam_mkhomedir.so skel=/etc/skel umask=0022' /etc/pam.d/common-session

/etc/init.d/nscd restart

sed -i 's,PasswordAuthentication no,#PasswordAuthentication no,g' /etc/ssh/sshd_config

sed -i 's,ChallengeResponseAuthentication no,#ChallengeResponseAuthentication no,g' /etc/ssh/sshd_config

systemctl restart sshd.service

#login as ldap user on the ubuntu-desktop!
#command from terminal: ssh <username>@<ubuntuIPaddress>
#enter user password defined in phpldapadmin

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

#rsyslog client-side configuration -- run as root
#must be run on each rsyslog client


echo "*.info;mail.none;authpriv.none;cron.none    @10.128.0.5:514" >> /etc/rsyslog.conf
service rsyslog restart                                     #ubuntu command
