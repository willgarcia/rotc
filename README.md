# Kubernetes

## Structure
* `exercise/`: exercise - attendees
* `solution/`: exercise's solution, solution scripts - attendees
* `.build/`: instruction / build scripts - trainers only
* `demo/`: demos - trainers only

[Build tasks to provision Kubernetes in AWS/GCP/Azure](./.build/README.md)

## References

* `docker` CLI reference: <https://docs.docker.com/engine/reference/commandline/docker/>
* `docker-compose` CLI reference: <https://docs.docker.com/compose/reference/>
* `kubectl` CLI reference: <https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#expose> 
* `kubectl` Cheat sheet: <https://kubernetes.io/docs/reference/kubectl/cheatsheet/>

Sample app from Jérôme Petazzoni - code under [Apache License 2.0](https://github.com/jpetazzo/container.training/blob/master/LICENSE)

## Table of contents

   * [01-01-01 Docker](./01-docker/01-docker/EXERCISE-01.md#01-01-01-docker)
      * [Start](./01-docker/01-docker/EXERCISE-01.md#start)
      * [Building Docker Images](./01-docker/01-docker/EXERCISE-01.md#building-docker-images)
         * [Dockerfile](./01-docker/01-docker/EXERCISE-01.md#dockerfile)
            * [Note](./01-docker/01-docker/EXERCISE-01.md#note)
      * [Next steps](./01-docker/01-docker/EXERCISE-01.md#next-steps)

   * [01-01-02 Docker](./01-docker/01-docker/EXERCISE-02.md#01-01-02-docker)
      * [Tagging and Publishing a Docker Image](./01-docker/01-docker/EXERCISE-02.md#tagging-and-publishing-a-docker-image)
         * [Tag the Docker images](./01-docker/01-docker/EXERCISE-02.md#tag-the-docker-images)
         * [Authenticate to the Docker Hub registry](./01-docker/01-docker/EXERCISE-02.md#authenticate-to-the-docker-hub-registry)
         * [Publish the Docker image](./01-docker/01-docker/EXERCISE-02.md#publish-the-docker-image)
      * [Next steps](./01-docker/01-docker/EXERCISE-02.md#next-steps)

   * [01-01-03 Docker](./01-docker/01-docker/EXERCISE-03.md#01-01-03-docker)
      * [Running Docker Containers](./01-docker/01-docker/EXERCISE-03.md#running-docker-containers)
         * [Remove local Docker images](./01-docker/01-docker/EXERCISE-03.md#remove-local-docker-images)
         * [Start the twkoins_webui service container](./01-docker/01-docker/EXERCISE-03.md#start-the-twkoins_webui-service-container)
      * [Cleanup](./01-docker/01-docker/EXERCISE-03.md#cleanup)

   * [01-02 Docker Compose](./01-docker/02-compose/README.md#01-02-docker-compose)
      * [Start](./01-docker/02-compose/README.md#start)
      * [Create a Compose file](./01-docker/02-compose/README.md#create-a-compose-file)
      * [Container DNS names](./01-docker/02-compose/README.md#container-dns-names)
      * [Scaling our app](./01-docker/02-compose/README.md#scaling-our-app)
      * [Docker Compose Limitations](./01-docker/02-compose/README.md#docker-compose-limitations)
      * [Cleanup](./01-docker/02-compose/README.md#cleanup)

   * [02-01 Kubectl](./02-k8s/02-01-kubectl/README.md#02-01-kubectl)
      * [Setup](./02-k8s/02-01-kubectl/README.md#setup)
         * [GCP](./02-k8s/02-01-kubectl/README.md#gcp)
         * [Azure](./02-k8s/02-01-kubectl/README.md#azure)
      * [Start](./02-k8s/02-01-kubectl/README.md#start)
         * [Access to the cluster API](./02-k8s/02-01-kubectl/README.md#access-to-the-cluster-api)
         * [Helpful links](./02-k8s/02-01-kubectl/README.md#helpful-links)
      * [Getting used to the kubectl CLI](./02-k8s/02-01-kubectl/README.md#getting-used-to-the-kubectl-cli)
         * [Listing the nodes of the cluster](./02-k8s/02-01-kubectl/README.md#listing-the-nodes-of-the-cluster)
         * [Listing the pods of the cluster](./02-k8s/02-01-kubectl/README.md#listing-the-pods-of-the-cluster)
         * [Links](./02-k8s/02-01-kubectl/README.md#links)

   * [02-02 Kubernetes namespaces](./02-k8s/02-02-ns/README.md#02-02-kubernetes-namespaces)
      * [Create a namespace](./02-k8s/02-02-ns/README.md#create-a-namespace)

   * [02-03 Kubernetes pods](./02-k8s/02-03-pods/README.md#02-03-kubernetes-pods)
      * [Start](./02-k8s/02-03-pods/README.md#start)
      * [Create a pod](./02-k8s/02-03-pods/README.md#create-a-pod)
         * [References](./02-k8s/02-03-pods/README.md#references)
      * [Show all events occurring in the pod](./02-k8s/02-03-pods/README.md#show-all-events-occurring-in-the-pod)
      * [Access the logs of a pod](./02-k8s/02-03-pods/README.md#access-the-logs-of-a-pod)
      * [Troubleshoot containers running in a pod](./02-k8s/02-03-pods/README.md#troubleshoot-containers-running-in-a-pod)
      * [Displaying logs from multiple containers (optional part)](./02-k8s/02-03-pods/README.md#displaying-logs-from-multiple-containers-optional-part)
      * [Delete a pod](./02-k8s/02-03-pods/README.md#delete-a-pod)

   * [02-04 Kubernetes replica set](./02-k8s/02-04-replicaset/README.md#02-04-kubernetes-replica-set)
      * [Create a replica set](./02-k8s/02-04-replicaset/README.md#create-a-replica-set)
      * [Scaling our application to multiple instances](./02-k8s/02-04-replicaset/README.md#scaling-our-application-to-multiple-instances)
      * [Delete a pod in the replicaset](./02-k8s/02-04-replicaset/README.md#delete-a-pod-in-the-replicaset)
      * [Delete the replicaset](./02-k8s/02-04-replicaset/README.md#delete-the-replicaset)

   * [02-05-01 Kubernetes Deployment and Service](./02-k8s/02-05-deployment-svc/01-README.md#02-05-01-kubernetes-deployment-and-service)
      * [Pre-requisites](./02-k8s/02-05-deployment-svc/01-README.md#pre-requisites)
         * [kubectl](./02-k8s/02-05-deployment-svc/01-README.md#kubectl)
         * [Kubernetes cluster](./02-k8s/02-05-deployment-svc/01-README.md#kubernetes-cluster)
      * [Create a namespace](./02-k8s/02-05-deployment-svc/01-README.md#create-a-namespace)

   * [02-05-02 Kubernetes Deployment and Service](./02-k8s/02-05-deployment-svc/02-README.md#02-05-02-kubernetes-deployment-and-service)
      * [Create a deployment](./02-k8s/02-05-deployment-svc/02-README.md#create-a-deployment)

   * [02-05-03 Kubernetes Deployment and Service](./02-k8s/02-05-deployment-svc/03-README.md#02-05-03-kubernetes-deployment-and-service)
      * [External access to the pod - how to create a basic service](./02-k8s/02-05-deployment-svc/03-README.md#external-access-to-the-pod---how-to-create-a-basic-service)

   * [03-01 Kubernetes ConfigMaps](./03-k8s-deploy/03-01-configs/README.md#03-01-kubernetes-configmaps)
      * [Start](./03-k8s-deploy/03-01-configs/README.md#start)
         * [ConfigMaps](./03-k8s-deploy/03-01-configs/README.md#configmaps)
      * [Cleanup](./03-k8s-deploy/03-01-configs/README.md#cleanup)

   * [03-02 Kubernetes Secrets](./03-k8s-deploy/03-02-secrets/README.md#03-02-kubernetes-secrets)
      * [Start](./03-k8s-deploy/03-02-secrets/README.md#start)
         * [Secret maps](./03-k8s-deploy/03-02-secrets/README.md#secret-maps)
      * [Secrets are encoded, but not encrypted](./03-k8s-deploy/03-02-secrets/README.md#secrets-are-encoded-but-not-encrypted)
      * [Cleanup](./03-k8s-deploy/03-02-secrets/README.md#cleanup)

   * [03-03 Ingress](./03-k8s-deploy/03-03-ingress/README.md#03-03-ingress)
      * [Ingress rules](./03-k8s-deploy/03-03-ingress/README.md#ingress-rules)
         * [Nginx ingress controller, path-based routing](./03-k8s-deploy/03-03-ingress/README.md#nginx-ingress-controller-path-based-routing)
         * [Nginx ingress controller, using a domain name](./03-k8s-deploy/03-03-ingress/README.md#nginx-ingress-controller-using-a-domain-name)
         * [Nginx ingress controller, one domain name, two services](./03-k8s-deploy/03-03-ingress/README.md#nginx-ingress-controller-one-domain-name-two-services)

   * [03-04 Helm charts](./03-k8s-deploy/03-04-helm/README.md#03-04-helm-charts)
      * [Start](./03-k8s-deploy/03-04-helm/README.md#start)
      * [Helm charts](./03-k8s-deploy/03-04-helm/README.md#helm-charts)
      * [Install the Helm CLI](./03-k8s-deploy/03-04-helm/README.md#install-the-helm-cli)
         * [Windows](./03-k8s-deploy/03-04-helm/README.md#windows)
         * [MacOS](./03-k8s-deploy/03-04-helm/README.md#macos)
      * [Installing a Helm chart from a public repository](./03-k8s-deploy/03-04-helm/README.md#installing-a-helm-chart-from-a-public-repository)
      * [Why use Helm charts?](./03-k8s-deploy/03-04-helm/README.md#why-use-helm-charts)
      * [What is in a Helm chart?](./03-k8s-deploy/03-04-helm/README.md#what-is-in-a-helm-chart)
      * [Search for a Helm chart in a private repository](./03-k8s-deploy/03-04-helm/README.md#search-for-a-helm-chart-in-a-private-repository)
      * [Run a Helm chart](./03-k8s-deploy/03-04-helm/README.md#run-a-helm-chart)
      * [Upgrade and rollback a Helm chart](./03-k8s-deploy/03-04-helm/README.md#upgrade-and-rollback-a-helm-chart)
      * [Cleanup](./03-k8s-deploy/03-04-helm/README.md#cleanup)

   * [03-05 Kustomize](./03-k8s-deploy/03-05-kustomize/README.md#03-05-kustomize)

   * [04-01 Metrics collection and visualisation](./04-observability/04-01-prometheus/README.md#04-01-metrics-collection-and-visualisation)
      * [Start](./04-observability/04-01-prometheus/README.md#start)
      * [Application instrumentation with Prometheus](./04-observability/04-01-prometheus/README.md#application-instrumentation-with-prometheus)
         * [Adding metrics to a NodeJS application](./04-observability/04-01-prometheus/README.md#adding-metrics-to-a-nodejs-application)
         * [Collecting application metrics with Prometheus in Kubernetes](./04-observability/04-01-prometheus/README.md#collecting-application-metrics-with-prometheus-in-kubernetes)
         * [Visualise metrics in the Prometheus expression browser](./04-observability/04-01-prometheus/README.md#visualise-metrics-in-the-prometheus-expression-browser)
         * [Grafana application dashboard](./04-observability/04-01-prometheus/README.md#grafana-application-dashboard)
         * [Resources](./04-observability/04-01-prometheus/README.md#resources)
      * [Cleanup](./04-observability/04-01-prometheus/README.md#cleanup)

   * [05-01 Azure Kubernetes Service (AKS) cluster](./05-k8s-azure/05-01-azure-aks/README.md#05-01-azure-kubernetes-service-aks-cluster)
      * [Start](./05-k8s-azure/05-01-azure-aks/README.md#start)
      * [Kubernetes context and kubeconfig file](./05-k8s-azure/05-01-azure-aks/README.md#kubernetes-context-and-kubeconfig-file)

   * [05-02 Azure Function Core Tools](./05-k8s-azure/05-02-azure-func/README.md#05-02-azure-function-core-tools)
      * [Start](./05-k8s-azure/05-02-azure-func/README.md#start)
      * [Cross platform development with func](./05-k8s-azure/05-02-azure-func/README.md#cross-platform-development-with-func)
      * [Cleanup](./05-k8s-azure/05-02-azure-func/README.md#cleanup)

   * [06-01 Feature toggling](./06-k8s-servicemesh/06-01-featuretoggles/README.md#06-01-feature-toggling)
      * [Exercise 1](./06-k8s-servicemesh/06-01-featuretoggles/README.md#exercise-1)
         * [Kiali](./06-k8s-servicemesh/06-01-featuretoggles/README.md#kiali)
      * [Exercise 2](./06-k8s-servicemesh/06-01-featuretoggles/README.md#exercise-2)
         * [Clean up](./06-k8s-servicemesh/06-01-featuretoggles/README.md#clean-up)

   * [06-02 Traffic Shifting](./06-k8s-servicemesh/06-02-trafficshifting/README.md#06-02-traffic-shifting)
      * [Exercise](./06-k8s-servicemesh/06-02-trafficshifting/README.md#exercise)
         * [Kiali](./06-k8s-servicemesh/06-02-trafficshifting/README.md#kiali)
         * [Clean up](./06-k8s-servicemesh/06-02-trafficshifting/README.md#clean-up)

   * [06-03 Fault Injection](./06-k8s-servicemesh/06-03-faultinjection/README.md#06-03-fault-injection)
      * [Setup](./06-k8s-servicemesh/06-03-faultinjection/README.md#setup)
   * [Exercise 1](./06-k8s-servicemesh/06-03-faultinjection/README.md#exercise-1)
      * [Injecting a HTTP delay fault](./06-k8s-servicemesh/06-03-faultinjection/README.md#injecting-a-http-delay-fault)
         * [Configure the rule](./06-k8s-servicemesh/06-03-faultinjection/README.md#configure-the-rule)
         * [Testing the delay configuration](./06-k8s-servicemesh/06-03-faultinjection/README.md#testing-the-delay-configuration)
         * [What happened?](./06-k8s-servicemesh/06-03-faultinjection/README.md#what-happened)
         * [Fixing the bug](./06-k8s-servicemesh/06-03-faultinjection/README.md#fixing-the-bug)
   * [Exercise 2](./06-k8s-servicemesh/06-03-faultinjection/README.md#exercise-2)
      * [Injecting a HTTP abort fault](./06-k8s-servicemesh/06-03-faultinjection/README.md#injecting-a-http-abort-fault)
         * [Configure the rule](./06-k8s-servicemesh/06-03-faultinjection/README.md#configure-the-rule-1)
         * [Testing the abort configuration](./06-k8s-servicemesh/06-03-faultinjection/README.md#testing-the-abort-configuration)
      * [Clean up](./06-k8s-servicemesh/06-03-faultinjection/README.md#clean-up)

   * [06-04 Canary Deployments with Flagger](./06-k8s-servicemesh/06-04-flaggercanary/README.md#06-04-canary-deployments-with-flagger)
      * [Setup](./06-k8s-servicemesh/06-04-flaggercanary/README.md#setup)
      * [Flagger Canary](./06-k8s-servicemesh/06-04-flaggercanary/README.md#flagger-canary)

   * [06-05 Observability](./06-k8s-servicemesh/06-05-observability/README.md#06-05-observability)
      * [Setup](./06-k8s-servicemesh/06-05-observability/README.md#setup)
      * [Prometheus](./06-k8s-servicemesh/06-05-observability/README.md#prometheus)
      * [Grafana](./06-k8s-servicemesh/06-05-observability/README.md#grafana)
      * [Jaeger](./06-k8s-servicemesh/06-05-observability/README.md#jaeger)
      * [With Kiali](./06-k8s-servicemesh/06-05-observability/README.md#with-kiali)
         * [Setup](./06-k8s-servicemesh/06-05-observability/README.md#setup-1)
         * [Understanding the Graph](./06-k8s-servicemesh/06-05-observability/README.md#understanding-the-graph)
         * [Workloads](./06-k8s-servicemesh/06-05-observability/README.md#workloads)
         * [Services](./06-k8s-servicemesh/06-05-observability/README.md#services)

   * [06-00-01 Service mesh features](./06-k8s-servicemesh/README.md#06-00-01-service-mesh-features)
      * [Getting started](./06-k8s-servicemesh/README.md#getting-started)

   * [06-00-02 Service Mesh Workshop](./06-k8s-servicemesh/workshop-README.md#06-00-02-service-mesh-workshop)
      * [Pre-Workshop Setup](./06-k8s-servicemesh/workshop-README.md#pre-workshop-setup)
         * [Creating the Cluster](./06-k8s-servicemesh/workshop-README.md#creating-the-cluster)
         * [Installing Istio](./06-k8s-servicemesh/workshop-README.md#installing-istio)
         * [Kiali](./06-k8s-servicemesh/workshop-README.md#kiali)
   * [Exercises](./06-k8s-servicemesh/workshop-README.md#exercises)
      * [Feature Toggles](./06-k8s-servicemesh/workshop-README.md#feature-toggles)
      * [Exercise 1.1](./06-k8s-servicemesh/workshop-README.md#exercise-11)
         * [Kiali](./06-k8s-servicemesh/workshop-README.md#kiali-1)
      * [Exercise 1.2](./06-k8s-servicemesh/workshop-README.md#exercise-12)
         * [Clean up](./06-k8s-servicemesh/workshop-README.md#clean-up)
      * [Traffic Shifting](./06-k8s-servicemesh/workshop-README.md#traffic-shifting)
      * [Exercise 2.1](./06-k8s-servicemesh/workshop-README.md#exercise-21)
      * [Exercise 2.2](./06-k8s-servicemesh/workshop-README.md#exercise-22)
      * [Exercise 2.3](./06-k8s-servicemesh/workshop-README.md#exercise-23)
         * [Clean up](./06-k8s-servicemesh/workshop-README.md#clean-up-1)
      * [Fault Injection](./06-k8s-servicemesh/workshop-README.md#fault-injection)
      * [Exercise 3.1](./06-k8s-servicemesh/workshop-README.md#exercise-31)
         * [Injecting a HTTP delay fault](./06-k8s-servicemesh/workshop-README.md#injecting-a-http-delay-fault)
         * [Configure the rule](./06-k8s-servicemesh/workshop-README.md#configure-the-rule)
         * [Testing the delay configuration](./06-k8s-servicemesh/workshop-README.md#testing-the-delay-configuration)
         * [What happened?](./06-k8s-servicemesh/workshop-README.md#what-happened)
         * [Fixing the bug](./06-k8s-servicemesh/workshop-README.md#fixing-the-bug)
   * [Exercise 3.2](./06-k8s-servicemesh/workshop-README.md#exercise-32)
      * [Injecting a HTTP abort fault](./06-k8s-servicemesh/workshop-README.md#injecting-a-http-abort-fault)
         * [Configure the rule](./06-k8s-servicemesh/workshop-README.md#configure-the-rule-1)
         * [Testing the abort configuration](./06-k8s-servicemesh/workshop-README.md#testing-the-abort-configuration)
         * [Clean up](./06-k8s-servicemesh/workshop-README.md#clean-up-2)
      * [Canary Deployments with Flagger](./06-k8s-servicemesh/workshop-README.md#canary-deployments-with-flagger)
      * [Setup](./06-k8s-servicemesh/workshop-README.md#setup)
      * [Flagger Canary](./06-k8s-servicemesh/workshop-README.md#flagger-canary)
   * [Final Cleanup](./06-k8s-servicemesh/workshop-README.md#final-cleanup)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)
