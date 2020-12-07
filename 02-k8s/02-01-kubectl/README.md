# 02-01 `kubectl`

In this module, we introduce `kubectl` to access a remote Kubernetes cluster.

You will learn about:

- Kubernetes' main components
- kubectl, the Kubernetes CLI client used to interact with any Kubernetes cluster

## Setup

Depending on where the Kubernetes cluster for the workshop has been setup, follow the instructions in one of the sections below:

### GCP

    ```bash
    # Windows
    choco upgrade gcloudsdk

    # MacOS
    brew cask install google-cloud-sdk
    ```


    ```bash
    gcloud auth login
    gcloud auth application-default login

    gcloud container clusters get-credentials k8s-cluster --region australia-southeast1-a --project rotcaus
    ```

### Azure

    ```bash
    # Windows
    choco upgrade azure-cli

    # MacOS
    brew cask install azure-cli
    ```

    ```console
    az login

    az aks get-credentials --name rotcaus-aks --resource-group rotcaus
    ```

## Start

No code provided. We will only use terminal command lines to access a remote cluster!

### Access to the cluster API

When running Kubernetes locally, it typically runs inside a Linux VM. This VM is not directly accessible.

When running Kubernetes on AWS/Azure/GCP etc, the Kubernetes API is hosted by the provider.

You can see the address for the Kubernetes API server using:

```console
kubectl cluster-info
```

In order to access services available within the cluster, you can proxy a port to your local host machine with this command:

```console
kubectl proxy --port=8080
```

You can then access the Kubernetes API at <http://localhost:8080/>

Ctrl+C to stop the port forwarding.

### Helpful links

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
NAME                                              STATUS   ROLES    AGE     VERSION
gke-k8s-cluster-default-node-pool-6681a730-d257   Ready    <none>   3d21h   v1.15.11-gke.5
gke-k8s-cluster-default-node-pool-e61f3b84-f9h6   Ready    <none>   3d21h   v1.15.11-gke.5
gke-k8s-cluster-default-node-pool-ffbb1244-ghkc   Ready    <none>   3d21h   v1.15.11-gke.5
```

In a production scenario, the master typically does not execute pods.

Any Kubernetes Object can be inspected via the kubectl command line.
Below is an example.

```console
kubectl get nodes -o yaml
```

There may be a lot of output but have a look at the top of the definition there is a `spec:` section.

Wait, what is the `spec`?

The spec describe how we want this object to be. It is the definition that you supply when defining Kubernetes Objects. This is what is likely stored in version control. 

If the spec is updated on an object, Kubernetes will reconcile the current state with the spec and take a series of actions (through the controller) to converge to this declared state.

If you look at `images` YAML entry in this output, you will also find all the Docker images that are known by the node. These have been downloaded, stored on the master node and can be used now to create/recreate containers and pods in the node.

### Listing the pods of the cluster

Now that the cluster is running, which of the core Kubernetes components are running?

To find them, list the pods in all namespaces:

```console
kubectl get pods --all-namespaces
```

The output should be similar to this:

```output
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS   AGE
kube-system   event-exporter-v0.3.0-74bf544f8b-6fsnt                       2/2     Running   0          3d21h
kube-system   fluentd-gcp-scaler-dd489f778-vzthj                           1/1     Running   0          3d21h
kube-system   fluentd-gcp-v3.1.1-6sdr8                                     2/2     Running   0          3d21h
kube-system   fluentd-gcp-v3.1.1-ltmb5                                     2/2     Running   0          3d21h
kube-system   fluentd-gcp-v3.1.1-rwhlv                                     2/2     Running   0          3d21h
kube-system   heapster-gke-6984f5967b-j7t42                                3/3     Running   0          3d21h
kube-system   kube-dns-5dbbd9cc58-2bc7t                                    4/4     Running   0          3d21h
kube-system   kube-dns-5dbbd9cc58-xv6gn                                    4/4     Running   0          3d21h
kube-system   kube-dns-autoscaler-6b7f784798-xj8hz                         1/1     Running   0          3d21h
kube-system   kube-proxy-gke-k8s-cluster-default-node-pool-6681a730-d257   1/1     Running   0          3d21h
kube-system   kube-proxy-gke-k8s-cluster-default-node-pool-e61f3b84-f9h6   1/1     Running   0          3d21h
kube-system   kube-proxy-gke-k8s-cluster-default-node-pool-ffbb1244-ghkc   1/1     Running   0          3d21h
kube-system   l7-default-backend-84c9fcfbb-l4qll                           1/1     Running   0          3d21h
kube-system   metrics-server-v0.3.3-6d96fcc55-frsgt                        2/2     Running   0          3d21h
kube-system   prometheus-to-sd-7j246                                       2/2     Running   0          3d21h
kube-system   prometheus-to-sd-b7ktx                                       2/2     Running   0          3d21h
kube-system   prometheus-to-sd-xmzjm                                       2/2     Running   0          3d21h
kube-system   stackdriver-metadata-agent-cluster-level-c678bc98d-j5sbz     2/2     Running   0          3d21h
```

- `coredns`: the default DNS that is used for service discovery in Kubernetes clusters.
- `kube-apiserver`: the Kubernetes API server responsible for the communication between all the components in the cluster
- `etcd`: the Kubernetes "database" storing all object definitions
- `kube-controller-manager`: handles node failures, replicating components, maintaining the correct amount of pods etc.
- `kube-scheduler`: decides which pod to assign to which node based on resource affinity rules / selectors / hardware requirements.

Finally, there is one component that is typically only present on worker nodes:

- `kube-proxy`: load balances traffic between applications within a node


These above pods are what is needed by Kubernetes to operate.

In the next exercise we will create our own custom Pods to run an application.

### Links

[Kubernetes Components Overview](https://kubernetes.io/docs/concepts/overview/components/)
[API Server](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)
[Scheduler](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/)
[Controller Manager](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/)
[ectd Datastore](https://kubernetes.io/docs/concepts/overview/components/#etcd)
[kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)
[kube-proxy](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/)
[Container Runtime](https://kubernetes.io/docs/concepts/overview/components/#container-runtime)
