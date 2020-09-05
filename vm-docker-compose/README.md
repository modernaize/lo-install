# lo-install

## Google Cloud Platform

Please adjust the environment variables below according to your project and your needs

### Creates GCP VM via cmd line from scratch

```
export INSTANCE=test-2 && export IMAGE=ubuntu-2004-focal-v20200902 && export IMAGE_PROJECT=ubuntu-os-cloud && export ZONE=us-west2-a && export PROJECT=live-objects-demo
```

### Creates GCP VM via cmd line based on an existing image

This uses the already provisioned Image with NGINX. 

```
export INSTANCE=test-1 && export IMAGE=lo-ubuntu-1910-nginx && export IMAGE_PROJECT=live-objects-demo && export ZONE=us-west2-a && export PROJECT=live-objects-demo
```

```
gcloud beta compute --project=${PROJECT} instances create ${INSTANCE} --zone=${ZONE} --machine-type=n1-standard-2 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=1009649936809-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=${IMAGE} --image-project=${IMAGE_PROJECT} --boot-disk-size=200GB --boot-disk-type=pd-standard --boot-disk-device-name=${INSTANCE} --reservation-affinity=any
```
After the VM got created you can continue directly with [Install the platform](#install-the-platform)

### SSH

```
gcloud beta compute --project ${PROJECT} ssh --zone ${ZONE} ${INSTANCE}
```


## Provision OS software for  Ubuntu 19.10

* Updates Ubuntu
* docker-ce
* docker-compose
* nginx
* certbot


### Latest version

```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/v2020.3.0/vm-docker-compose/provision.sh| bash
```

### Install Reverse proxy NGINX

```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/v2020.3.0/vm-docker-compose/provision_nginx.sh| bash
```

### specific version

```
export LO_VERSION=develop
```

or

```
export LO_VERSION=feature/2020.3
```

```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/${LO_VERSION}/vm-docker-compose/provision.sh| bash
```

### Install Reverse proxy NGINX

```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/${LO_VERSION}/vm-docker-compose/provision_nginx.sh| bash
```

## logout 

so that the docker-compose and profile settings are effective

```
exit
```

## Install the Platform
### SSH

```
gcloud beta compute --project ${PROJECT} ssh --zone ${ZONE} ${INSTANCE}
```

### Install LiveObjects Installer 
#### Latest version
```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/v2020.3.0/vm-docker-compose/install.sh| bash
```

#### specific version

```
export LO_VERSION=develop
```

or

```
export LO_VERSION=feature/2020.3
```

```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/${LO_VERSION}/vm-docker-compose/install.sh| bash
```

### Configure the Platform

This will modify .env.template and copies it to .env 

```
cd liveObjectsInstall && ./config.sh
```


### Environment variables 

If you want to change the default installation directory from liveObjectsInstaller :

```
export LO_DIR=
```

If you want to use an installer tar file from a specific branch or release :

```
export LO_VERSION=master
```

## Provision Live Objects

installs Live Objects with the Access Token ( aka TOKEN ) you got from your sales representative

```
export TOKEN=eb76b357-cb60-4dae-8d4f-be8f14a7b5ac  && ./start.sh
```

or 

```
cd liveObjectsInstall

./start TOKEN

```

## Optional steps to setup NGINX DNS name 

update your DNS settings and map the DNS and your external IP

## Update the GCP DNS Settings with the external IP address

### Letsencrypt and Certbot

sudo certbot --nginx --noninteractive --redirect -m mail@liveobjects.online --agree-tos -d test1.liveobjects.online

### check your nginx site 

```
sudo cat /etc/nginx/sites/test1.liveobjects.online 
```

### NGINX useful commands

#### Checking your Web Server

```
systemctl status nginx
```

#### Reloading a changed config
```
sudo service nginx reload
```