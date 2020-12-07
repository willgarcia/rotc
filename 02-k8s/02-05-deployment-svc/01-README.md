# 02-05-01 Kubernetes Deployment and Service

## Prerequisites

- Cluster access
- Team namespace configured in current `kubectl` context

## Creating and using a namespace (if required)

```bash
kubectl create ns myapp
```

Use the newly created namespace as your default namespace:

```bash
kubectl config set-context --current --namespace=myapp
```
