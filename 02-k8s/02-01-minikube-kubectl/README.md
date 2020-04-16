# First Kubernetes cluster with Minikube

In this module, we introduce `minikube` to create a local Kubernetes cluster.

You will learn about:

- Kubernetes' main components
- kubectl, the Kubernetes CLI client used to interact with any Kubernetes cluster

## Start

No code provided. We will only use terminal command lines to create our first cluster!

## Setting up a local cluster

In this exercise you will create a local Kubernetes cluster composed of one node.

### Cluster initialisation

To create your own cluster you will need to run the `minikube start` command:

```console
# Windows only
minikube start -p k8scluster --vm-driver hyperv --hyperv-virtual-switch "Default Switch"

# MacOS only
minikube start -p k8scluster
```

Minikube has `--extra-config` options which allow to customise the cluster configuration at the creation time. The minikube [configurator](https://kubernetes.io/docs/setup/learning-environment/minikube/#configuring-kubernetes) passes options to `kubeadm`, the tool used behind the scenes to bootstrap the cluster.

The main components of Kubernetes (`kubelet`, `apiserver`, `proxy`, `controller-manager`, `etcd`, `scheduler`) can be re-configured with `--extra-options` to suit different usage scenarios, such as testing a particular version of the API server. However, the default values are usually fine as a starting point.

Run the following command to verify that all the components of your cluster are healthy:

```console
kubectl get componentstatus
```

The output should be similar to this:

```output
NAME                 STATUS    MESSAGE             ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-0               Healthy   {"health":"true"}
```

### Access to the cluster API

When using `minikube`, Kubernetes runs inside a Linux VM. This VM is not directly accessible but you can find its IP address with:

```console
kubectl cluster-info
```

In order to access services available within the cluster, you can proxy a port to your local host machine with this command:

```console
kubectl proxy --port=8080
```

You can then access the Kubernetes API at <http://localhost:8080/api/>

### Helpful links

- [Minikube](http://github.com/kubernetes/minikube)
- [Kubernetes releases and binaries](https://github.com/kubernetes/kubernetes/releases/latest)
- [Using a proxy to access the API](https://kubernetes.io/docs/tasks/access-kubernetes-api/http-proxy-access-api/)

## Getting used to the kubectl CLI

In this exercise, we will look at the core components of the cluster. This will give us an opportunity to explore the main commands and options of `kubectl`.

### Listing the nodes of the cluster

First, list all the nodes of the cluster:

```console
kubectl get nodes
```

The output should be similar to this:

```output
NAME       STATUS     ROLES    AGE     VERSION
minikube   Ready      master   5m37s   v1.15.0
```

`minikube` is a development tool limited to only one node on your local machine. We will use our master node as a worker node to run our applications.

In a production scenario, the master typically does not execute pods because its components are _tainted_. Pods tolerate rules known as [taints and tolerations](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) to repel/evict work.

When looking at the master node `spec` in our cluster, we can see that no taint has been defined. Run the following command to get the node `spec`:

```console
kubectl get nodes -o json
```

Wait, what is the `spec`?

The spec describe how we want this object to be. If the spec is updated on an object, Kubernetes will reconcile the current state with the spec and take a series of actions (through the controller) to converge to this declared state.

If you look at `items.status.images` JSON entry in this output, you will also find all the Docker images that are known by the node. These have been downloaded, stored on the master node and can be used now to create/recreate containers and pods in the node, just like we did in our previous exercises with the DockerCoin Docker images.

### Listing the pods of the cluster

Now that the cluster is running, which of the core Kubernetes components are running?

To find them, list the pods in all namespaces:

```console
kubectl get pods --all-namespaces
```

The output should be similar to this:

```output
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-5c98db65d4-k444w           1/1     Running   1          13h
kube-system   coredns-5c98db65d4-ptqzn           1/1     Running   1          13h
kube-system   etcd-minikube                      1/1     Running   0          13h
kube-system   kube-apiserver-minikube            1/1     Running   0          13h
kube-system   kube-controller-manager-minikube   1/1     Running   0          13h
kube-system   kube-proxy-cf698                   1/1     Running   0          13h
kube-system   kube-scheduler-minikube            1/1     Running   0          13h
...
```

- `coredns`: the default DNS that is used for service discovery in Kubernetes clusters.
- `kube-apiserver-minikube`: the Kubernetes API server responsible for the communication between all the components in the cluster
- `etcd-minikube`: the Kubernetes "database" storing all object definitions
- `kube-controller-manager`: handles node failures, replicating components, maintaining the correct amount of pods etc.
- `kube-scheduler`: decides which pod to assign to which node based on resource affinity rules / selectors / hardware requirements.

Finally, there is one component that is typically only present on worker nodes (but are running on our combined minikube master+worker node):

- `kube-proxy`: load balances traffic between applications within a node

### Create a namespace

As per the first column in the output from `kubectl get pods` above, we can also see that each pod is in a Kubernetes [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/), a grouping used to organise and isolate pods per team, product, or environment.

We will create and use our own namespace to deploy our application and leave kube-system as the namespace for Kubernetes' internal resources.

Create a namespace and name it after your team:

```console
# Windows only
$env:TEAM_NAME="[team-name-placeholder]"
kubectl create namespace $env:TEAM_NAME

# MacOS only
export TEAM_NAME=[team-name-placeholder]
kubectl create namespace ${TEAM_NAME}
```

You have just created your first Kubernetes resource! List all the namespaces to confirm that your namespace has been created:

```console
kubectl get namespaces
```

The output should be similar to this:

```output
kubectl get namespaces
NAME              STATUS   AGE
my-ns             Active   1m
default           Active   10m
kube-node-lease   Active   10m
kube-public       Active   10m
kube-system       Active   10m
```

**Note**: many Kubernetes resources support both the plural and singular versions as well as a shorthand. For example, `kubectl get ns`, `kubectl get namespace` and `kubectl get namespaces` are all equivalent.

If you want to filter the output of `kubectl` to only one namespace (without having to always pass the `-n` option), permanently save the namespace in your `kubectl` context:

```console
# Windows only
kubectl config set-context --current --namespace=$env:TEAM_NAME

# MacOS only
kubectl config set-context --current --namespace=${TEAM_NAME}
```

### Get details on a pod

Knowing where pods are running is handy to know when debugging an application. Add the `-o wide` option to the previous `kubectl get pods` command to show the namespace name and node name:

```console
kubectl get pods --all-namespaces -o wide
```

This command outputs the name of the pods present on the node. To get more details on a pod, use the `kubectl describe` command:

```console
kubectl describe pod kube-apiserver-minikube -n kube-system
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

We will dig into this topic in module 3, but for now try to delete a pod with this command:

```console
kubectl delete pod kube-apiserver-minikube -n kube-system
```

Run the `kubectl get pods --all-namespaces` to list your pods.

The output will show that the `kube-apiserver-minikube` pod has been re-created to guarantee the desired state of "1 `kube-apiserver-minikube` should be running at all times".

The output below shows the pod was created 11 seconds ago, indicating that it has been recreated recently:

```output
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
...
kube-system   kube-apiserver-minikube            1/1     Running   0          11s
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

### (optional) kubectl verbose mode / debugging

If you are curious about which API endpoints kubectl calls, the verbose option `--v` enables more verbose output from `kubectl`.

For example, level 6 lists all the HTTP calls and their response codes:

```console
kubectl get pods --v 6
```

This option is not frequently used but when used with the value `8`, kubectl will output not only the HTTP requests as well as the responses:

```console
kubectl get pods --v 8
```

### Links

[Kubernetes Components Overview](https://kubernetes.io/docs/concepts/overview/components/)
[API Server](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)
[Scheduler](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/)
[Controller Manager](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/)
[ectd Datastore](https://kubernetes.io/docs/concepts/overview/components/#etcd)
[kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)
[kube-proxy](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/)
[Container Runtime](https://kubernetes.io/docs/concepts/overview/components/#container-runtime)
