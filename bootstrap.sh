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
systemctl start nginx
systemctl enable nginx

echo $((++step))') - open firewall http/https & reload'
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
systemctl reload firewalld

echo $((++step))') - dnf install php v. 7.4.6 & php-fpm 7.4.6'
dnf install -y @php:7.4
dnf install -y php php-cli php-common
dnf install -y php-mysqlnd php-zip
sed -i 's/user = apache/user = nginx/' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/' /etc/php-fpm.d/www.conf
systemctl start php-fpm
systemctl enable php-fpm

echo $((++step))') - dnf install & config mysql v. 8.0.21'
dnf install -y @mysql:8.0
systemctl start mysqld
systemctl enable --now mysqld

echo $((++step))') - restart all processes'
systemctl restart php-fpm nginx mysqld

echo $((++step))') - add vagrant to nginx group'
usermod -aG nginx vagrant

echo $((++step))') - add nginx to vagrant group'
usermod -aG vagrant nginx

echo $((++step))') - !IMP: fix permissions to permit nginx access to root web server'
chmod 775 /home/vagrant

echo $((++step))') - dnf install git'
dnf install -y git

echo $((++step))') - install composer & move to global use'
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv /home/vagrant/composer.phar /usr/local/bin/composer

echo $((++step))') - install composer'
# echo $((++step))') - Switch to vagrant User'
# su - vagrant

echo $((++step))') - install node & npm ????? versions ????'

echo '..TBC..'
echo OK


# yum update -y
