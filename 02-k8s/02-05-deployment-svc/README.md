# 02-05 Kubernetes Deployment and Service

## Create a deployment

Before starting, take a look at the YAML definition of the deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dockercoins
spec:
  selector:
    matchLabels:
      app: dockercoins
  template:
    metadata:
      labels:
        app: dockercoins
    spec:
      containers:
      - name: rng
        image: rotcaus/dockercoins_rng:v1
        imagePullPolicy: Always
      - name: hasher
        image: rotcaus/dockercoins_hasher:v1
        imagePullPolicy: Always
      - name: webui
        image: rotcaus/dockercoins_webui:v1
        imagePullPolicy: Always
        ports:
        - containerPort: 80
      - name: worker
        image: rotcaus/dockercoins_worker:v1
        imagePullPolicy: Always
      - name: redis
        image: redis
```

There are a few noteworthy parts here:

- `metadata`: data to help identify uniquely an object (name, uid)
- `spec`: describes desired state for the object
- the container spec: gives the image, volumes to mount, and ports to expose
- `labels`: key/value pairs used to organise and filter objects by labels. These can be added when creating the object or later. See `kubectl get pods --show-labels`.

Apply this deployment with the `kubectl apply` command:

```console
kubectl apply -f deployment.yml
```

Now that the deployment is created, start looking at the events happening in the cluster:

```console
kubectl get events -w
```

Look for a new pod by running `kubectl get pod`. Once you have found it,

- describe the pod with `kubectl describe pod [pod-name]`
- show the application logs of each container in the pod with `kubectl logs [pod-name]`. This command will ask to specify which container you want to inspect (e.g: `kubectl logs [pod-name] rng`)

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

Once the EXTERNAL-IP shows a valid IP (instead of pending), you should be able to access the application on <http://[EXTERNAL-IP[]>!

Services in Kubernetes open the cluster communication to the outside world.

In the module 3, we will dig into the concept of services to see how they can be used in combination with other resource types to offer HTTPS-enabled services coming with their own domain names.
