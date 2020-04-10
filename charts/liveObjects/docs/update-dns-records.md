## Update your DNS records manually

```
$ kubectl get services

NAME                                    TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)                      AGE
ingress-nginx-ingress-controller        LoadBalancer   10.39.245.163   31.87.47.195   80:30223/TCP,443:31781/TCP   2m7s
ingress-nginx-ingress-default-backend   ClusterIP      10.39.242.211   <none>         80/TCP                       2m7s
kubernetes                              ClusterIP      10.39.240.1     <none>         443/TCP                      4m28s

```

Update the DNS settings for your Domain . For that take the EXTERNAL-IP address of the ingress-nginx-ingress-controller service.

You can either use the GCP webconsole or the os commandline :


```
$ gcloud dns --project=<< your project >> record-sets transaction start --zone=<< your zone >>

$ gcloud dns --project=<< your project >> record-sets transaction add 34.90.67.79 --name=demo.<< your domain >>. --ttl=300 --type=A --zone=<< your zone >>

$ gcloud dns --project=<< your project >> record-sets transaction remove 34.90.67.79 --name=demo.<< your domain >>. --ttl=300 --type=A --zone=<< your zone >>

$ gcloud dns --project=<< your project >> record-sets transaction execute --zone=<< your zone >>

```

[Back to the main README](../README.md)