#!/bin/bash

# variables def
step=0
APP_NAME='cybersec'



echo "++++++++++++++++++++++++++++++++++++++++"
echo "Vagrant VM PROVISION ..."
echo "++++++++++++++++++++++++++++++++++++++++"

echo "Current user: " $(whoami)
echo $((++step))') - Create app directory'
mkdir -p "code/${APP_NAME}"
chown -R vagrant:vagrant ./code
chmod -R 775 ./code

echo $((++step))') - yum update'
yum update -y

echo $((++step))') - subscription manager to Rhel repo'
subscription-manager register --username $RHEL_USERNAME --password $RHEL_PASSWORD --auto-attach

echo $((++step))') - yum update'
yum update -y

echo $((++step))') - yum install nano'
yum install -y nano

echo $((++step))') - ssh-keygen'
ssh-keygen -b 2048 -t rsa -f /home/vagrant/.ssh/id_rsa -q -N ""
chown -R vagrant:vagrant /home/vagrant/.ssh

echo $((++step))') - disable SELinux (disable temp & definitiv)'
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/selinux/config

echo $((++step))') - yum install nginx v. 1.14.1'
yum install -y nginx-1.14.1

echo $((++step))') - yum install php v. 7.4.6 & php-fpm 7.4.6'




# echo $((++step))') - Switch to vagrant User'
# su - vagrant



echo '..TBC..'
echo OK


# yum update -y
