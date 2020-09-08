# 02-05-03 Kubernetes Deployment and Service

## External access to the pod - how to create a basic service

By default, the pod is only accessible by its internal IP within the cluster.

The internal IP address of the pod can be found with:

```console
kubectl get pods -o wide
```

Creating a service will enable us to access the app from outside of the cluster via HTTP.

Create the service with the following command:

```console
kubectl apply -f service.yml
```

The service is being created and can be list with:

```bash
kubectl get svc -w
```

With minikube, to access the app, run the following command:

```bash
minikube service dockercoins -n [namespace] -p [minikube-profile-name]
```

With a Cloud cluster, once the EXTERNAL-IP shows a valid IP (instead of pending), you should be able to access the application on <http://[EXTERNAL-IP[]>!

Services in Kubernetes open the cluster communication to the outside world.

In the module 3, we will dig into the concept of services to see how they can be used in combination with other resource types to offer HTTPS-enabled services coming with their own domain names.
