# 02-05-02 Kubernetes Deployment and Service

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
  - `spec.template` is the template container spec (image, volumes to mount, and ports to expose etc)
- `labels`: key/value pairs used to organise and filter objects by labels. These can be added when creating the object or later. See `kubectl get pods --show-labels`.

Apply this deployment with the `kubectl apply` command:

```console
kubectl apply -f deployment.yml
```

Now that the deployment is created, start looking at the events happening in the cluster:

```console
kubectl get events --watch
```

Look for a new pod by running `kubectl get pod`. Once you have found it,

- describe the pod with `kubectl describe pod [pod-name]`
- show the application logs of each container in the pod with `kubectl logs [pod-name]`. This command will ask to specify which container you want to inspect (e.g: `kubectl logs [pod-name] rng`)
