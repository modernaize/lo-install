# Chef WorkStation scripts  
# Requirements  
Download the latest stable version from ![Chef_Workstation_Download](https://downloads.chef.io/products/workstation)
Verify you have configure workstation working locally on the system. 

Execute chef-run 

```
chef-run --identity-file $PATH_TO_PEM/ID_RSA $IP --user $USERNAME ./
```

PATH_TO_PEM/ID_RSA  == ../terrafrom/sshkeys/pvt 
IP                  == 0.0.0.0
USERNAME            == chef 


Example runtime command

```
chef-run --identity-file ../terrafrom/ssh-keys/pvt 34.105.13.35  --user chef ./
```
