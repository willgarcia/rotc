# First application in Kubernetes

In this module, we will run the `DockerCoins` application in a local Kubernetes cluster.

You will learn about:

- How to create pod resources with YAML definitions
- How to view the Kubernetes events that occurred when creating the pod
- How to look at the application logs with kubectl or the Docker CLI
- How to access containers in a pod for troubleshooting purposes
- How to expose the application via HTTP with a basic service

## Start

In the start state, you are provided with the following Docker images:

- `rotcaus/dockercoins_webui`
- `rotcaus/dockercoins_rng`
- `rotcaus/dockercoins_hasher`

Run `cd exercise/` and follow the instructions below to get started!

## One container in one pod

Let's get started and create our first pod!

### Create YAML resource definition for a pod

Your **goals** for this exercise:

- create this first pod in the namespace dedicated to your team, _not in any random namespace_ :D
- use the `busybox` Docker image available from the Docker Hub
- set a default command for your pod, so that it will be executed when the pod starts. This command can be anything: a ping of the public Google DNS will do (command: `ping -c 1000 8.8.8.8`).

Before starting, take some time to go through these tips:

- list all your namespaces to verify that your team namespace still exists: `kubectl get namespaces`
- the [Pod template documentation](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/#pod-templates) might help to set up the default command with the minimal required fields
- to get an idea of what a `spec` may be composed of, you may export the YAML definition of an existing pod running in the cluster, for example: `kubectl get pod kube-apiserver-minikube -o yaml -n kube-system`

Apply or complete the following YAML pod definition with the `kubectl apply` command (use the previous tips to reach the goals):

```console
kubectl apply -f hello-pod.yaml
```

Lost? See the folder `solution` if you need to catch up!

If the pod is successfully created, the output should be similar to this:

```output
pod/hello created
```

### References

[Understanding Kubernetes Objects - Spec and Status](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/#object-spec-and-status)

### Show the events occurring in the pod

By applying a new YAML definition, `kubectl` has sent a request to the API server to submit your new pod. The API server then stored it in `etcd` and let the scheduler assign a node for the new pod.

Once a node is chosen, the kubelet component running on that node calls the local Docker daemon to:

- pull the specified image
- run a container using the image

Even if the pod is created, it is not necessarily running or healthy. A few different steps could fail:

- You might not have permission to deploy in that namespace, depending on your user role
- The cluster might not have permission to pull from the registry
- The image might not exist or might not be pulled successfully due to network issues
- The command might fail to execute
- etc.

Almost there!

Use the `kubectl describe pods hello` to see this list of events in your pod.

If all the necessary steps are successful, the last part of the output should be similar to this:

```output
...
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  25m   default-scheduler  Successfully assigned default/hello to minikube
  Normal  Pulling    25m   kubelet, minikube  Pulling image "busybox"
  Normal  Pulled     25m   kubelet, minikube  Successfully pulled image "busybox"
  Normal  Created    25m   kubelet, minikube  Created container hello
  Normal  Started    25m   kubelet, minikube  Started container hello
```

To see the status of the pod, run `kubectl get pod -n [team-namespace]`.

The output should be similar to this:

```output
NAME                          READY   STATUS    RESTARTS   AGE
hello                         1/1     Running   0          39m
```

### Show the application logs

To confirm that the default ping command works properly, inspect the logs of the pod with the `kubectl logs` command:

```console
kubectl logs --follow pod/hello
```

If you set up your pod with the ping command suggested above, the output should be similar to this:

```output
PING 8.8.8.8 (8.8.8.8): 56 data bytes
...
64 bytes from 8.8.8.8: seq=0 ttl=61 time=149.549 ms
64 bytes from 8.8.8.8: seq=4 ttl=61 time=16.443 ms
64 bytes from 8.8.8.8: seq=5 ttl=61 time=15.812 ms
64 bytes from 8.8.8.8: seq=6 ttl=61 time=16.676 ms
...
```

## Multiple containers in one pod

Real life applications generally run multiple containers per pod.

We will use the DockerCoin application and run all its backend components in a pod to simulate this scenario.

### Create a deployment with multiple containers

Create a file `dockercoins-pod.yaml` and copy the following deployment object:

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
- the container spec: gives the image, volumes to mount, and ports to expose
- `labels`: key/value pairs used to organise and filter objects by labels. These can be added when creating the object or later. See `kubectl get pods --show-labels`.

Apply this deployment with the `kubectl apply` command:

```console
kubectl apply -f dockercoins-pod.yaml
```

Now that the deployment is created, start looking at the events happening in the cluster:

```console
kubectl get events -w
```

Look for the new pod by running `kubectl get pod`. Once you have found it,

- describe the pod with `kubectl describe pod [pod-name]`
- show the application logs of each container in the pod with `kubectl logs [pod-name]`. This command will ask to specify which container you want to inspect (e.g: `kubectl logs [pod-name] rng`)

## Internal access to the pod from within the cluster

By default, the pod is only accessible by its internal IP within the cluster.

The internal IP address of the pod can be found with:

```console
kubectl get pods -o wide
```

Take note the IP from the column IP in the output of the command.

Remote SSH into the `minikube` master node:

```console
minikube ssh -p k8scluster
```

and try to reach the Web UI with:

```console
curl [pod IP]
```

If the pod is accessible, the output should be similar to this:

```output
Found. Redirecting to /index.html
```

Follow the HTTP redirection if you want to get the HTML for the Web UI (`curl http://[Pod-IP]/index.html`).

### External access to the pod - how to create a basic service

Creating a service will enable us to access the DockerCoin app from outside of the cluster via HTTP.

```console
kubectl expose deployment dockercoins --type=LoadBalancer --port=80
```

Then, ask minikube for the generated IP/port of the load balancer and open the application in a browser:

```console
minikube service dockercoins -p k8scluster -n <namespace name>
```

You should see now the DockerCoins application up and running!

Services in Kubernetes open the cluster communication to the outside world.

In the module 3, we will dig into the concept of services to see how they can be used in combination with other resource types to offer HTTPS-enabled services coming with their own domain names.

### Displaying logs from multiple containers

If you want to get the logs of multiple containers in a pod, you might be interested in installing [stern](https://github.com/wercker/stern), a multi pod and container log tailing for Kubernetes. 

On MacOS, Stern is available through Homebrew (`brew install stern`). If you are running Windows, you'll need to download the .exe from <https://github.com/wercker/stern/releases>.

After installation, you can the following commands to get all the logs of all the `DockerCoins` pods:

```console
stern dockercoins
stern dockercoins --container rng --timestamps
```

## Troubleshooting containers in a pod

Just like `docker exec` allows you to run a command in a running container, `kubectl exec` can be used to remotely execute commands in the containers in a pod.

It's easy to abuse `exec` commands and it's not recommended to use it in general on Kubernetes cluster. This is because any action inside a container can modify its behavior from the expected state and lead to inconsistency.
Use it sparingly and ideally only to inspect containers for troubleshooting purposes.

As an example, you can use `kubectl exec` to get an interactive bash session into the container:

```console
kubectl exec -it pod/[NAME] -- /bin/sh
```

If the pod has multiple containers, you will have to pass the name of the container as well as the name of the pod:

```console
kubectl exec -it pod/[NAME] -c [CONTAINER-NAME] -- /bin/sh
```

From here, you can execute any command, such as:

- examining the file system (eg: `ls /var/log/..`, `cat /my-app/web.config`)
- interacting with processes in the container (e.g: `ps aux` to list all the processes active)

Links:

- [Get a shell to a running container](https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/)

## Using kompose (optional)

Now that we are more familiar with Docker Compose and Kubernetes YAML definitions, let's convert a `docker-compose.yaml` file into Kubernetes YAML definitions with [Kompose](https://github.com/kubernetes/kompose).

Install Kompose:

```console
# Windows
choco install kubernetes-kompose

# MacOS
brew install kompose
```

Run the following command in the folder containing `docker-compose.yaml`:

```console
kompose convert -o converted-compose.yaml
```

The conversion wil generate a file `converted-compose.yaml` with one deployment and one service per `DockerCoins` component.

That's not exactly what we want as this would create one pod per `DockerCoins` service (instead of pod for all `DockerCoins` services) but kompose is a great tool to understand how Docker Compose services translate into Kubernetes resources!

Links:

- [Translate a Docker Compose File to Kubernetes Resources](https://kubernetes.io/docs/tasks/configure-pod-container/translate-compose-kubernetes/)

## Cleanup

If you don't want to keep your local Kubernetes cluster, delete it with the following commands:

```console
minikube stop -p k8scluster
minikube delete -p k8scluster
```
