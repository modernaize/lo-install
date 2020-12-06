### Install NGINX Ingress Controller

ingress-nginx is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer.

Add stable repository

```
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```

```
helm repo update
```

Install chart

"controller.publishService.enabled=true " will be used by extrnal-dns to set all tls.hosts domains to the external ip of the ingress controller

```
helm install ingress \
    stable/nginx-ingress \
    --set controller.publishService.enabled=true 
```


[Back to the main README](../README.md)
