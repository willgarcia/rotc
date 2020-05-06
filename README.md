# Kubernetes

## Structure
* `exercise/`: exercise - attendees
* `solution/`: exercise's solution, solution scripts - attendees
* `.build/`: instruction / build scripts - trainers only
* `demo/`: demos - trainers only

## References

* `docker` CLI reference: <https://docs.docker.com/engine/reference/commandline/docker/>
* `docker-compose` CLI reference: <https://docs.docker.com/compose/reference/>
* `kubectl` CLI reference: <https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#expose> 
* `kubectl` Cheat sheet: <https://kubernetes.io/docs/reference/kubectl/cheatsheet/>

Sample app from Jérôme Petazzoni - code under [Apache License 2.0](https://github.com/jpetazzo/container.training/blob/master/LICENSE)

## Table of contents

   * [01-01 Docker](./01-docker/01-docker/EXERCISE-01.md#01-01-docker)
      * [Start](./01-docker/01-docker/EXERCISE-01.md#start)
      * [Building Docker Images](./01-docker/01-docker/EXERCISE-01.md#building-docker-images)
         * [Dockerfile](./01-docker/01-docker/EXERCISE-01.md#dockerfile)
            * [Note](./01-docker/01-docker/EXERCISE-01.md#note)
      * [Next steps](./01-docker/01-docker/EXERCISE-01.md#next-steps)

   * [01-02 Docker](./01-docker/01-docker/EXERCISE-02.md#01-02-docker)
      * [Tagging and Publishing a Docker Image](./01-docker/01-docker/EXERCISE-02.md#tagging-and-publishing-a-docker-image)
         * [Tag the Docker images](./01-docker/01-docker/EXERCISE-02.md#tag-the-docker-images)
         * [Authenticate to the Docker Hub registry](./01-docker/01-docker/EXERCISE-02.md#authenticate-to-the-docker-hub-registry)
         * [Publish the Docker image](./01-docker/01-docker/EXERCISE-02.md#publish-the-docker-image)
      * [Next steps](./01-docker/01-docker/EXERCISE-02.md#next-steps)

   * [01-03 Docker](./01-docker/01-docker/EXERCISE-03.md#01-03-docker)
      * [Running Docker Containers](./01-docker/01-docker/EXERCISE-03.md#running-docker-containers)
         * [Remove local Docker images](./01-docker/01-docker/EXERCISE-03.md#remove-local-docker-images)
         * [Start the twkoins_webui service container](./01-docker/01-docker/EXERCISE-03.md#start-the-twkoins_webui-service-container)
      * [Cleanup](./01-docker/01-docker/EXERCISE-03.md#cleanup)

   * [Demo Notes](./01-docker/01-docker/demo/NOTES.md#demo-notes)

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

   * [02-05 Kubernetes Deployment and Service](./02-k8s/02-05-deployment-svc/README.md#02-05-kubernetes-deployment-and-service)
      * [Create a deployment](./02-k8s/02-05-deployment-svc/README.md#create-a-deployment)
      * [External access to the pod - how to create a basic service](./02-k8s/02-05-deployment-svc/README.md#external-access-to-the-pod---how-to-create-a-basic-service)

   * [03-01 Kubernetes ConfigMaps](./03-k8s-deploy/03-01-configs/README.md#03-01-kubernetes-configmaps)
      * [Start](./03-k8s-deploy/03-01-configs/README.md#start)
         * [ConfigMaps](./03-k8s-deploy/03-01-configs/README.md#configmaps)
      * [Cleanup](./03-k8s-deploy/03-01-configs/README.md#cleanup)

   * [03-02 Kubernetes Secrets](./03-k8s-deploy/03-02-secrets/README.md#03-02-kubernetes-secrets)
      * [Start](./03-k8s-deploy/03-02-secrets/README.md#start)
         * [Secret maps](./03-k8s-deploy/03-02-secrets/README.md#secret-maps)
      * [Cleanup](./03-k8s-deploy/03-02-secrets/README.md#cleanup)

   * [03-03 Helm charts](./03-k8s-deploy/03-03-helm/README.md#03-03-helm-charts)
      * [Start](./03-k8s-deploy/03-03-helm/README.md#start)
      * [Helm charts](./03-k8s-deploy/03-03-helm/README.md#helm-charts)
      * [Installing a Helm chart from a public repository](./03-k8s-deploy/03-03-helm/README.md#installing-a-helm-chart-from-a-public-repository)
      * [Why use Helm charts?](./03-k8s-deploy/03-03-helm/README.md#why-use-helm-charts)
      * [What is in a Helm chart?](./03-k8s-deploy/03-03-helm/README.md#what-is-in-a-helm-chart)
      * [Search for a Helm chart in a private repository](./03-k8s-deploy/03-03-helm/README.md#search-for-a-helm-chart-in-a-private-repository)
      * [Run a Helm chart](./03-k8s-deploy/03-03-helm/README.md#run-a-helm-chart)
      * [Upgrade and rollback a Helm chart](./03-k8s-deploy/03-03-helm/README.md#upgrade-and-rollback-a-helm-chart)
      * [Cleanup](./03-k8s-deploy/03-03-helm/README.md#cleanup)

   * [Demo - Helm chart releases in Kubernetes](./03-k8s-deploy/03-03-helm/demo/README.md#demo---helm-chart-releases-in-kubernetes)
      * [Package and publish a Helm chart](./03-k8s-deploy/03-03-helm/demo/README.md#package-and-publish-a-helm-chart)

   * [Metabase](./03-k8s-deploy/03-03-helm/solution/metabase/README.md#metabase)
      * [TL;DR;](./03-k8s-deploy/03-03-helm/solution/metabase/README.md#tldr)
      * [Introduction](./03-k8s-deploy/03-03-helm/solution/metabase/README.md#introduction)
      * [Prerequisites](./03-k8s-deploy/03-03-helm/solution/metabase/README.md#prerequisites)
      * [Installing the Chart](./03-k8s-deploy/03-03-helm/solution/metabase/README.md#installing-the-chart)
      * [Uninstalling the Chart](./03-k8s-deploy/03-03-helm/solution/metabase/README.md#uninstalling-the-chart)
      * [Configuration](./03-k8s-deploy/03-03-helm/solution/metabase/README.md#configuration)

   * [04-01 Azure Kubernetes Service (AKS) cluster](./04-k8s-azure/04-01-azure-aks/README.md#04-01-azure-kubernetes-service-aks-cluster)
      * [Start](./04-k8s-azure/04-01-azure-aks/README.md#start)
      * [Kubernetes context and kubeconfig file](./04-k8s-azure/04-01-azure-aks/README.md#kubernetes-context-and-kubeconfig-file)

   * [04-02 Azure Function Core Tools](./04-k8s-azure/04-02-azure-func/README.md#04-02-azure-function-core-tools)
      * [Start](./04-k8s-azure/04-02-azure-func/README.md#start)
      * [Cross platform development with func](./04-k8s-azure/04-02-azure-func/README.md#cross-platform-development-with-func)
      * [Cleanup](./04-k8s-azure/04-02-azure-func/README.md#cleanup)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)
