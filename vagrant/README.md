## Build
vagrant destroy -f
vagrant up 

## Package
vagrant package --output $box_name
vagrant package --output base-server-ubuntu-2004

## Add to vagrant
vagrant box add base-server-ubuntu-2004 --name base-server-ubuntu-2004 --force
vagrant box add base-server-ubuntu-2004 --name modernaize/base-server-ubuntu-2004 --force

## Misc. operations
vagrant halt
vagrant reload