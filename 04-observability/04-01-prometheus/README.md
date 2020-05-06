# 04-01 Observability

You will learn about:

* application instrumentation / metric collection with Prometheus
* metrics visualisation in Grafana dashboards

## Start

In the start state, you are provided with a version 3 of the `DockerCoins` web UI code as well as its Kubernetes YAML deployment manifest.

Run `cd exercise/` and follow the instructions below to get started!

## Application instrumentation with Prometheus

Instrumentation is a term that refers to:

* adding application logic, generally using a client library
* that will expose application metrics, typicall user-defined metrics, performance metrics that will help to diagnose or trace tivity.

### Adding metrics to a NodeJS application

We will use the `DockerCoins` webui application for this part. This version 3 of the webui adds an endpoint `/metrics` to the existing HTTP API.

Run the webui locally with the following commands:

```console
npm install express redis swagger-stats
node webui.js
```

Redis will throw errors as it is not running but the webui should be still be accessible on port `80`. Generate now traffic on the application by accessing the following HTTP endpoints:

* <http://localhost/info>
* <http://localhost/index.html>

Looking at the `webui.js` file, you will find where the instrumentation code sits:

```js
var swStats = require('swagger-stats');
...
app.use(swStats.getMiddleware());
...
```

We've used here a NodeJS middleware provided by the client library [swagger-stats](http://swaggerstats.io/docs.html). swagger-stats effectively creates the `/metrics` endpoint and expose NodeJS metrics in a format that is already digestabble by Prometheus.

If you work with another language (C#, Java, Python), Prometheus provides different client libraries for the main languages. See [Prometheus client libraries](https://prometheus.io/docs/instrumenting/clientlibs/).

Go to the `/metrics` endpoint and look at the metrics available: `http://localhost/swagger-stats/metrics`.
Some of these metrics exposed by swagger stats will be useful to do monitoring via Prometheus. For example:

* `api_all_success_total` is the number of successful requests on the application
* `api_request_duration_milliseconds_bucket` represents the duration of each request

If you want a visual representation of these metrics go to the swagger-stats dashboard located at <http://localhost/swagger-stats/.>

Ok, so at this stage we've instrumented our application. From here, Prometheus will be able to then scrape this endpoint and collect metrics from our application.

### Collecting application metrics with Prometheus in Kubernetes

To enable Prometheus' scraping on our new API endpoint, we need to use annotations in the Kubernetes YAML deployment definition. Prometheus needs it to scrape the pods running our application and get the metrics from the newly creaated `/metrics` endpoint.

Let's look at these annotations in the YAML definition of our deployment (see file `prometheus-app.yaml`):

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
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/path: 'swagger-stats/metrics'
    spec:
      containers:
      - name: rng
        image: k8straining/dockercoins_rng:v1
        imagePullPolicy: Always
      - name: hasher
        image: k8straining/dockercoins_hasher:v1
        imagePullPolicy: Always
      - name: webui
        image: k8straining/dockercoins_webui:v3
        imagePullPolicy: Always
        ports:
        - containerPort: 80
      - name: worker
        image: k8straining/dockercoins_worker:v1
        imagePullPolicy: Always
      - name: redis
        image: redis
```

Via these annotations, Prometheus leverages the Kubernetes API and uses service discovery mechanics to dynamically find pods that expose metrics.

Start the deployment with:

```console
kubectl apply -f prometheus-app.yaml
```

Verify that `DockerCoins` webui version is up:

```console
kubectl get pods
```

The output should be similar to (5 services of 5 running):

```output
NAME                        READY   STATUS    RESTARTS   AGE
dockercoins-6b849c9888-t2js4   5/5     Running   0          2m4s
```

Access the webui with:

```console
kubectl port-forward $(kubectl get pod -l app=dockercoins -o jsonpath='{.items[0].metadata.name}') 3000:80
```

And visit a few endpoints:

* <http://localhost:3000/info>
* <http://localhost:3000/>

### Visualise metrics in the Prometheus expression browser

The Prometheus expression browser is a web ui provided by Prometheus itself showing all the metrics collected.

Start it by forwarding the local port `9090` on your client machine to port `9090` on the pod that is running Prometheus in your AKS cluster:

```console
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') 9090:9090
```

Go to <http://localhost:9090>.

Search for the expression `api_all_success_total` in the search bar and execute! You should see a the total number of HTTP requests executed on the `DockerCoins` webui :)

Prometheus is a very powerful tool which with PromQL provides advanced querying features. We don't cover these features here but a good starting point to learn about it is look at the [Prometheus data types](https://prometheus.io/docs/prometheus/latest/querying/basics/).

Links:

* [Tools for Monitoring Resources](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/)

### Grafana application dashboard

Now that our application metrics are stored in Prometheus, we can use Grafana to visualise them.

Start the grafana web ui with:

```console
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000
```

The dashboard should now be accessible at <http://localhost:3000>.

From here, select the dashboard called "swagger-stats dashboard release".

You should now see live metrics coming from Prometheus!

## Cluster wide monitoring

In the previous section, we've send metrics from our application to Prometheus and restituted it in Grafana.

### Grafana cluster dashboard

Looking at the Grafana, you will find additional dashboards:

* Kubernetes App Metrics
* Kubernetes cluster monitoring (via Prometheus)
* Kubernetes Deployment metrics
* Kubernetes Nodes - 01 (Node Exporter)
* Kubernetes Pod Metrics

Following the same principle as for our application, these dashboards provides visualisations on the state of the cluster resources, with interesting filtering capabilities on namespaces, pods, containers and more!

### Azure Monitor

Alternatively to Grafana+Prometheus, Azure Monitor can be used to get insights on the cluster activities.

Go to Azure monitor blade of the `k8straining` AKS cluster.

Go to the nodes tab, and add a filter on your team namespace.

* Are all of the pods running on the same node?
* Find a container in a pod and look at its Docker image and environment variables.

The Azure Metrics are currently less complete than in Prometheus+Grafana but Microsoft has rolled out a preview integration of [Azure Monitor with Prometheus](https://azure.microsoft.com/en-au/blog/azure-monitor-for-containers-with-prometheus-now-in-preview/).

## Cleanup

```console
# Windows only
kubectl delete all --all -n "$env:TEAM_NAME"

# MacOS
kubectl delete all --all -n "${TEAM_NAME}"
```
