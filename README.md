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

## Table of contents

- [Docker](01-01-docker/README.md#docker)
  * [Start](01-01-docker/README.md#start)
  * [Building Docker Images](01-01-docker/README.md#building-docker-images)
    + [Dockerfile](01-01-docker/README.md#dockerfile)
  * [Tagging and Publishing a Docker Image](01-01-docker/README.md#tagging-and-publishing-a-docker-image)
    + [Tag the Docker images](01-01-docker/README.md#tag-the-docker-images)
    + [Publish the Docker image](01-01-docker/README.md#publish-the-docker-image)
  * [Running Docker Containers](01-01-docker/README.md#running-docker-containers)
    + [Remove local Docker images](01-01-docker/README.md#remove-local-docker-images)
    + [Start the `twkoins_webui` service container](01-01-docker/README.md#start-the-twkoins_webui-service-container)
  * [Cleanup](01-01-docker/README.md#cleanup)

- [Docker Compose](01-02-compose/README.md#docker-compose)
  * [Start](01-02-compose/README.md#start)
  * [Create a Compose YAML file](01-02-compose/README.md#create-a-compose-yaml-file)
  * [Container DNS names](01-02-compose/README.md#container-dns-names)
  * [Scaling our app](01-02-compose/README.md#scaling-our-app)
  * [Docker Compose Limitations](01-02-compose/README.md#docker-compose-limitations)
  * [Cleanup](01-02-compose/README.md#cleanup)
