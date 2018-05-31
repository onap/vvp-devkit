```
Add the following line into your local hosts file:
  10.252.0.12 coreos-01.development.vvp.example.com

Select the required environment from the list when requested:
$ . ./setenv

$ vagrant up

Login to the coreos box quickly after provisioning has finished, 
wait for the VM to reboot automatically for the first time.

After the reboot, perform the following manual steps
Create the file:
/etc/systemd/network/static.network

with contents:
[Match]
Name=eth1

[Network]
Address=10.252.0.12

Add the following line to the bottom of /etc/hosts
10.252.0.12 coreos-01.development.vvp.example.com

Wait till all pods will be at running status (This might take few minutes)
$ watch -n5 "kubectl get po -n kube-system"

$ bin/vvp-deploy

After the above deploy, it can take around 30 minutes for everything to finish.

To access the ICE dashboard, got to https://10.220.220.12/#/

```
