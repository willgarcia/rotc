# Observability

New versions of Istio will not have the observabilities tools installed by default. So we will need to install all and configure them. To help with this process, we will use Helm.

## Setup

1. Install Helm in your machine

```shell
brew install helm
helm add repo stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
```

2. Create a namespace for all the monitoring tools

```shell
kubectl apply -f ./exercise/namespace.yaml
```

## Prometheus

By default prometheus will get metrics from istio.

3. Install Prometheus

```shell
helm install prometheus stable/prometheus
```

To access the server first get the name of the prometheus-server pod:
```shell
kubectl get pods -n monitoring
NAME                                             READY   STATUS    RESTARTS   AGE
prometheus-alertmanager-66c9754c64-7w57q         2/2     Running   0          10m
prometheus-kube-state-metrics-6df5d44568-299k2   1/1     Running   0          10m
prometheus-node-exporter-klrtn                   1/1     Running   0          10m
prometheus-node-exporter-vzpd7                   1/1     Running   0          10m
prometheus-pushgateway-84bf7f5876-gpz5w          1/1     Running   0          10m
prometheus-server-6cd89ddd8f-nlrwc               2/2     Running   0          10m
```

Then do a port-forward to it
```shell
kubectl port-forward prometheus-server-6cd89ddd8f-nlrwc 3000:9090 -n monitoring
```

Just go to http://localhost:3000 to access it.

## Grafana

4. Create a ConfigMap to connect Grafana to Prometheus

```shell
kubectl apply -f ./exercise/grafana-config-map.yaml
```

4.1 Install Grafana using the config file `grafana-config.yaml`

```shell
helm install grafana stable/grafana -f exercise/grafana-config.yaml -n monitoring
```

## Zipkin/Jaeger

Zipkin and Jaeger are tools to trace all the requests done inside the cluster to respond an user request. For it to work, istio requires that your application propagate some headers in all requests and responses. See https://istio.io/latest/docs/tasks/observability/distributed-tracing/overview/ for more information.

To install Jaeger we can use Helm. We only need to configure the collector zipkin port. (For this exercise, we are reducing the number of resources, so all the other flags have this function).


```shell
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
help repo update

helm install jaeger jaegertracing/jaeger \
--set collector.service.zipkin.port=9411 \
--set cassandra.config.max_heap_size=1024M \
--set cassandra.config.heap_new_size=256M \
--set cassandra.resources.requests.memory=2048Mi \
--set cassandra.resources.requests.cpu=0.4 \
--set cassandra.resources.limits.memory=2048Mi \
--set cassandra.resources.limits.cpu=0.4
-n monitoring
```

After that, we can see the new services created. 

```shell
$ kubectl get services -n monitoring

NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                         AGE
jaeger-agent       ClusterIP   172.20.209.199   <none>        5775/UDP,6831/UDP,6832/UDP,5778/TCP,14271/TCP   25s
jaeger-cassandra   ClusterIP   None             <none>        7000/TCP,7001/TCP,7199/TCP,9042/TCP,9160/TCP    25s
jaeger-collector   ClusterIP   172.20.138.0     <none>        14250/TCP,14268/TCP,9411/TCP,14269/TCP          25s
jaeger-query       ClusterIP   172.20.254.118   <none>        80/TCP,16687/TCP                                25s
[...]
```

Now we need to update the istio proxy to point to the jaeger collector. We can do it in two ways:

```shell
istioctl upgrade --set values.global.tracer.zipkin.address=jaeger-collector.default:9411

# This command was not working in the alpha version of istio. But it worked in the stable version.
```

OR 

```
kubectl get configmap istio -n istio-system -o yaml > istio-config-map.yaml
```

change to  
```yaml
      [...]
      tracing:
        zipkin:
          address: jaeger-collector.monitoring:9411
      [...]
```

and apply it

```
kubectl apply -f istio-config-map.yaml
```

Wait some seconds and restart the pods on the namespace using the command:

```
kubectl rollout restart deployment --namespace default
```

All pods are going to restart and new sidecars are going to be created. The new sidecars will have the new address. We can check using the describe command in one pod.

```shell
kubectl describe pod <podname>
```

Look into the container list for the `istio-proxy` container. Now it should have a environment variable named PROXY_CONFIG with value:

```
{"tracing":{"zipkin":{"address":"jaeger-collector.monitoring:9411"}},"proxyMetadata":{"DNS_AGENT":""}}
```


## With Kiali

Kiali is a management console for an Istio-based service mesh. It provides dashboards, observability and lets you to operate your mesh from the browser as an alternative to the terminal. In this exercise you will learn how to view the dashboard.

There are two components to Kiali - the application (back-end) and the console (front-end). The application runs in Kubernetes and interacts with the service mesh components to expose data to the console.

### Setup

Before starting, set up Kiali to easily visualise traffic routes. Ignore this if you already set up Kiali in 06-01-featuretoggles.

1. Install `istioctl` (on Mac, this can be done with Homebrew).
2. Run `istioctl dashboard kiali`.
3. Login with the default username *admin* and default password *admin*.

The Kiali dashboard shows an overview of your mesh with the relationships between the services in the Bookinfo sample application.

### Understanding the Graph

Navigate to *Graph* in the sidebar. You should see the bookinfo app mapped out using triangles for Services, circles for Workflows and squares for Applications. These components of the app are connected by the weighted edges we manipulated in 06-02-trafficshifting. Click around with the and play with the visualisation.

The parts of the app are labelled as such, with 'productpage' and their version because this information is set in the metadata block of the config.

```
metadata:
  name: reviews
  labels:
    app: reviews
    version: v1
```

To get a more granular view of an application, you can:

  1. Click into the box
  2. Select the three vertical dots
  3. Show details

From there it will take you directly to the application in the *Applications* tab, where you can view the health of the application, the pod status and which app pathways it interacts with.

### Workloads

*Workloads* correspond to a Kubernetes *deployment*, whereas a *workload instance* corresponds to an *individual pod*.

Clicking into a workload in the Workload sidebar item will allow you to inspect individual Pods and associated Services.

### Services

On a Service's page, you can see the metrics, traces, workloads, virtual services, destination rules, etc. If you applied any custom labels to the services in your mesh, this is a quick way to filter them and get an overview of their health or properties.
