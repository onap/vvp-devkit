```
Add the following line into your local hosts file:
  10.252.0.12 coreos-01.development.vvp.example.com

Select the required environment from the list when requested:
$ . ./setenv

$ vagrant up

Wait till all pods will be at running status (This might take few minutes)
$ watch -n5 "kubectl get po -n kube-system"

$ bin/vvp-deploy

```