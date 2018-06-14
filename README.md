```

## Prerequisites ##

Versions displayed below are required except for the OS

Ansible :      2.2.1.0
Vagrant :      1.9.4
VirtualBox:    5.1.14
OS:            OS X 10.13.3

## Installation ##

Add the following line into your local hosts file:
10.252.0.12 coreos-01.development.vvp.example.com

Select the required environment from the list when requested:
$ . ./setenv

install the vvp custom box:
$ bin/vvp-install-box

start the infrastructure deployment 
$ vagrant up

Login to the coreos box quickly after provisioning has finished, 
wait for the VM to reboot automatically for the first time.

After the reboot, perform the following manual steps on coreos
Create the file:
/etc/systemd/network/static.network

with contents:
[Match]
Name=eth1

[Network]
Address=10.252.0.12

Add the following line to the bottom of /etc/hosts
10.252.0.12 coreos-01.development.vvp.example.com

Reboot coreos

After rebooting, once again login to the coreos box.
Wait (about 15 min) for all of the docker containers and services to become fully up and ready.
You can monitor the syslogs using the command "journalctl -xef". Wait for activity in the syslogs to die down for a few minutes.

Run command
$ bin/vvp-deploy

After the above deploy, it can take around 30 minutes for everything to finish.

To access the ICE dashboard, go to https://10.220.220.12/#/

Also recommended to setup port forwarding for port 22 on the coreos box

## USER GUIDE ##

To create an account
- Sign up like normal (email, pwd)
- No email will be sent, you can find the activation link with the command "kubectl logs <em-uwsgi pod name>"
- Paste the activation link into your browser to activate the new account
- login to your new account
- Add a public ssh key your profile

Before creating an engagement, you need to configure the jenkins container
- login as root to the running jenkins container
$ docker exec -it -u root <jenkins container id> "/bin/sh"
- add 10.252.0.12 dev-git.vvp.example.com to /etc/hosts

Once an engagement has been created with your new user, it will create a corresponding project in gitlab.
- login to gitlab (http://10.252.0.12/) WITH THE ADMIN credentials
- add your new user to the new project that was created in the previous step
- in gitlab, authentication via ssh between test-engine and gitlab may not be working. recommended for local builds to set gitlab project to public access. BE AWARE if youre not using a private instance, this could allow anyone to see the uploaded heat templates.
- clone the repo. Cloning may only work over http.
- add your heat templates and commit them to the repo
- This will start a jenkins job to validate your templates, and results will be posted to the portal once complete.

Login to the Engagement Manager portal as an administrator
- move engagement along
- check heat tempalte validation status
- apporve, reject, check jenkins logs

```

