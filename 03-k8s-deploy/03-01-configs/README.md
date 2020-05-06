# ConfigMaps

You will learn about:

* configurations in Kubernetes
* read configuration from environment variables in the container

Applications typically read configurations in the form of key/value pairs to prepare their environment of execution.

With Config Maps, we will see how to create configurations that can be shared to one or more pods.

## Start

No code provided. You will create Kubernetes YAML definitions for pods that read configurations.

Run `cd exerc/` and follow the instructions below to get started!

### ConfigMaps

Create a file `config-map.yaml` containing a config map that has one key/value (`debug.level=INFO`):

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  debug.level: INFO
```

Store the configuration map in Kubernetes with:

```console
kubectl apply -f config-map.yaml
```

Now, create a simple pod that will read it (see provided template `config-pod.yaml`):

```console
kubectl apply -f config-pod.yaml
```

Find the newly created pod name with `kubectl get pods` and confirm that the pod has successfully extracted the value of the configuration identified by the key `debug.level`:

```console
kubectl logs pod/app
```

The output should be similar to this:

```output
INFO
```

Config maps can alternatively be created via the kubectl command `kubectl create configmap` and passed as files or CLI arguments.

Links:

* [Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)

## Cleanup

```console
# Windows only
kubectl delete all --all -n "$env:TEAM_NAME"

# MacOS
kubectl delete all --all -n "${TEAM_NAME}"
```
