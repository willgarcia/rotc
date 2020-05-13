# 02-02 Kubernetes namespaces

Pods in a Kubernetes are located in [namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/), a grouping used to organise and isolate pods per team, product, or environment.

The different namespaces associated to your pods are visible when running `kubectl get pods --all-namespaces`.

We will create and use our own namespace to deploy our application and leave kube-system as the namespace for Kubernetes' internal resources.

## Create a namespace

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
default           Active   3d22h
kube-node-lease   Active   3d22h
kube-public       Active   3d22h
kube-system       Active   3d22h
```

**Note**: many Kubernetes resources support both the plural and singular versions as well as a shorthand. For example, `kubectl get ns`, `kubectl get namespace` and `kubectl get namespaces` are all equivalent.

If you want to filter the output of `kubectl` to only one namespace (without having to always pass the `-n` option), permanently save the namespace in your `kubectl` context:

```console
# Windows only
kubectl config set-context --current --namespace=$env:TEAM_NAME

# MacOS only
kubectl config set-context --current --namespace=${TEAM_NAME}
```

A namespace is an object type which we could have created with a YAML definition instead of using the `kubectl create` command.

Dump the current namespace with:

```console
# Windows only
kubectl get ns $env:TEAM_NAME --output yaml

# MacOS only
kubectl get ns ${TEAM_NAME} --output yaml
```

The output should be similar to:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: "2020-04-20T03:31:45Z"
  name: [replace-team-name-here]
  resourceVersion: "1536018"
  selfLink: /api/v1/namespaces/will
  uid: d698cb1b-24ba-4f0f-8d36-aba334e3418b
spec:
  finalizers:
  - kubernetes
status:
  phase: Active
```

We will use here the YAML export to create our own YAML definition of the namespace and save it into `ns.yml` with the following content:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: [replace-team-name-here]
```

As you can see, we've removed any of the metadata shown in the exported version to create our own YAML definition of a namespace.

Delete the namespace with:

```console
# Windows only
kubectl delete ns $env:TEAM_NAME --output yaml

# MacOS only
kubectl delete ns ${TEAM_NAME} --output yaml
```

And recreate it from a YAML file:

```bash
kubectl apply -f ns.yml
```

This command has re-created the namespace from a YAML definition that can be know kept in code.
