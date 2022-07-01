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

<br/>

## A) Full Environment scaffolding
#### Run provisioner script, passing some env variables:

1) On Linux

`RHEL_USERNAME='username' RHEL_PASSWORD='password' APP_NAME='example_name' vagrant up --provision`

or

`RHEL_USERNAME='username' RHEL_PASSWORD='password' APP_NAME='example_name' vagrant reload --provision` (Imp: use single quotes for pswd)

<br/>

2) On Windows

Use: CMD shell (NOT Powershell) to set env variables 

`set RHEL_USERNAME='username' && set RHEL_PASSWORD='password' && set APP_NAME='example_name' && vagrant up --provision`

(If there is error with subscription manager (to rhel site), connect directly via ssh into VM and doing direct subscription with:
`subscription-manager register`  and `subscription-manager attach`. Then exit from VM and `vagrant reload --provision`
APP_NAME env variable: set directly inside `Vagrant` config file 

<br/>

<br/>

<br/>

<br/>

Rhel username & password are your subscription-manager credential to rhel 8 site

https://access.redhat.com/management 

#### If already provisioned, simply:
`vagrant up`

<br/>
<br/>

---

<br/>

## B) Application Scaffolding

1. Clone Laravel app:

`git clone <laravel-application>`

2. Add .env configuration

`nano .env`

3. Create DB and db User

`mysql -uroot -p`  (empty pswd)

`mysql> CREATE DATABASE IF NOT EXISTS db_name;`

`mysql> CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';`

`mysql> GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost';`

`mysql> FLUSH PRIVILEGES;`

For DB configuration: you can use `mysql_secure_installation` too, as alternative, to manually configure DB, root usr/pswd, creates User, DB, ecc..

4. Init Composer & NPM

`composer install`

`npm install`

5. Run deploy script

example: `./deploy.sh`

