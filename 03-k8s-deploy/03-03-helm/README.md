# HELM Charts

You will learn about:

* installing existing HELM charts
* building and installing an HELM chart for the `DockerCoins` application
* publish the `DockerCoins` HELM chart to a private Docker registry (Azure Container Registry)
* updating and rollbacking the `DockerCoins` app in Kubernetes with HELM releases

## Start

You are provided with:

* Kubernetes YAML definitions for the `DockerCoins` application
* a HELM chart  for the `DockerCoins` application

## HELM charts

HELM is an application package manager for Kubernetes.

In principle, it provides similar features to other existing package managers:

* installation from local / remote repository**
* local caching of repositories source lists
* dependency management
* install, upgrade, delete of packages known as charts

You may be already using a package manager for:

* Development: `NPM`, `Yarn`, `Nuget`
* OS distributions: `chocolatey` on Windows, `YUM` on CentOS, `APT` for Ubuntu/Debian, `brew` for MacOS.

** HELM charts can be installed from and stored in repositories. Azure Container Registry supports the storage of [private HELM charts](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-helm-repos) in addition to private Docker images.

HELM charts also provide ways to configure the applications with defaults values or overrides making them re-usable:

Links:

* [Manage helm charts for Azure Container Registries](https://docs.microsoft.com/en-us/cli/azure/acr/helm?view=azure-cli-latest)

## Installing a HELM chart from a public repository

For us to get familiar with the HELM CLI, we are going to install the `metabase` application in our cluster.

Let's search for it in the public stable chart repo with:

```console
helm search metabase
```

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

Metabase as no dependencies but for Charts containing a `requirements.yaml`, it is possible to list and update dependencies with:

```console
helm dep list
helm dep update
```

Install `stable/metabase` in the cluster with:

```console
helm install stable/metabase
```

HELM keeps track of the version installed by creating releases:

```console
helm ls
```

The output should be similar to this:

```output
NAME        REVISION    UPDATED                     STATUS      CHART           APP VERSION NAMESPACE
my-release  1           Sat Jul 27 00:08:58 2019    DEPLOYED    metabase-0.5.0  v0.31.2     team-trainers```
```

Wait for the HELM to be installed and follow the instructions on the NOTES:

```console
# Windows only
$env:TEAM_NAME=[team-name-placeholder]
export POD_NAME=$(kubectl get pods --namespace $env:TEAM_NAME -l "app=metabase,release=my-release" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace $env:TEAM_NAME $POD_NAME 8080:3000

# MacOS only
export TEAM_NAME=[team-name-placeholder]
export POD_NAME=$(kubectl get pods --namespace ${TEAM_NAME} -l "app=metabase,release=my-release" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace ${TEAM_NAME} $POD_NAME 8080:3000
```

Access metabase on `http://127.0.0.1:8080`!

## Why HELM charts

The following YAML definitions provide everything we need to create the `DockerCoins` application **without** HELM:

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
        image: k8straining/dockercoins_webui:v1
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
        image: k8straining/dockercoins_rng:v1
        ports:
        - containerPort: 3001
      - name: hasher
        image: k8straining/dockercoins_hasher:v1
        ports:
        - containerPort: 3000
      - name: worker
        image: k8straining/dockercoins_worker:v1
      - name: redis
        image: redis
        ports:
          - containerPort: 6379
---
```

If we were to install or update its Kubernetes resources, we could just run (don't run it):

```console
kubectl apply -f dockercoins-v1.yaml
```

When working with multiple applications, maintaining YAML templates:

* for each resource (Service, Deployment, ServiceAccount, Volumes, ConfigMaps, etc)
* and for each custom configuration (secrets, environment variables, health checks, images' versions, etc)

tends to become a tedious task :(

What are some of the common needs around configuration?

A different configuration:

* per environment: dev, staging, prod.
  * Example with the Deployment resource type: *Dev environment might used a different Docker registry than the Prod environment, so the image names will be different.*
* per user context: locally or in the Cloud.
  * Example with the Service resource type: *a Cloud load balancer will not be used locally to run pods and services*
* ad-hoc configuration:
  * *test the application with new environment variables*
  * *update the application health checks*
  * *test the addition of persistent volumes*

The approach of forking/versioning templates per context of use/per environment is an option but generally leads to an explosion of the number of templates which does not scale well in the context of automated builds / installations integrated into a CI system.

HELM charts solve some of these challenges by providing an abstraction layer on top of Kubernetes YAML definitions. Kubernetes YAML definitions can be templatised and assimilated to configurable manifests that can be bundled as a package.

So, what are the benefits of using a package manager?

* in an enterprise context, packages can be published or come from trusted public or private repositories
* packages can be upgraded or downgraded from one version to another
* packages can have dependencies on other packages. After dependency resolution, all the dependent packages can be installed automatically.

## What is in a HELM chart

We are not going to create the `DockerCoins` chart from scratch but for learning purposes, create a new chart to see what the default skeleton of a chart looks like:

```console
helm create dockercoins
```

The structure of the chart is as following:

* `Chart.yml`: metadata of the chart (chart version, app version, description, icon, source URL, etc)
* `requirements.yaml`: dependencies of the chart (optional)
* `values.yaml`: default configuration values of the chart
* `templates`: Kubernetes YAML definitions, generalised as manifests that can be configured through the chart `values.yaml` file

To transform our Kubernetes YAML definitions present in `dockercoins-v1.yaml` into a HELM chart, we would have to:

* move the `dockercoins-v1.yaml` into the templates folder
* templatise any attribute in the YAML that we want make dynamic. For example, if we want to make the redis image name and version dynamic, so that we can upgrade redis in the future, we would change this static definition from :

```console
      - name: redis
        image: redis
```

to this dynamic HELM templatised version of it:

```console
  - name: redis
        image: "{{ .Values.image.redis.repository }}:{{ .Values.image.redis.tag }}"
```

The next steps would be declare a default value for the redis image and version, using the same path we've used in the template. `values.yaml` would look like:

```console
image:
  redis:
    repository: redis
    tag: latest
```

When executing the HELM chart in the next steps, you will realise that the redis image and its version become elements that can be changed dynamically when installing the chart.

## Search for a HELM chart in an Azure Container Registry

We will use our existing ACR Docker registry `k8straining` to host our `DockerCoins` chart.

First, to avoid specifying the ACR registry name in the next commands, configure your default ACR registry with:

```console
az configure --defaults acr=k8straining
```

Add the `k8straining` repository to HELM repositories index that is cached in your machine:

```console
az acr helm repo add
```

Update the local repository index and list all the charts available in the repository index:

```console
helm repo update
az acr helm list -o table
```

The output should be similar to this:

```console
NAME      CHART VERSION    APP VERSION    DESCRIPTION
--------  ---------------  -------------  ---------------------------
dockercoins  0.1.0            1.0            A Helm chart for Kubernetes
```

Inspect the chart to show its metadata and the possible values that can be configured on it:

```console
helm inspect k8straining/dockercoins
```

In this previous command `k8straining` is the name of the HELM repository (ACR Registry) and `dockercoins` the name of the chart (listed previously with `az acr helm list`).  

Cool, our chart is there and we can change a few configurations on it such as the version of the Docker images to run and the type of node (`LoadBalancer` being the default for a Cloud Load balancer such as the one we use in AKS)

## Run a HELM chart

Install the chart in AKS by running:

```console
# Windows only
helm install k8straining/dockercoins --version 0.1.0 --name $env:TEAM_NAME

# MacOS only
helm install k8straining/dockercoins --version 0.1.0 --name $TEAM_NAME
```

The --name option used here does not represent a Kubernetes namespace but the name of the HELM release. We use the team name here to avoid conflicts between teams' release names.

Once the chart is installed, you should be able to access it by its public IP. Allow some time for the service to be allocated a public IP, use the watch mode `-w` to following the change from "no IP" to "a public IP is assigned to the Kubernetes service":

```console
# Windows only
kubectl get svc --namespace $env:TEAM_NAME -w

# MacOS only
kubectl get svc --namespace $TEAM_NAME -w
```

Once the column IP goes from pending to an available IP, do `Ctrl+C` and access the app with:

```console
NOTES:
1. Get the application URL by running these commands:
     NOTE: It may take a few minutes for the LoadBalancer IP to be available.
           You can watch the status of by running 'kubectl get --namespace team-trainers svc -w dockercoins'

  # Windows only
  $env:SERVICE_IP=$(kubectl get svc --namespace $env:TEAM_NAME dockercoins -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  echo http://$env:SERVICE_IP:80

  # MacOS only
  export SERVICE_IP=$(kubectl get svc --namespace $TEAM_NAME dockercoins -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  echo http://$SERVICE_IP:80
```

## Upgrade and rollback a HELM chart

Run the following command and keep it open in a separate terminal. This will give us the current version of the webui (version 1):

```console
# Windows only
$env:SERVICE_IP=$(kubectl get svc --namespace $env:TEAM_NAME dockercoins -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
while ($true) {start-sleep 1;(iwr http://$env:SERVICE_IP/info).content;}

# MacOS only
export SERVICE_IP=$(kubectl get svc --namespace $TEAM_NAME dockercoins -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
while sleep 1; do echo -e && curl http://$SERVICE_IP/info; done
```

Upgrade the chart with:

```console
# Windows only
helm upgrade --set image.webui.tag=v2 $env:TEAM_NAME k8straining/dockercoins

# MacOS only
helm upgrade --set image.webui.tag=v2 $TEAM_NAME k8straining/dockercoins
```

The version 2 of the Web UI image will add a new HTTP endpoint `/info` to the API.

When running `kubectl get pods -w` during the upgrade process, you should see that a new `DockerCoins` pod is created and once created, the old one gets terminated:

```console
dockercoins-84bb95c9fb-jf6qh   5/5     Terminating        0          2m12s
dockercoins-868cc48795-pbtjz   5/5     Running            0          16s
```

After waiting for the upgrade to be completed, the version in the terminal should go from an error to `{"version":2}`! This happened without interruption of service, the requests were routed to the new pod transparently.

Looking at the HELM history for this release, we should see 2 revisions:

```console
# Windows only
helm history $env:TEAM_NAME

# MacOS only
helm history $TEAM_NAME
```

Expected output:

```output
REVISION	UPDATED                 	STATUS    	CHART         	DESCRIPTION
1       	Sun Jul 28 11:12:17 2019	SUPERSEDED	dockercoins-0.1.0	Install complete
2       	Sun Jul 28 11:14:13 2019	DEPLOYED  	dockercoins-0.1.0	Upgrade complete
```

If version 2 does not operate as expected, you can always rollback it to the revision 1:

```console
# Windows only
helm rollback $env:TEAM_NAME 1

# MacOS only
helm rollback $TEAM_NAME 1
```

Expected output: `Rollback was a success.`

A process similar to the upgrade happened during the rollback. The history has also now a third revision:

```console
# Windows only
helm history $env:TEAM_NAME

# MacOS only
helm history $TEAM_NAME
```

Expected output:

```output
REVISION	UPDATED                 	STATUS    	CHART         	DESCRIPTION
1       	Sun Jul 28 11:12:17 2019	SUPERSEDED	dockercoins-0.1.0	Install complete
2       	Sun Jul 28 11:14:13 2019	SUPERSEDED	dockercoins-0.1.0	Upgrade complete
3       	Sun Jul 28 11:18:24 2019	DEPLOYED  	dockercoins-0.1.0	Rollback to 1
```

After deployment completion, the version from the API should go from version 2 to the initial error (no /info endpoint).

## Cleanup

```console
# Windows only
kubectl delete all --all -n "$env:TEAM_NAME"
helm delete $(helm ls --namespace $env:TEAM_NAME --short)

# MacOS only
kubectl delete all --all -n "${TEAM_NAME}"
helm delete $(helm ls --namespace $TEAM_NAME --short)
```

Links:

* [Find HELM charts](https://docs.microsoft.com/en-us/azure/aks/kubernetes-helm)
