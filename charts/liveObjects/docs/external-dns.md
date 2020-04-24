# External DNS Manager in GCP

## set PROJECT_NAME
```
export PROJECT_NAME=live-objects-demo
```

```
kubectl create namespace external-dns  
```


## create service account
```
gcloud iam service-accounts create k8s-external-dns \
  --display-name="Service Account to support ACME DNS-01 challenge." \
  --project=$PROJECT_NAME
```

## create service account key

this will also download the json key

```
gcloud iam service-accounts keys create ./credentials.json \
  --iam-account=k8s-external-dns@$PROJECT_NAME.iam.gserviceaccount.com \
  --project=$PROJECT_NAME
```

## give dns admin permissions

```
gcloud projects add-iam-policy-binding $PROJECT_NAME \
  --member=serviceAccount:k8s-external-dns@$PROJECT_NAME.iam.gserviceaccount.com \
  --role=roles/dns.admin
```

```
kubectl create secret generic external-dns \
  --from-file=./credentials.json \
  --namespace=external-dns  
```

## Install Helm chart


```
helm repo add bitnami https://charts.bitnami.com/bitnami
```

```
helm install bitnami bitnami/external-dns
```


```
helm install \
  --namespace external-dns   \
  --set provider=google \
  --set google.project=$PROJECT_NAME \
  --set google.serviceAccountSecret=external-dns \
  --set policy=upsert-only \
  --set source=ingress \
  --set registry=txt \
  --set txtOwnerId=k8s \
  --set domainFilters={liveobjects.education} \
  --set rbac.create=true \
  external-dns bitnami/external-dns 
```

update the domainFilter according to your zone entry

```
helm install \
  --namespace external-dns   \
  --set provider=google \
  --set google.project=$PROJECT_NAME \
  --set google.serviceAccountSecret=external-dns \
  --set policy=upsert-only \
  --set source=ingress \
  --set domainFilters={liveobjects.online} \
  --set rbac.create=true \
  external-dns bitnami/external-dns 
```

[Back to the main README](../README.md)
