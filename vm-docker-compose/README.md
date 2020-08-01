# lo-install

## Google Cloud Platform
### Creates GCP VM via cmd line

```
export INSTANCE=test-1
```

```
gcloud beta compute --project=live-objects-demo instances create ${INSTANCE} --zone=us-west2-a --machine-type=n1-standard-2 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=1009649936809-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=ubuntu-1910-eoan-v20200520 --image-project=ubuntu-os-cloud --boot-disk-size=200GB --boot-disk-type=pd-standard --boot-disk-device-name=${INSTANCE} --reservation-affinity=any
```

### SSH

so that the docker-compose and profile settings are effective

```
gcloud beta compute --project "live-objects-demo" ssh --zone "us-west2-a" ${INSTANCE}
```

## Install LiveObjects Installer 
### Latest version
```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/v2020.2.6/vm-docker-compose/install.sh| bash
```

### specific version

```
export LO_VERSION=develop
```

```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/${LO_VERSION}/vm-docker-compose/install.sh| bash
```

## Provision OS software for  Ubuntu 19.10


### Install incl NGINX

```
cd liveObjectsInstall && ./provision.sh --nginx
```

### Install w/o NGINX

```
cd liveObjectsInstall && ./provision.sh
```



* Updates Ubuntu
* docker-ce
* docker-compose
* nginx

### Environment variables 

If you want to change the default installation directory from liveObjectsInstaller :

```
export LO_DIR=
```

If you want to use an installer tar file from a specific branch or release :

```
export LO_VERSION=master
```

## logout 

```
exit
```

## SSH

so that the docker-compose and profile settings are effective

```
gcloud beta compute --project "live-objects-demo" ssh --zone "europe-west4-c" ${INSTANCE}
```


## Provision Live Objects

installs Live Objects with the Access Token ( aka TOKEN ) you got from your sales representative

```
export TOKEN=eb76b357-cb60-4dae-8d4f-be8f14a7b5ac && cd liveObjectsInstall && ./start.sh
```

or 

```
cd liveObjectsInstall

./start TOKEN

```

## Optional steps to setup NGINX 

Create a nginx site

modify the variables on nginx_create_site.sh

check in GCP what your internal IP address is and update the ip address below accordingly same for the DNS name you are using

```
./nginx_create_site.sh 10.168.0.18  r202020.liveobjects.online
```

## Update the GCP DNS Settings with the external IP address

### Letsencrypt and Certbot

### sudo letsencrypt --noninteractive -a webroot --webroot-path=/var/www/letsencrypt -m mail@liveobjects.rocks --agree-tos -d demo.liveobjects.rocks

sudo certbot --nginx --noninteractive --redirect -m mail@liveobjects.online --agree-tos -d test1.liveobjects.online

### check your nginx site 

```
sudo cat /etc/nginx/sites/e4.liveobjects.education 
```

### update docker-compose file

```
./update_docker_compose.sh 
```

### restart Live Objects platform

```
docker-compose down
```

```
docker-compose up -d
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