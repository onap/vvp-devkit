```
# update your hosts file with the line
# 10.252.0.12 coreos-01.development.vvp.example.com
. setenv
# select the envirionment yout want from the list
vagrant up
watch -n5 "kubectl get po -n kube-system"
# once all pods are running status
`bin/vvp-deploy`
