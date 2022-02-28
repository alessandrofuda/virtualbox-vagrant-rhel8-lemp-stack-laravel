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

## Full-scaffolding Command
#### First run (or re-run) provisioner script, passing some env variables:

`RHEL_USERNAME='username' RHEL_PASSWORD='password' vagrant up --provision`

or

`RHEL_USERNAME='username' RHEL_PASSWORD='password' vagrant reload --provision` (Imp: use single quotes for pswd)

Rhel username & password are your subscription-manager credential to rhel 8 site

#### If already provisioned, simply:
`vagrant up`

___

#### For DB configuration: 
When mysql installed, run:
`mysql_secure_installation` to configure manually DB, root usr/pswd, creates user, DB, ecc..

#### To init Laravel app:

`git clone <laravel-application>`
