# Pods

## Create a pod

In the exercise folder, run the following command to create your first pod:

```bash
kubectl apply -f pod.yml
```

## Verify that the pod is created

Use the `kubectl describe` command to verify the status of the pod:

```console
kubectl describe pod dockercoins
```

This pod runs multiple containers, the `Events` section will list a log of all the events associated to all the containers running the pod.

If a pod fails, the `Events` section will show the failure reason. A common failure reason is when the Docker image does not exist.

The output also provides the following information:

- `Start Time`: the time the pod started
- `Labels`: additional key/value data associated with the pod
- `Status`: indicates if the pod is running, pending or has crashed
- `IP`: the internal IP of the pod in the node
- `Containers > Image` (e.g: k8s.gcr.io/kube-apiserver:v1.15.0): the Docker image used for the container
- `Containers > Port + Host`: these ports are the pod internal port to access this service as well as the host internal port to access the service from within the node
- `Containers > Command`: the Docker command as specified when creating the pod
- `Containers > Liveness`: the result of the health check specified when creating the pod

## Get the logs of the pod

To access the logs of the containers running in the pod, run this command:

```console
kubectl logs pod/dockercoins
```

Given this pod has more than one container, you need to specify which container you want to get the logs from:

```console
kubectl logs pod/dockercoins [rng hasher webui worker redis]
```

The name of each container is defined in the pod YAML definition.

### Useful links

* [Stern - Multi pod and container log tailing for Kubernetes
](https://github.com/wercker/stern)