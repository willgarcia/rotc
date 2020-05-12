# 03-02 Kubernetes Secrets

You will learn about:

* secrets in Kubernetes
* read secrets from volumes mounted in the container
* create secrets that can be shared to one or more pods.

## Start

No code provided. You will create Kubernetes YAML definitions for pods that read secrets.

Run `cd exercise/` and follow the instructions below to get started!

### Secret maps

Secrets are similiar in principle to config maps.

Instead of using a YAML definition this time, let's create the secret with the kubectl CLI:

```console
kubectl create secret generic my-secret --from-literal=password=helloWorld42+
```

Create a pod that will read the secret value from a Docker volume:

```console
kubectl apply -f secret-pod.yaml
```

Find the newly created pod name with `kubectl get pods` and confirm that the pod has successfully extracted the secret of the configuration identified by the key `password`:

```console
kubectl logs pod/secret-app
```

The output should be similar to this:

```output
helloWorld42+
```
## Secrets are encoded, but not encrypted
It is  important to note that secrets are not encrypted by default (they are only encoded)

Display the contents of the secret we have just created
```output
kubectl get secret my-secret -o yaml
```

Decode the secret

```output
echo -n '*.......*==' | base64 -D
```
The output should be

```output
helloWorld42+
```

NOTE: Config Maps and secrets in Kubernetes do not signal pods when new key/values are available. Pods will have to be restarted after adding or updating them.

Links:

* [Using Secrets as Files from a Pod](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod)
* [Distribute Credentials Securely Using Secrets](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#create-a-secret)

## Cleanup

```console
# Windows only
kubectl delete all --all -n "$env:TEAM_NAME"
kubectl delete secret my-secret

# MacOS
kubectl delete all --all -n "${TEAM_NAME}"
kubectl delete secret my-secret
```
