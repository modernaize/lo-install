liveobjects
===========
A Helm chart for Kubernetes to deploy the Live Objects Platform

Current chart version is `2020.2.19`

## Additional Information

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

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certManager.allowExternal | bool | `true` |  |
| certManager.ca.name | string | `"letsencrypt"` |  |
| certManager.letsencrypt.env | string | `"prod"` |  |
| certManager.letsencrypt.spec.acme.email | string | `"info@liveobjects.education"` |  |
| certManager.letsencrypt.spec.acme.serverProd | string | `"https://acme-v02.api.letsencrypt.org/directory"` |  |
| certManager.letsencrypt.spec.acme.serverStaging | string | `"https://acme-staging.api.letsencrypt.org/directory"` |  |
| certManager.tls.secretName | string | `"lo-tls"` |  |
| deployment.backend.container.imagePullPolicy | string | `"Always"` |  |
| deployment.backend.container.ports.containerPort | int | `8000` |  |
| deployment.backend.container.registry | string | `"liveobjects/service"` |  |
| deployment.backend.container.resources.requests.cpu | string | `"200m"` |  |
| deployment.backend.container.resources.requests.memory | string | `"1G"` |  |
| deployment.backend.container.tag | string | `"P-v2020.2.0"` |  |
| deployment.backend.enabled | bool | `true` |  |
| deployment.backend.metadata.name | string | `"backend-deployment"` |  |
| deployment.backend.spec.replicas | int | `1` |  |
| deployment.frontend.container.imagePullPolicy | string | `"Always"` |  |
| deployment.frontend.container.ports.containerPort | int | `3000` |  |
| deployment.frontend.container.registry | string | `"liveobjects/ui"` |  |
| deployment.frontend.container.resources.requests.cpu | string | `"200m"` |  |
| deployment.frontend.container.resources.requests.memory | string | `"1G"` |  |
| deployment.frontend.container.tag | string | `"P-v2020.2.6"` |  |
| deployment.frontend.enabled | bool | `true` |  |
| deployment.frontend.metadata.name | string | `"frontend-deployment"` |  |
| deployment.frontend.spec.replicas | int | `1` |  |
| deployment.learn.container.imagePullPolicy | string | `"Always"` |  |
| deployment.learn.container.ports.containerPort | int | `5000` |  |
| deployment.learn.container.registry | string | `"liveobjects/learn"` |  |
| deployment.learn.container.resources.requests.cpu | string | `"200m"` |  |
| deployment.learn.container.resources.requests.memory | string | `"1G"` |  |
| deployment.learn.container.tag | string | `"P-v2020.2.0"` |  |
| deployment.learn.enabled | bool | `true` |  |
| deployment.learn.metadata.name | string | `"learn-deployment"` |  |
| deployment.learn.spec.replicas | int | `1` |  |
| deployment.license.container.imagePullPolicy | string | `"Always"` |  |
| deployment.license.container.ports.containerPort | int | `3001` |  |
| deployment.license.container.registry | string | `"liveobjects/license-service"` |  |
| deployment.license.container.resources.requests.cpu | string | `"200m"` |  |
| deployment.license.container.resources.requests.memory | string | `"1G"` |  |
| deployment.license.container.tag | string | `"D-develop"` |  |
| deployment.license.enabled | bool | `true` |  |
| deployment.license.healthcheckHttps | bool | `false` |  |
| deployment.license.livenessProbe.enabled | bool | `false` |  |
| deployment.license.livenessProbe.failureThreshold | int | `6` |  |
| deployment.license.livenessProbe.initialDelaySeconds | int | `120` |  |
| deployment.license.livenessProbe.path | string | `"/live"` |  |
| deployment.license.livenessProbe.periodSeconds | int | `10` |  |
| deployment.license.livenessProbe.successThreshold | int | `1` |  |
| deployment.license.livenessProbe.timeoutSeconds | int | `5` |  |
| deployment.license.metadata.name | string | `"license-deployment"` |  |
| deployment.license.readinessProbe.enabled | bool | `false` |  |
| deployment.license.readinessProbe.failureThreshold | int | `6` |  |
| deployment.license.readinessProbe.initialDelaySeconds | int | `30` |  |
| deployment.license.readinessProbe.path | string | `"/ready"` |  |
| deployment.license.readinessProbe.periodSeconds | int | `10` |  |
| deployment.license.readinessProbe.successThreshold | int | `1` |  |
| deployment.license.readinessProbe.timeoutSeconds | int | `5` |  |
| deployment.license.spec.replicas | int | `1` |  |
| deployment.postgres.container.imagePullPolicy | string | `"Always"` |  |
| deployment.postgres.container.ports.containerPort | int | `5432` |  |
| deployment.postgres.container.registry | string | `"liveobjects/postgres"` |  |
| deployment.postgres.container.resources.requests.cpu | string | `"200m"` |  |
| deployment.postgres.container.resources.requests.memory | string | `"1G"` |  |
| deployment.postgres.container.tag | string | `"P-v2020.2.0"` |  |
| deployment.postgres.enabled | bool | `true` |  |
| deployment.postgres.metadata.name | string | `"postgre-deployment"` |  |
| deployment.postgres.spec.replicas | int | `1` |  |
| global.backend.enabled | bool | `true` |  |
| global.configMap | bool | `true` |  |
| global.dockerSecret | bool | `true` |  |
| global.frontend.enabled | bool | `true` |  |
| global.gcp | string | `nil` |  |
| global.image.registry | string | `"docker.io"` |  |
| global.image.repository | string | `"liveobjects"` |  |
| global.ingress | bool | `false` |  |
| global.labels.track | string | `"stable"` |  |
| global.learn.enabled | bool | `true` |  |
| global.license.enabled | bool | `true` |  |
| global.networkPolicy | bool | `false` |  |
| global.postrgre.enabled | bool | `true` |  |
| global.resourceQuotas | bool | `false` |  |
| ingress.annotations | object | `{}` |  |
| ingress.name | string | `"frontend-ingress"` |  |
| ingress.tls.host | string | `nil` |  |
| lo.sslConfiguration | string | `"none"` |  |
| loServer.existingSecret | string | `"lologin"` |  |
| loServer.password.length | int | `20` |  |
| loServer.user.adminPassword | string | `nil` |  |
| loServer.user.license_adminPassword | string | `nil` |  |
| loServer.user.rootPassword | string | `nil` |  |
| loServer.user.system_adminPassword | string | `nil` |  |
| metrics.exporter.enabled | bool | `false` |  |
| metrics.image | string | `nil` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.storageClass | string | `"standard"` |  |
| postgresql.cpu | string | `"1000m"` |  |
| postgresql.existingSecret | string | `"postgreslogin"` |  |
| postgresql.exporter.image | string | `"gcr.io/cloud-marketplace/google/gitlab/postgresql-exporter:12.9"` |  |
| postgresql.image | string | `"liveobjects/postgres:P-v2020.2.0"` |  |
| postgresql.memory | string | `"1Gi"` |  |
| postgresql.password.length | int | `20` |  |
| postgresql.persistence.size | string | `"8Gi"` |  |
| postgresql.postgresDatabase | string | `"liveobjects"` |  |
| postgresql.postgresqlPassword | string | `nil` |  |
| postgresql.username | string | `"liveobjects"` |  |
| secrets.registry.imagePullSecrets | string | `"regcred"` |  |
| services.backend.enabled | bool | `true` |  |
| services.backend.metadata.name | string | `"backend-svc"` |  |
| services.backend.spec.ports.port | int | `8000` |  |
| services.backend.spec.ports.protocol | string | `"TCP"` |  |
| services.backend.spec.ports.targetPort | int | `8000` |  |
| services.backend.spec.selector.app | string | `"backend"` |  |
| services.backend.spec.type | string | `"ClusterIP"` |  |
| services.frontend.enabled | bool | `true` |  |
| services.frontend.metadata.annotations | object | `{}` |  |
| services.frontend.metadata.name | string | `"frontend-svc"` |  |
| services.frontend.spec.ports.port | int | `80` |  |
| services.frontend.spec.ports.protocol | string | `"TCP"` |  |
| services.frontend.spec.ports.targetPort | int | `3000` |  |
| services.frontend.spec.ports.tlsport | int | `443` |  |
| services.frontend.spec.selector.app | string | `"frontend"` |  |
| services.frontend.spec.type | string | `"ClusterIP"` |  |
| services.learn.enabled | bool | `true` |  |
| services.learn.metadata.name | string | `"learn-svc"` |  |
| services.learn.spec.ports.port | int | `5000` |  |
| services.learn.spec.ports.protocol | string | `"TCP"` |  |
| services.learn.spec.ports.targetPort | int | `5000` |  |
| services.learn.spec.selector.app | string | `"learn"` |  |
| services.learn.spec.type | string | `"ClusterIP"` |  |
| services.license.enabled | bool | `true` |  |
| services.license.metadata.annotations | object | `{}` |  |
| services.license.metadata.name | string | `"license-svc"` |  |
| services.license.spec.ports.port | int | `3001` |  |
| services.license.spec.ports.protocol | string | `"TCP"` |  |
| services.license.spec.ports.targetPort | int | `3001` |  |
| services.license.spec.ports.tlsport | int | `443` |  |
| services.license.spec.selector.app | string | `"license"` |  |
| services.license.spec.type | string | `"ClusterIP"` |  |
| services.postgres.enabled | bool | `true` |  |
| services.postgres.metadata.name | string | `"postgresql-svc"` |  |
| services.postgres.spec.clusterIP | string | `"None"` |  |
| services.postgres.spec.ports.port | int | `5432` |  |
| services.postgres.spec.ports.protocol | string | `"TCP"` |  |
| services.postgres.spec.ports.targetPort | int | `5432` |  |
| services.postgres.spec.selector.app | string | `"postgres"` |  |
| services.postgres.spec.type | string | `"ClusterIP"` |  |
| tls.base64EncodedCertificate | string | `nil` |  |
| tls.base64EncodedPrivateKey | string | `nil` |  |

## Work with charts repositories

From here you'll want to add the repository to Helm so you can use it

```
helm repo add liveobjects-prod https://liveobjectsai.github.io/lo-install/
```

```
helm repo update
```

```
helm search repo liveobjects
```