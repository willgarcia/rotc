# Observability

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
