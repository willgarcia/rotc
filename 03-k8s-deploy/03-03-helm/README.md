# 03-03 Helm charts

You will learn about:

* installing existing Helm charts
* building and installing a Helm chart for the `DockerCoins` application
* publishing the `DockerCoins` Helm chart to a private Helm chart repository
* updating and rolling back the `DockerCoins` app in Kubernetes with Helm releases

## Start

You are provided with:

* Kubernetes YAML definitions for the `DockerCoins` application
* a Helm chart for the `DockerCoins` application

## Helm charts

Helm is an application package manager for Kubernetes.

In principle, it provides similar features to other existing package managers:

* installation from local and remote repositories
* local caching of the packages available in a repository
* dependency management
* install, upgrade and deletion of packages (known as 'charts' in Helm parlance)

You may be already using a package manager for:

* development - for example NPM, RubyGems or NuGet
* OS distributions - Chocolatey on Windows, Yum on CentOS, Apt for Ubuntu and Debian or Homebrew for MacOS.

Helm charts can be installed from and stored in repositories. Tools like Artifactory support the storage of private Helm charts in addition to private Docker images.

Helm charts also provide ways to configure the applications with default values or overrides making them customisable.

## Install the Helm CLI

### Windows

Install the following packages with [Chocolatey](https://chocolatey.org):

  ```console
  choco upgrade kubernetes-helm
  ```

### MacOS

Install the following packages with [Homebrew](https://brew.sh):

  ```console
  brew install kubernetes-helm
  ```

## Installing a Helm chart from a public repository

To get familiar with the Helm CLI, we are going to install the `metabase` application in our cluster.

We first need to add the official Helm chart repository to our list of available repositories:

```console
helm repo add stable https://kubernetes-charts.storage.googleapis.com
```

Let's search for it in the public stable chart repository with:

```console
helm search repo metabase
```

A complete list of all the available charts is also available at <https://github.com/helm/charts/tree/master/stable> or with `helm search repo`.

The name of the metabase chart is `stable/metabase`. Download it to look at its content:

```console
helm fetch --untar stable/metabase
cd metabase
```

The structure of the chart is as following:

* `Chart.yml`: metadata of the chart (chart version, app version, description, icon, source URL, etc)
* `requirements.yaml`: dependencies of the chart (optional)
* `values.yaml`: default configuration values of the chart
* `templates`: Kubernetes YAML definitions, generalised as manifests that can be configured through the chart `values.yaml` file

Metabase has no dependencies. For Charts containing a `requirements.yaml`, it is possible to list and update dependencies with:

```console
helm dep list
helm dep update
```

Let's install the metabase chart. Each unique installation of a Helm chart is identified by a name. We can let Helm autogenerate one for us, but it'll be easier if we set our own name:

```console
# Windows only
$env:NAMESPACE="[username-placeholder]" # should be the same as what you used in exercise 03-01
$env:RELEASE_NAME=$env:NAMESPACE + "-metabase"

# MacOS only
export NAMESPACE=[username-placeholder] # should be the same as what you used in exercise 03-01
export RELEASE_NAME="$NAMESPACE-metabase"
```

Install `stable/metabase` in the cluster with:

```console
# Windows only
helm install $env:RELEASE_NAME stable/metabase

# MacOS only
helm install $RELEASE_NAME stable/metabase
```

Helm keeps track of the version installed by creating releases, which we can see by running:

```console
helm ls
```

The output should be similar to this:

```output
NAME        REVISION    UPDATED                     STATUS      CHART           APP VERSION NAMESPACE
my-release  1           Sat Jul 27 00:08:58 2019    DEPLOYED    metabase-0.5.0  v0.31.2     team-trainers
```

Wait for the chart to be installed and follow the instructions in the NOTES:

```console
# Windows only
export POD_NAME=$(kubectl get pods --namespace will -l "app=metabase,release=v1-metabase" -o jsonpath="{.items[0].metadata.name}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl port-forward --namespace $env:NAMESPACE $POD_NAME 8080:3000

# MacOS only
export POD_NAME=$(kubectl get pods --namespace will -l "app=metabase,release=v1-metabase" -o jsonpath="{.items[0].metadata.name}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl port-forward --namespace ${NAMESPACE} $POD_NAME 8080:3000
```

Access metabase on `http://127.0.0.1:8080`!

We're using `kubectl port-forward` here to proxy the Kubernetes traffic of the metabase container 

* from the internal port 8080
* to our local machine on port 3000

This is another useful debugging tool and is not limited to pods created with Helm.

Exit the port-forwarding command with `CRTL-C`.

Let's delete our release before deploying another application:

```console
# Windows only
helm delete $env:RELEASE_NAME

# MacOS only
helm delete $RELEASE_NAME
```

The metabase application has been undeployed.

## Why use Helm charts?

The following YAML definitions provide everything we need to create the `DockerCoins` application **without** Helm:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: dockercoins
  labels:
    app: dockercoins
    service: dockercoins
spec:
  type: LoadBalancer
  ports:
  - port: 80
    name: http
  selector:
    app: dockercoins
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: dockercoins
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dockercoins
  labels:
    app: dockercoins
    version: v1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dockercoins
      version: v1
  template:
    metadata:
      labels:
        app: dockercoins
        version: v1
    spec:
      containers:
      - name: dockercoins
        image: rotcaus/dockercoins_webui:v1
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /
            port: http
        readinessProbe:
          httpGet:
            path: /
            port: http
      - name: rng
        image: rotcaus/dockercoins_rng:v1
        ports:
        - containerPort: 3001
      - name: hasher
        image: rotcaus/dockercoins_hasher:v1
        ports:
        - containerPort: 3000
      - name: worker
        image: rotcaus/dockercoins_worker:v1
      - name: redis
        image: redis
        ports:
          - containerPort: 6379
---
```

If we were to install or update its Kubernetes resources, we could just run the following (don't run it):

```console
kubectl apply -f dockercoins-v1.yaml
```

When working with multiple applications, maintaining these YAML templates for each resource (Service, Deployment, ServiceAccount, Volumes, ConfigMaps etc.)
... tends to become a tedious task :(

The approach of forking/versioning templates per context/per environment is an option but generally leads to an explosion of the number of templates which does not scale well and quickly becomes difficult to manage.

Helm charts solve some of these challenges by providing an abstraction layer on top of Kubernetes YAML definitions. Kubernetes YAML definitions can be templatised and then bundled up as a package.

So, what are the benefits of using a package manager?

* templates can be built, shared and re-used to simplify getting up and running with Kubernetes and manage configuration across different environments
* in an enterprise context, packages can be published or come from trusted public or private repositories
* packages can be upgraded or downgraded from one version to another
* packages can have dependencies on other packages. After dependency resolution, all the dependent packages can be installed automatically.

## What is in a Helm chart?

We are not going to create the `DockerCoins` chart from scratch. However, for learning purposes, create a new chart to see what the default skeleton of a chart looks like:

```console
cd exercise/
helm create dockercoins
```

The structure of the chart is as following:

* `Chart.yml`: metadata of the chart (chart version, app version, description, icon, source URL, etc)
* `requirements.yaml`: dependencies of the chart (optional)
* `values.yaml`: default configuration values of the chart
* `templates`: Kubernetes YAML definitions, generalised as manifests that can be configured through the chart `values.yaml` file

To transform our Kubernetes YAML definitions present in `dockercoins-v1.yaml` into a Helm chart, we would have to:

* move the `demo/dockercoins-v1.yaml` into the templates folder
* templatise any attribute in the YAML that we want to make dynamic. For example, if we want to make the Redis image name and version dynamic, so that we can upgrade Redis in the future, we would change this static definition from:

```console
  - name: redis
    image: redis
```

to this dynamic Helm templatised version of it:

```console
  - name: redis
    image: "{{ .Values.image.redis.repository }}:{{ .Values.image.redis.tag }}"
```

The next steps would be to declare a default value for the Redis image and version, using the same path we've used in the template. `values.yaml` would look like:

```console
image:
  redis:
    repository: redis
    tag: latest
```

When executing the Helm chart in the next steps, you will see how the Redis image can be changed dynamically when installing the chart.

## Search for a Helm chart in a private repository

In addition to using the public Helm chart repository, we can also use private repositories.

We've set up one for you using Google Cloud Storage (similar to AWS S3), but tools like Artifactory can also be used to host private repositories.  

Add the `rotcaus` repository to the list of Helm repositories on your machine:

```console
helm repo add rotcaus https://rotcaus-helm.storage.googleapis.com
```

Update the local repository index and list all the charts available in the newly added repository:

```console
helm repo update
helm search repo rotcaus
```

The output should be similar to this:

```console
NAME                    CHART VERSION   APP VERSION     DESCRIPTION                
rotcaus/dockercoins     0.1.0           1.0             A Helm chart for Kubernetes```

Inspect the chart to show its metadata and the possible values that can be configured on it:

```console
helm inspect chart rotcaus/dockercoins
```

In this previous command `rotcaus` is the name of the Helm repository we added earlier and `dockercoins` the name of the chart.

Cool, our chart is there and we can change a few options on it such as the version of the Docker images to run and the type of service to use (`LoadBalancer` being the default for a cloud load balancer).

## Run a Helm chart

Install the chart in Kubernetes by running:

```console
# Windows only
$env:RELEASE_NAME=$env:NAMESPACE + "-coins"
helm install --wait $env:RELEASE_NAME rotcaus/dockercoins --version 0.1.0

# MacOS only
export RELEASE_NAME="$NAMESPACE-coins"
helm install --wait $RELEASE_NAME rotcaus/dockercoins --version 0.1.0
```

This may take a few moments.

Once the chart is installed, you should be able to access it by its public IP. Allow some time for the service to be allocated a public IP, use the watch mode `-w` to following the change from "no IP" to "a public IP is assigned to the Kubernetes service":

```console
# Windows only
kubectl get svc -w

# MacOS only
kubectl get svc -w
```

Once the column IP goes from pending to an available IP, do `Ctrl+C` and access the app with:

```console
# Windows only
$env:SERVICE_IP=$(kubectl get svc ${env:RELEASE_NAME}-dockercoins -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo http://$env:SERVICE_IP:80

# MacOS only
export SERVICE_IP=$(kubectl get svc $RELEASE_NAME-dockercoins -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo http://$SERVICE_IP:80
```

## Upgrade and rollback a Helm chart

Run the following command and keep it open in a separate terminal. This will give us the current version of the webui (version 1):

```console
# Windows only
while ($true) {start-sleep 1;(iwr http://$env:SERVICE_IP/info).content;}

# MacOS only
while sleep 1; do echo -e && curl http://$SERVICE_IP/info; done
```

Upgrade the chart with:

```console
# Windows only
helm upgrade --wait --set image.webui.tag=v2 $env:RELEASE_NAME rotcaus/dockercoins

# MacOS only
helm upgrade --wait --set image.webui.tag=v2 $RELEASE_NAME rotcaus/dockercoins
```

Version 2 of the web UI image adds a new HTTP endpoint, `/info`, to the API.

If you run `kubectl get pods -w` during the upgrade process, you should see that a new `dockercoins` pod is created. Once the new pod is created, the old one gets terminated:

```console
dockercoins-84bb95c9fb-jf6qh   5/5     Terminating        0          2m12s
dockercoins-868cc48795-pbtjz   5/5     Running            0          16s
```

After waiting for the upgrade to be completed, the version in the terminal should go from an error to `{"version":3}`! This happened without interruption of service, the requests were routed to the new pod transparently.

Looking at the Helm history for this release, we should see 2 revisions:

```console
# Windows only
helm history $env:RELEASE_NAME

# MacOS only
helm history $RELEASE_NAME
```

Expected output:

```output
REVISION	UPDATED                 	STATUS    	CHART         	DESCRIPTION
1       	Sun Jul 28 11:12:17 2019	SUPERSEDED	dockercoins-0.1.0	Install complete
2       	Sun Jul 28 11:14:13 2019	DEPLOYED  	dockercoins-0.1.0	Upgrade complete
```

If version 2 does not operate as expected, you can always rollback to the first version:

```console
# Windows only
helm rollback $env:RELEASE_NAME 1

# MacOS only
helm rollback $RELEASE_NAME 1
```

You should see output similar to: `Rollback was a success! Happy Helming!`

A process similar to the upgrade happened during the rollback. The history has also now a third revision:

```console
# Windows only
helm history $env:RELEASE_NAME

# MacOS only
helm history $RELEASE_NAME
```

Expected output:

```output
REVISION	UPDATED                 	STATUS    	CHART         	DESCRIPTION
1       	Sun Jul 28 11:12:17 2019	SUPERSEDED	dockercoins-0.1.0	Install complete
2       	Sun Jul 28 11:14:13 2019	SUPERSEDED	dockercoins-0.1.0	Upgrade complete
3       	Sun Jul 28 11:18:24 2019	DEPLOYED  	dockercoins-0.1.0	Rollback to 1
```

After the deployment has completed, the version from the API should go from version 2 to the error we were seeing with the original image version (no /info endpoint).

## Cleanup

```console
# Windows only
helm delete --purge $env:RELEASE_NAME
kubectl delete all --all -n "$env:NAMESPACE"

# MacOS only
helm delete --purge $RELEASE_NAME
kubectl delete all --all -n "${NAMESPACE}"
```
