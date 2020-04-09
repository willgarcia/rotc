# Docker

In this part we introduce our existing `dockercoins-webui` part of the DockerCoins services stack.

We will:

- Dockerise it by creating a Docker image for it
- publish it to an Azure ACR (Azure Container Registry)
- run our application web UI

You will learn about:

- Working with Docker from the command-line
- Building and tagging images
- Working with a private Docker registry
- Launching containers

## Start

In the start state, you are provided with the source code for the _dockercoins_ web frontend.

Run `cd exercise/` and follow the instructions below to get started!

## Building Docker Images

In this exercise you will build a Docker image for the _dockercoins_ service.

To create your own Docker image you will need to:

- Create a file called `Dockerfile` containing the build instructions
- Run the `docker build` command to execute the build instructions and generate the image

### Dockerfile

Search the official Docker Hub for a Docker image that comes with NodeJS pre-installed:

```console
docker search node
```

You can also browse Docker Hub at [hub.docker.com](https://hub.docker.com).

NOTE: the _docker search_ command currently only works with images in the public Docker Hub.

Create a file called `Dockerfile` and paste the following content:

```docker
FROM
RUN npm install express redis

COPY files/ /files/
COPY webui.js /

CMD ["node", "webui.js"]
EXPOSE 80
```

Notes about the _Dockerfile_ (refer to the [Dockerfile reference](https://docs.docker.com/reference/builder/)) for more details):

- `FROM` specifies the base image to build our image upon (_node:10.11.0-alpine_ contains the NodeJS runtime)
- `COPY` simply copies a file from the host file system to the image filesystem
- `EXPOSE` identifies the network ports the container will listen on
- `CMD` specifies the executable to run when a container is started from the image (we are using the _exec_ form)

You now have everything in place to build the Docker image:

```console
docker build -t dockercoins_webui .
```

The Docker build will fail for 2 different reasons :o

Look at the Dockerfile as well as your application files. Now, try to fix these 2 issues!

Once the image builds successfully, check that it appears in the list of Docker images present in your machine:

```console
docker images | grep dockercoins_webui
```

Success!

If you had a failed build along the way, you may also see an orphaned layer called `<none>` when running `docker images` (without grep).
There's no harm in it being there, but you can delete it by running `docker rmi <container-hash>`.

#### Note

- The build process is actually run by the Docker daemon and not the Docker CLI
- When we run `docker build`, the entire directory content where the `Dockerfile` is located (known as the "context") is sent to the daemon.
- If unnecessary files are present in the directory, use a `.dockerignore` file to ignore them. When large files are in the Docker context, builds can be slow, and any changed files in the context can invalidate Docker's build cache.
- If we create a new directory and only place the _Dockerfile_ and required files there, the build is quick and uses less system resources.

Docker images contain useful metadata which can be seen via the following command:

```console
docker inspect dockercoins_webui
```

Which ports will the _dockercoins_webui_ service be exposing?

```console
docker inspect -f '{{ .Config.ExposedPorts }}' dockercoins_webui
```

Finally, view the build history for the _dockercoins_webui_ image:

```console
docker history dockercoins_webui:latest
```

Here we can see that an image is made up of _layers_. Some layers take up disk space and some are just metadata layers. Read more about layers at [Understand images, containers, and storage drivers](https://docs.docker.com/storage/storagedriver/)

How do we run the newly created image so we can finally see the Web UI? We could now proceed to launch a container from these local images.

However, in any environment where you want to share images and run them on _different_ hosts (e.g. in production) you would normally publish them to a _registry_.

You have three main choices:

- The public [Docker Hub](https://hub.docker.com/) registry
- Run your own private [Docker registry](https://hub.docker.com/_/registry)
- Use an hosted Docker registry like [Azure ACR](https://azure.microsoft.com/en-au/services/container-registry/), [AWS ECR](https://aws.amazon.com/ecr/) or
  [GCP Container Registry](https://cloud.google.com/container-registry/)

## Tagging and Publishing a Docker Image

In this exercise you will publish your previously built Docker image to a private Azure Docker registry.

Publishing is done via the `docker push` command. However, if you were to use that right now Docker would attempt to push your images to the public Docker Hub (and could fail as you may be not logged in the Docker Hub).

### Tag the Docker images

To let Docker know you want to publish to our own registry, you need to _tag_ the image with the registry server location (_address:port_).
The Azure ACR registry created for this workshop is `k8straining.azurecr.io`

When tagging an image, a recommended practice is to add a version to the tag name.
From now on, we will use the **team name** as the version to tag all our Docker images.

Update the `TEAM_NAME` environment variable with your own team name in the following command and run it to tag the `dockercoins_webui` Docker image.

If you are using PowerShell on Windows:

```console
$env:TEAM_NAME="[team-name-placeholder]"
docker tag dockercoins_webui k8straining.azurecr.io/dockercoins_webui:$env:TEAM_NAME
```

If you are on MacOS:

```console
export TEAM_NAME="[team-name-placeholder]"
docker tag dockercoins_webui k8straining.azurecr.io/dockercoins_webui:${TEAM_NAME}
```

Check the image listing:

```console
docker images | grep dockercoins_webui
```

The expected output should be similar to this:

```output
# ==> Outputs:
dockercoins_webui                                                    latest               34d55f835d15        31 minutes ago      218MB
k8straining.azurecr.io/dockercoins_webui                              trainers             34d55f835d15        31 minutes ago      218MB
```

Note that tagging an image does not create a new image. It only creates another reference to the same image. This can be seen by the shared image IDs (3rd column in the console output).

### Publish the Docker image

To publish your first image to the private registry `k8straining.azurecr.io`, you will need to be authenticated in the right subscription and ACR registry:

```console
az login
az account set --subscription <subscription-id>
az acr login --name k8straining
```

Once you have passed the authentication, you can push the _dockercoins_webui_ Docker image

```console
# Windows only
docker push k8straining.azurecr.io/dockercoins_webui:$env:TEAM_NAME

# MacOS only
docker push k8straining.azurecr.io/dockercoins_webui:${TEAM_NAME}
```

_This may take some time..._

## Running Docker Containers

In this exercise, you create a running Docker container from your previously published Docker image.

### Remove local Docker images

Run the following commands to remove the local `dockercoins_webui` images (including tagged versions):

```console
docker rmi -f dockercoins_webui

# Windows only
docker rmi -f gcr.io/riseofthecontainerssydney/dockercoins_webui:$env:TEAM_NAME

# MacOS only
docker rmi -f gcr.io/riseofthecontainerssydney/dockercoins_webui:${TEAM_NAME}
```

This will prove that we are pulling our published images and not just using our already present local images.

### Start the `dockercoins_webui` service container

Before we execute our images, check to see if you have running containers:

```console
docker ps
```

You should not see any running containers yet.

To execute a container from a Docker image, you need to use the _docker run_ command. This will _fetch_ then _run_ the image. You can also fetch the image first using _docker pull_ then run it. Type _docker run --help_ to see available options.

Start the `dockercoins_webui` container with the following command:

```console
# Windows
docker run -d -p 3004:80 --name dockercoins_webui k8straining.azurecr.io/dockercoins_webui:$env:TEAM_NAME

# MacOS
docker run -d -p 3004:80 --name dockercoins_webui k8straining.azurecr.io/dockercoins_webui:${TEAM_NAME}
```

Open a browser to: <http://localhost/>

Review the options used with _docker run_:

- `-d` runs the container in the background (i.e. "detached").
- `-p XXXX:YYYY` maps a host port to the exposed container port so that the service can be accessed using the host address instead of the container's ephemeral address. Here `XXXX` is the host port and `YYYY` is the container port.
- `--name` is the container name - if we omit the name one will be generated for us (e.g. "admiring_euclid")
- The last argument, eg. `dockercoins_webui`, is the Docker image name (prefixed with our registry server address)

**Tip (optional)**: When launching multiple instances of the same image you would usually let Docker assign a random ephemeral port and a container name -- this avoids host port collisions and container name conflicts. Use the `-P` flag (capital _P_, without any port numbers) to let Docker assign an ephemeral port. Omit the `--name` parameter to let Docker assign a name for you

Check to see that the `dockercoins_webui` container is running:

```console
docker ps
```

View the port mapping (format is `[container_port] -> [host_ip]:[host_port]`):

```console
docker port dockercoins_webui
```

You can use `docker exec` to execute a process within a running container.

Take a peek at the running processes inside the `dockercoins_webui` container:

```console
docker exec dockercoins_webui ps -ef
```

```console
docker exec -ti dockercoins_webui bash -c "TERM=vt100 top -c"
```

...and (press `q` to exit)

**Note**: Containers can also be paused/unpaused, stopped/started, restarted, killed, removed, and more. _kill_ is more harsh than _stop_, where Docker gives the container a grace period (default 10s) to exit.

By looking at the UI, does the app work?

No, it seems to be broken :( :( :(

The logs might give us more info:

```console
docker logs --follow --tail=20 dockercoins_webui
```

```output
# ==> Output:
Redis error { [Error: Redis connection to redis:6379 failed - getaddrinfo ENOTFOUND redis redis:6379]
```

The problem is that the `dockercoins_webui` is configured to lookup the `redis` service by host name (`redis`) and port (`6379`) but there is no corresponding `redis` service running and no mechanism to do so yet.

We will use Docker Compose in part 2 to bring `redis` into our application stack!

## Cleanup

For now, ensure that the previous `dockercoins_webui` is stopped and removed.

```console
docker kill dockercoins_webui
docker rm dockercoins_webui
```
