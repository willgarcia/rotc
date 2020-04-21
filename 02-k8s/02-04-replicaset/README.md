# Replica set

## Create a replica set

From the exercise folder, run the following command to create your first replica set:

```bash
kubectl apply -f replicaset.yml
```

The attribute `replicas` in the YAML definition of the replicaset shows that we start with only one pod replica.

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: dockercoins
spec:
  replicas: 1
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

When listing the pods with `kubectl get pods`, you should only one pod running. The pod will automatically be given a unique name, for example:

```bash
NAME                READY   STATUS              RESTARTS   AGE
dockercoins-nh6wd   0/5     ContainerCreating   0          6s
```

You can now list the replicaset previously created with `kubectl get rs`. This will show that the desired number of pod replicas is 1 and that the current number of pod replicas running is also 1:

```bash
NAME          DESIRED   CURRENT   READY   AGE
dockercoins   1         1         1       84s
```

## Scaling our application to multiple instances

Change the number of `replicas` in the `replicaset.yml` file from 1 to 2.

Then, apply the following command to update the replicaset:

```bash
kubectl apply -f replicaset.yml
```

The current number of pods should be equal to the desired number of replicas!

When listing the pods with `kubectl get pods`, we should now have an additional pod running along with first pod that already existed.

```bash
NAME                READY   STATUS              RESTARTS   AGE
dockercoins-hgclz   5/5     Running   0          49s
dockercoins-nh6wd   5/5     Running   0          5m6s
```

Describe the replicaset that has been created to see what are the events that occurred at the creation time:

```console
kubectl describe replicasets dockercoins
```

The output should be similar to:

```bash
....
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  17s   replicaset-controller  Created pod: dockercoins-6kcp6
  Normal  SuccessfulCreate  10s   replicaset-controller  Created pod: dockercoins-w8z6j
```

2 instances of our pods are running at the same time, meaning that a set of 5 containers per pod is running. This helped us to scale to 2 instances both frontend, backend and the redis store containers.

If the unit of scale should be the worker only (and not the frontend or the redis store), then it would be more appropriate to move the worker container into a separate pod that can be replicated independently with its own replicaset.

## Delete a pod in the replicaset

Delete one of the pods with `kubectl delete pod/[pod-name]`.

You will notice that the pod gets re-created automatically. This is due to the fact that the replica set still exists and defines a minimum of 2 pod replicas.

A control loop and a controller managed behind the scene by Kubernetes are looking at the current state (one pod - since one has been deleted) and trying to match/guarantee the desired state of 2 pod replicas. This is called the reconciliation process.

## Delete the replicaset

The only way to permanently delete all pods / avoid them to be re-created is to also delete the replica set:

```bash
kubectl delete -f replicaset.yml
```
