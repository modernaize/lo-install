# Misc. 

## Kubectl

kubectl create namespace lo
kubectl delete namespace lo

kubectl get po --namespace=lo

kubectl exec --namespace=lo -it backend-deployment-59475c854-6nns5 -- ash
kubectl exec --namespace=lo -it frontend-deployment-79576cf5b-d9hx6  -- /bin/ash

## Helm

### Installation
#### Default installation 

helm install lo ./  --namespace lo

#### Default installation 

in minikube persistence 

helm install lo ./  \
  --set persistence.enabled=true \
  --set persistence.postgres.data.volumeType=hostPath \
  --set persistence.fontend.logs.volumeType=hostPath \
  --set persistence.backend.logs.volumeType=hostPath \
  --set persistence.backend.data.volumeType=hostPath \
  --set persistence.learn.logs.volumeType=hostPath \
  --set persistence.learn.data.volumeType=hostPath \
  --set services.postgres.spec.type=LoadBalancer 

#### Setting some helm variables
helm install lo ./  --namespace lo \
  --set persistence.enabled=true \
  --set serviceType=LoadBalancer \
  --set persistence.volumeType=hostPath \

### Uninstall the application
helm uninstall lo --namespace=lo

### List helm applcations
helm ls --namespace=lo

### Test syntax of teh helm charts and validates them 
helm install  lo ./ --namespace=lo --dry-run

### List helm chnages / history
helm history lo --namespace=lo 

### Upgrade image

update the image in values.yaml

```
helm upgrade lo --namespace=lo
```

## Letsencrypt

### Limits

https://letsencrypt.org/docs/rate-limits/


## Minikube deployment

minikube addons enable ingress

kubectl get pods -n kube-system

```
NAME                                                     READY   STATUS    RESTARTS   AGE
coredns-6955765f44-6vszs                                 1/1     Running   1          4d14h
coredns-6955765f44-rfc6b                                 1/1     Running   0          37s
etcd-minikube                                            1/1     Running   1          4d14h
kube-addon-manager-minikube                              1/1     Running   1          4d14h
kube-apiserver-minikube                                  1/1     Running   1          4d14h
kube-controller-manager-minikube                         1/1     Running   17         4d14h
kube-proxy-lm22k                                         1/1     Running   1          4d14h
kube-scheduler-minikube                                  1/1     Running   19         4d14h
nginx-ingress-controller-6fc5bcc8c9-cdql8                1/1     Running   2          2d1h
storage-provisioner                                      1/1     Running   1          4d14h
```

minikube start --cpus 4 --memory 8192


minikube mount ~/data:/mount-point

backend:
    logs:
      enabled: true
      size: 5Gi
      accessMode: ReadWriteOnce
      volumeType: hostPath # hostPath, persistentVolumeClaim 
      hostPath: /mount-point

##
echo "$response_json" | jq -r '.access_token'

[Back to the main README](../README.md)