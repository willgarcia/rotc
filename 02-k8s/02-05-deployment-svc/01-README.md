# 02-05 Kubernetes Deployment and Service

## Pre-requisites

### kubectl

```bash
brew install kubernetes-cli
```

### Kubernetes cluster

If you need to run this exercise locally, use minikube:

```bash
brew install minikube
```

And create a local cluster with this command:

```bash
minikube start -p demo
```

## Create a namespace

```bash
kubectl create ns myapp
```

Use the newly created namespace as your default namespace:

```bash
kubectl config set-context --current --namespace=myapp
```

