# lo-install

## Google Cloud Platform

Please make sure that you have the latest Google Cloud SDK installed and have valid IAM User with appropiate authorisation to perform all relavnt actions i.e.

* VM Creation
* DNS Settings
* Servcie Account usage
* SSH access

Please adjust the environment variables below according to your project and your needs

Also the name/domain/dns demo4 , demo4.livebobjects.rocks are being used for illustration purposes only and need to be adopted to your own needs.

### Creates GCP VM via cmd line from scratch

Ubuntu 20.04

```
export INSTANCE=test1 && export IMAGE=ubuntu-2004-focal-v20200902 && export IMAGE_PROJECT=ubuntu-os-cloud && export ZONE=us-west2-a && export PROJECT=modernaize-dev
```

### Creates GCP VM via cmd line based on an existing image

This uses the already provisioned Image with NGINX. 

Ubuntu 19.10
```
export INSTANCE=demo4 && export IMAGE=lo-ubuntu-1910-nginx && export IMAGE_PROJECT=live-objects-demo && export ZONE=us-west2-a && export PROJECT=live-objects-demo
```

Ubuntu 20.04 with Docker 
```
export INSTANCE=demo4 && export IMAGE=ubuntu-2004-20200909 && export IMAGE_PROJECT=live-objects-demo && export ZONE=us-west2-a && export PROJECT=live-objects-demo
```

Ubuntu 20.04 with Docker and NGINX
```
export INSTANCE=test1 && export IMAGE=ubuntu-2004-nginx-20200905 && export IMAGE_PROJECT=live-objects-demo && export ZONE=us-west2-a && export PROJECT=modernaize-dev
```

### Create VM

Please update the servcie-account variable with the service account to be used for the VM execution.

export SA=589172494258-compute@developer.gserviceaccount.com && export SUBNET=modernaize-external-us-west2

```
gcloud beta compute --project=${PROJECT} instances create ${INSTANCE} --zone=${ZONE} --machine-type=e2-standard-4 --subnet=${SUBNET} --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=${SA} --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=${IMAGE} --image-project=${IMAGE_PROJECT} --boot-disk-size=200GB --boot-disk-type=pd-standard --boot-disk-device-name=${INSTANCE} --reservation-affinity=any
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

If you want want to use the lastest offically released version :

```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/v2020.3.0/vm-docker-compose/provision.sh| bash
```

### Optional : Install Reverse proxy NGINX

```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/v2020.3.0/vm-docker-compose/provision_nginx.sh| bash
```

### specific version

Otherwise you can use an experimental installer/version :

```
export LO_VERSION=develop
```

or

```
export LO_VERSION=release/2020.3.0
```

```
curl -s https://raw.githubusercontent.com/liveobjectsai/lo-install/${LO_VERSION}/vm-docker-compose/provision.sh| bash
```

### Optional : Install Reverse proxy NGINX

If you want to run NGINX as a docker container you can skip this step

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

Make sure that you have sudo rights to execute the scriot without adding sudo to the commands. 

Your can add youself with the following command to the Docker group :

```
sudo usermod -aG docker ${USER}
```

After you have added yourself you need to logoff and login again

### Install LiveObjects Installer 
#### Latest version

If you want want to use the lastest offically released version :


```
curl -s -o ./install.sh https://raw.githubusercontent.com/liveobjectsai/lo-install/v2020.3.0/vm-docker-compose/install.sh && bash install.sh
```

#### specific version

Otherwise you can use an experimental installer/version :

```
export LO_VERSION=develop
```

or

```
export LO_VERSION=release/2020.3.0
```

```
curl -s -o ./install.sh https://raw.githubusercontent.com/liveobjectsai/lo-install/${LO_VERSION}/vm-docker-compose/install.sh && bash install.sh
```

## Configure the Platform

### Update the GCP DNS Settings with the external IP address

If required update your DNS setting and map your external IP 

### Request an Letsencrypt certificate

If you want to request an Letsencrypt certificate you need to have finished the DNS mapping. Otherwise the certificate can't be issued successfully

#### Obtain a letsencrypt certificate

```
cd liveObjectsInstall
```

--staging 1 if you want to test your config
--staging 0 if you want to create a production certificate

Note : there a limits per week for production certificates

You might need to run this command as sudo 

```
sudo ./getCertificate.sh --domains test1.modernaize.dev --email info@modernaize.dev --data-path ./webserver/certbot --staging 0
```

#### Certificates

Your certificate and chain have been saved at:

```
./webserver/certbot/conf/live/demo4.liveobjects.rocks/fullchain.pem
```

Your key file has been saved at:

```
./webserver/certbot/conf/live/demo4.liveobjects.rocks/privkey.pem
```

### Configure the platform

Ensure you are in the installation folder /liveObjectsInstall to run the configuration script.

This will modify .env.template and copies it to .env 

```
./config.sh
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

### Letsencrypt and Certbot if you installed NGINX not in a Docker Container

sudo certbot --nginx --noninteractive --redirect -m mail@liveobjects.rocks --agree-tos -d demo4.liveobjects.rocks

### check your nginx site 

```
sudo cat /etc/nginx/sites/demo4.liveobjects.rocks 
```

