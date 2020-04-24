# Live Objects

## Prerequisites

for your deployment environment :

* helm ( version 3 ) 
* kubectl

A working K8S cluster with:

* NGINX Ingress installed
* cert-manager installed for letsencrypt certificates

[If enabled] A persistent storage resource and RW access to it

Configuration
By default this chart will not have persistent storage.

## Prepare the K8S Cluster

[Google Cloud Platform](./docs/cloud-providers/cloud-providers.md)

[NGINX Ingress Controller](./docs/ingress.md)

[Cert-Manager](./docs/cert-manager.md)

You can either update your DNS record automatically

* [External-DNS](./docs/external-dns.md)

or manually 

* [Manual-DNS-update](./docs/update-dns-records.md)

## Create Live Objects namespace

Create a namespace to run Live Objects in i.e. lo

use the created namespace whenever a helm command or kubectl gets executed with a specific namespace.

```
kubectl create namespace lo
```

## create secret 

Create a Secret to access the Docker repositoy and the private Live Objects images 

Note : The --docker-password should have been given to you by your Live Objects support personell

```
kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=liveobjects --docker-password=<< YOUR TOKEN HERE >> --namespace=lo
```

## Install the charts

Install the Live Objects Helm chart - Version 3

```
helm install lo ./ \
--set ingress.tls.host=e1.liveobjects.online \
--set persistence.enabled=false \
-n=lo
```

## Verify your installation

```
kubectl get pods --namespace=lo

backend-deployment-55778594b-rqnqt     1/1     Running   0          100s
frontend-deployment-64669c46fb-xfp82   1/1     Running   0          100s
learn-deployment-77bd4898d5-8s92p      1/1     Running   0          100s
postgre-deployment-0                   1/1     Running   0          100s
```

```
kubectl get services --namespace=lo

NAME                        TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
backend-service             ClusterIP      10.0.11.99    <none>        8000/TCP       2m19s
frontend-service            LoadBalancer   10.0.3.162    44.90.78.41   80:30946/TCP   2m19s
learn-service               ClusterIP      10.0.11.121   <none>        5000/TCP       2m19s
postgres-service            ClusterIP      10.0.6.42     <none>        5432/TCP       2m19s
postgres-service-headless   ClusterIP      None          <none>        5432/TCP       2m19s
```

If you have installed the ingress-nginx service 

```
kubectl get services

ingress-nginx-ingress-controller        LoadBalancer   10.0.9.109    35.204.145.108   80:31865/TCP,443:30775/TCP   39m
ingress-nginx-ingress-default-backend   ClusterIP      10.0.14.113   <none>           80/TCP                       39m
kubernetes                              ClusterIP      10.0.0.1      <none>           443/TCP                      97m
```

## install a second instance

```
kubectl create namespace l2
```

```
./gcp-env-create.sh -d e2.liveobjects.education -n l2
```

```
helm install lo ./ \
--set ingress.tls.host=r-v181.liveobjects.online \
--set persistence.enabled=false \
-n=r-v181
```

## Update an existing instance

Upgrade the Live Objects instance and apply changes

```
helm upgrade lo ./ \
-n=demo2
```

```
helm upgrade lo-demo1 ./ \
--set ingress.tls.host=demo1.liveobjects.online \
--set persistence.enabled=true \
-n=demo1
```

## Parameters

The following tables lists the configurable parameters of the Live Objects Platform chart and their default values.

|                   Parameter                   |                                                                                Description                                                                                |                            Default                            |
|-----------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| `persistence.enabled`                           | Persistence enabled                                   | `true`                                                         |
| `services.postgres.spec.type`                   | Persistence enabled                              |`ClusterIP`                                                         |
| `ingress.enabled`                           | Ingress enabled                                     | `true`                                                         |
| `cert-manager.enabled`                      | Certification Manager enabled                       | `true`                                                         |
| `global.image.registry`                | Registry name                          | docker.io |
| `global.image.repository`              | Registry name                           | liveobjects |
| `secrets.registry.imagePullSecrets`    | Name of the secret name                 | regcred |
| `tls_cert_provided`                    | TLS provided by Live Objects                 | false |
| `certManager.enabled`                    |                 | true |
| `certManager.tls.secretName`                    |                 | lo-tls |
| `certManager.ca.name`                    |                 | letsencrypt |
| `certManager.ca.letsencrypt.env`                    |         prod or staging         | info@liveobjects.rocks |
| `certManager.ca.letsencrypt.spec.acme.serverProd`                    |         prod or staging         |  https://acme-v02.api.letsencrypt.org/directory |
| `certManager.ca.letsencrypt.spec.acme.serverStaging`                    |         prod or staging         | https://acme-staging.api.letsencrypt.org/directory
 |
| `networkPolicy.enabled`                    |                 | false |
| `resourceQuotas.enabled`                    |                 | false |
| `ingress.enabled`                    |                 | true |
| `ingress.tls`                    |                 | [] |
| `ingress.annotations`                    |                 | {} |
| `ingress.name`                    |                 | frontend-ingress |
| `deployment`                    |                 |  |
| `persistence`                    |                 |  |
| `services`                    |                 |  |
| `postgresql.existingSecret`                    |   PostgreSQL password using existing secret              | postgreslogin |


[Misc](./docs/misc.md)
