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

echo $((++step))') - subscription manager to Rhel repo'
subscription-manager register --username $RHEL_USERNAME --password $RHEL_PASSWORD --auto-attach

echo $((++step))') - yum update'
yum update -y || error_exit $((++step - 1))

echo $((++step))') - yum install nano'
yum install -y nano || error_exit $((++step - 1))

echo $((++step))') - yum install podman (same prod vers)'
yum install -y podman-4.2.0 || error_exit $((++step - 1))

echo $((++step))') - yum install git'
yum install -y git || error_exit $((++step - 1))

echo $((++step))') - disable SELinux (disable temp & definitiv)'
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/selinux/config

echo $((++step))') - yum install nginx 1.14.1'
yum install -y nginx-1.14.1 || error_exit $((++step - 1))
sudo cp /home/vagrant/config/nginx/myapp.conf /etc/nginx/conf.d/myapp.conf || error_exit $((++step - 1))
sed -i "s/_my_app_placeholder_/${APP_NAME}/" /etc/nginx/conf.d/myapp.conf || error_exit $((++step - 1))
systemctl start nginx || error_exit $((++step - 1))
systemctl enable nginx || error_exit $((++step - 1))

echo $((++step))') - open firewall http/https & reload'
firewall-cmd --permanent --zone=public --add-service=http || error_exit $((++step - 1))
firewall-cmd --permanent --zone=public --add-service=https || error_exit $((++step - 1))
systemctl reload firewalld || error_exit $((++step - 1))

echo $((++step))') - dnf install & config mysql v. 8.0.21'
dnf install -y @mysql:8.0 || error_exit $((++step - 1))
systemctl start mysqld || error_exit $((++step - 1))
systemctl enable --now mysqld || error_exit $((++step - 1))

echo $((++step))') - restart all processes'
systemctl restart nginx mysqld || error_exit $((++step - 1))

echo $((++step))') - add vagrant to nginx group'
usermod -aG nginx vagrant || error_exit $((++step - 1))

echo $((++step))') - add nginx to vagrant group'
usermod -aG vagrant nginx || error_exit $((++step - 1))

echo $((++step))') - !IMP: fix permissions to permit to nginx to access to root web server (only read, not write'
chmod 755 /home/vagrant

# attenzione: chiave ssh viene generata come utente root
echo $((++step))') - ssh-keygen - keys pair generation'
ssh-keygen -b 2048 -t rsa -f /home/vagrant/.ssh/id_rsa -q -N ""
chown -R vagrant:vagrant /home/vagrant/.ssh || error_exit $((++step - 1))

echo $((++step))') - yum install rsync'
yum install -y rsync || error_exit $((++step - 1))


echo 'PROVISIONING COMPLETED'
END=`date +%s`
echo "Time: "$((END-START))" sec."

