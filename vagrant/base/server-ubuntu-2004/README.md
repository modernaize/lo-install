## Build
vagrant destroy -f
vagrant up 

## Package
vagrant package --output $box_name
vagrant package --output base-server-ubuntu-2004

vagrant box add base-server-ubuntu-f2004 --name modernaize/base-ubuntu-2004 --force

vagrant halt
vagrant reload