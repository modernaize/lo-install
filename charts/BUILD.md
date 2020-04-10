# Helm

## Create a package

```
helm package liveObjects
```

## Create the index.yaml file 

Execute in the root of the repo and update index.yaml based on tar files in master in remote URL

```
helm repo index --url https://raw.githubusercontent.com/liveobjectsai/lo-install/master .
```

## Add remote helm repo 

```
helm repo add liveObjects https://raw.githubusercontent.com/liveobjectsai/lo-install/master/
```

## Update the repo 

```
helm repo update
```

## Install

```
helm install lo liveObjects/liveObjects
```

helm search repo liveObjects
