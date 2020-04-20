# Pods

## Get details on a pod

Knowing where pods are running is handy when debugging an application. Add the `-o wide` option to the `kubectl get pods` command to show the namespace name and node name:

```console
kubectl get pods --all-namespaces -o wide
```

This command outputs the name of the pods present on the node. To get more details on a pod, use the `kubectl describe` command:

```console
kubectl describe pod fluentd-gcp-v3.1.1-6sdr8 -n kube-system
```

The output provides all the information associated to the pod:

- `Start Time`: the time the pod started
- `Labels`: additional key/value data associated with the pod
- `Status`: indicates if the pod is running, pending or has crashed
- `IP`: the internal IP of the pod in the node
- `Containers > Image` (e.g: k8s.gcr.io/kube-apiserver:v1.15.0): the Docker image used for the container
- `Containers > Port + Host`: these ports are the pod internal port to access this service as well as the host internal port to access the service from within the node
- `Containers > Command`: the Docker command as specified when creating the pod
- `Containers > Liveness`: the result of the health check specified when creating the pod

### Desired state - Try to break your cluster :o

When listing all the pods in your cluster, you have probably noticed the value `1/1` in the READY column. This indicates that Kubernetes has managed to create the desired state for all the pods:

- 1 pod is expected to be running
- 1 pod is effectively running.

We will dig into this topic in the next exercises about `replicas`, but for now try to delete a pod with this command:

```console
kubectl delete pod fluentd-gcp-v3.1.1-rwhlv -n kube-system
```

Run the `kubectl get pods --all-namespaces` to list your pods.

The output will show that the `fluentd-gcp-v3.1.1-rwhlv` pod has been re-created under a different name to guarantee the desired state of "2".

The output below shows the pod was created 11 seconds ago, indicating that it has been recreated recently:

```output
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
...
kube-system   fluentd-gcp-v3.1.1-2jzpx            1/1     Running   0          11s
...
```

### Work with all the resource types in the cluster

We have been using the `kubectl get` and `kubectl describe` actions to know more about a few component types (`nodes`, `namespaces` and `pods`) deployed in the cluster.

Now that we are more familiar on how to use these commands, we can re-use them to look for any object type and to list all the actions possible on them.

The following command list of the objects/actions possible in the cluster:

```console
kubectl api-resources -o wide
```

Pick one resource type (KIND column) and run this command:

```console
kubectl explain [kind-name]
```

The kubectl command `explain` provides a definition of what the object does, and its main fields.

### kubectl verbose mode / debugging

If you are curious about which API endpoints kubectl calls, the verbose option `--v` enables more verbose output from `kubectl`.

For example, level 6 lists all the HTTP calls and their response codes:

```console
kubectl get pods --v 6
```

This option is not frequently used but when used with the value `8`, kubectl will output not only the HTTP requests as well as the responses:

```console
kubectl get pods --v 8
```
