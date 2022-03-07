#!/bin/bash

error_exit() {
    echo -e "\n${red}ERROR on step $1), see above!\nExit.${noColor}"
    exit 1
}


# variables def
step=0
START=`date +%s`
echo $((++step))') - define ENV variable'
export APP_NAME=$APP_NAME
echo 'APP_NAME: ' $APP_NAME



echo "++++++++++++++++++++++++++++++++++++++++"
echo "Vagrant VM PROVISION ..."
echo "++++++++++++++++++++++++++++++++++++++++"

echo "Current user: " $(whoami)
echo $((++step))') - Create app directory'
mkdir -p "/home/vagrant/code/${APP_NAME}" || error_exit $((++step - 1))
chown -R vagrant:vagrant /home/vagrant/code || error_exit $((++step - 1))
chmod -R 775 /home/vagrant/code || error_exit $((++step - 1))

# echo $((++step))') - yum update'
# yum update -y

echo $((++step))') - subscription manager to Rhel repo'
subscription-manager register --username $RHEL_USERNAME --password $RHEL_PASSWORD --auto-attach

echo $((++step))') - yum update'
yum update -y || error_exit $((++step - 1))

echo $((++step))') - yum install nano'
yum install -y nano || error_exit $((++step - 1))

echo $((++step))') - disable SELinux (disable temp & definitiv)'
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/selinux/config

echo $((++step))') - yum install nginx v. 1.14.1'
yum install -y nginx-1.14.1 || error_exit $((++step - 1))
sudo cp /home/vagrant/config/nginx/myapp.conf /etc/nginx/conf.d/myapp.conf || error_exit $((++step - 1))
sed -i "s/_my_app_placeholder_/${APP_NAME}/" /etc/nginx/conf.d/myapp.conf || error_exit $((++step - 1))
systemctl start nginx || error_exit $((++step - 1))
systemctl enable nginx || error_exit $((++step - 1))

echo $((++step))') - open firewall http/https & reload'
firewall-cmd --permanent --zone=public --add-service=http || error_exit $((++step - 1))
firewall-cmd --permanent --zone=public --add-service=https || error_exit $((++step - 1))
systemctl reload firewalld || error_exit $((++step - 1))

echo $((++step))') - dnf install php v. 7.4.6 & php-fpm 7.4.6'
dnf install -y @php:7.4 || error_exit $((++step - 1))
dnf install -y php php-cli php-common || error_exit $((++step - 1))
dnf install -y php-mysqlnd php-zip php-gd || error_exit $((++step - 1))
sed -i 's/user = apache/user = nginx/' /etc/php-fpm.d/www.conf || error_exit $((++step - 1))
sed -i 's/group = apache/group = nginx/' /etc/php-fpm.d/www.conf || error_exit $((++step - 1))
systemctl start php-fpm || error_exit $((++step - 1))
systemctl enable php-fpm || error_exit $((++step - 1))

echo $((++step))') - dnf install & config mysql v. 8.0.21'
dnf install -y @mysql:8.0 || error_exit $((++step - 1))
systemctl start mysqld || error_exit $((++step - 1))
systemctl enable --now mysqld || error_exit $((++step - 1))

echo $((++step))') - restart all processes'
systemctl restart php-fpm nginx mysqld || error_exit $((++step - 1))

echo $((++step))') - add vagrant to nginx group'
usermod -aG nginx vagrant || error_exit $((++step - 1))

echo $((++step))') - add nginx to vagrant group'
usermod -aG vagrant nginx || error_exit $((++step - 1))

echo $((++step))') - !IMP: fix permissions to permit to nginx to access to root web server (only read, not write'
chmod 755 /home/vagrant

echo $((++step))') - dnf install git'
dnf install -y git || error_exit $((++step - 1))

echo $((++step))') - ssh-keygen - keys pair generation'
ssh-keygen -b 2048 -t rsa -f /home/vagrant/.ssh/id_rsa -q -N ""
chown -R vagrant:vagrant /home/vagrant/.ssh || error_exit $((++step - 1))

echo $((++step))') - install composer & move to global use'
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv /home/vagrant/composer.phar /usr/local/bin/composer || error_exit $((++step - 1))

echo $((++step))') - install node v10.18.1 & npm v6.13.4'
dnf module list nodejs
dnf module enable -y nodejs:10
dnf install -y nodejs

echo $((++step))') - yum install rsync'
yum install -y rsync || error_exit $((++step - 1))


echo 'PROVISIONING COMPLETED'
END=`date +%s`
echo "Time: "$((END-START))" sec."

