#!/bin/bash


#update ubuntu
apt-get --yes update && apt-get --yes upgrade && apt-get --yes dist-upgrade

export DEBIAN_FRONTEND=noninteractive
apt-get --yes install libpam-ldap nscd
unset DEBIAN_FRONTEND


git clone https://github.com/ashand01/nti310.git /tmp/NTI310


cp /tmp/NTI310/ldap.conf /etc/ldap.conf


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
