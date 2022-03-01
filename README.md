# Vagrant Box VM on top of VirtualBox with: Rhel8, Lemp stack, Laravel ecosystem components
Scaffolding to make VirtualBox/Vagrant VM with:
- RedHat 8 (Rhel 8), 
- nginx, 
- mysql, 
- php 7.4, 
- composer, 
- git, 
- node, 
- npm
- vagrant user/group configuration

## A) Full Environment scaffolding
#### Run provisioner script, passing some env variables:

`RHEL_USERNAME='username' RHEL_PASSWORD='password' APP_NAME='example_name' vagrant up --provision`

or

`RHEL_USERNAME='username' RHEL_PASSWORD='password' APP_NAME='example_name' vagrant reload --provision` (Imp: use single quotes for pswd)

Rhel username & password are your subscription-manager credential to rhel 8 site

https://access.redhat.com/management 

#### If already provisioned, simply:
`vagrant up`

___

## B) Application Scaffolding

1. Clone Laravel app:

`git clone <laravel-application>`

2. Add .env configuration

`.env`

4. Create DB and db User

`mysql -uroot -p`  (empty pswd)

`mysql> CREATE DATABASE IF NOT EXISTS db_name;`

`mysql> CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';`

`mysql> GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost';`

`mysql> FLUSH PRIVILEGES;`

#### For DB configuration:
When mysql installed, run:
`mysql_secure_installation` to configure manually DB, root usr/pswd, creates user, DB, ecc..
