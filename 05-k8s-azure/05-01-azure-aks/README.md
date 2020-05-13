# 05-01 Azure Kubernetes Service (AKS) cluster

You will learn about:

* accessing multiple clusters in order to switch between a local and remote AKS cluster

## Start

No code provided in the start state but you will start using an AKS cluster shared by all the participants in the room!

## Kubernetes context and kubeconfig file

To access a Kubernetes cluster, kubectl needs to know the location of the cluster and the credentials to access it.

When creating a cluster, the API server will present a certificate and by default write the root certificate for the API server certificate into the kube config file `$HOME/.kube/config` on the machine running the client used to create the cluster (`minikube`, `kubeadm`, etc).

When creating and accessing multiple clusters, the kube config file stores and merges the list of all the clusters. This can be viewed by running the kubectl command `kubectl config view`.

Get the access credentials to the AKS cluster with the following command:

```console
az aks get-credentials --name rotcaus-aks --resource-group rotcaus
```

Verify if kubectl is pointing at the cluster with:

```console
kubectl config get-contexts
```

The output should be similar to this:

```output
CURRENT   NAME             CLUSTER          AUTHINFO                                NAMESPACE
          k8scluster        k8scluster        k8scluster
*         rotcaus-aks   rotcaus-aks   clusterUser_rotcaus_rotcaus-aks   team-trainers
```

If the current context is not `rotcaus-aks`, change it with `kubectl config use-context rotcaus-aks`

Looking at the AKS nodes, you will see that this cluster is configured to run with 2 worker nodes:

```output
kubectl get nodes
NAME                              STATUS   ROLES   AGE    VERSION
aks-default-13721089-vmss000000   Ready    agent   7h9m   v1.12.8
aks-default-13721089-vmss000001   Ready    agent   7h9m   v1.12.8
```

If you are curious about what is deployed in the AKS cluster, look at the Kubernetes Dashboard with

```console
az aks browse --resource-group rotcaus --name rotcaus-aks
```

This will open a WebUI accessible from a browser on `http://127.0.0.1:8001/`.

List all the namespaces in the cluster with `kubectl get namespaces`.
The output should be similar to this:

```output
wgarcia@Williams-MBP-2 rise-of-containers (master) $ kubectl get namespaces
NAME              STATUS        AGE
default           Active        7h23m
istio-system      Active        7h10m
kube-public       Active        7h23m
kube-system       Active        7h23m
team-coyote       Active        22s
team-goldie       Active        20s
team-icekube      Active        25s
team-moby         Active        8s
team-phippy       Active        23s
team-trainers     Active        95m
team-zee          Active        26s
```

Each team has its own namespace to deploy in isolation!

To switch to your team namespace, run the following command:

```console
# Windows only
$env:TEAM_NAME="[team-name-placeholder]"
kubectl config set-context --current --namespace=$env:TEAM_NAME

# MacOS only
export TEAM_NAME="[team-name-placeholder]"
kubectl config set-context --current --namespace=${TEAM_NAME}
```

Thanks to this last command, you don't need to provide anymore the option `--namespace` to your kubectl commands. All your kubebctl commands will now apply to your the namespace of your choice.

Run this command to confirm that you're using your team namespace:

```console
kubectl config get-contexts
```

The output should be similar to this:

```output
CURRENT   NAME             CLUSTER          AUTHINFO                                NAMESPACE
          k8scluster        k8scluster        k8scluster
*         rotcaus-aks   rotcaus-aks   clusterUser_rotcaus_rotcaus-aks   my-namespace
```

NOTE: Controlling the access to a cluster is not covered here. If you are interested in knowning more about the authentication mechanisms, please read:

* [Controlling Access to the Kubernetes API](https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/)
* [Integrate Azure Active Directory with Azure Kubernetes Service using the Azure CLI](https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration-cli)
* [Best practices for authentication and authorization in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-identity)

Links:

* [Accessing Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster/)
* [Organizing Cluster Access Using kubeconfig Files
](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#supporting-multiple-clusters-users-and-authentication-mechanisms)
