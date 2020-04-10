### Install cert-manager

cert-manager is a Kubernetes add-on to automate the management and issuance of TLS certificates from various issuing sources.

It will ensure certificates are valid and up to date periodically, and attempt to renew certificates at an appropriate time before expiry.

All resources (the CustomResourceDefinitions, cert-manager, namespace, and the webhook component) are included in a single YAML manifest file:

Install the CustomResourceDefinitions and cert-manager itself

#### Kubernetes 1.15+
```
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.1/cert-manager.yaml
```

#### Kubernetes <1.15
```
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.1/cert-manager-legacy.yaml
```

Verifying the installation

```
kubectl get pods -n=cert-manager

NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-6559f74744-hkbjs              1/1     Running   0          47s
cert-manager-cainjector-795c46858f-j5lmg   1/1     Running   0          47s
cert-manager-webhook-5dfc77cd74-wmh4g      1/1     Running   0          47s

```

[Back to the main README](../README.md)