# Docker

In this part we introduce our existing `twkoins-webui` part of the twkoins services stack.

We will:

- Dockerise it by creating a Docker image for it
- Publish it to a GCP Container Registry on Google Cloud
- Run our application's Web UI

You will learn about:

- Working with Docker from the command-line
- Building and tagging images
- Working with a private Docker registry
- Launching containers

## Start

In the start state, you are provided with the source code for the _twkoins_ web frontend.

Run `cd exercise/` and follow the instructions below to get started!

## Building Docker Images

In this exercise you will build a Docker image for the _twkoins_ service.

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
docker build -t twkoins_webui .
```

The Docker build will fail for 2 different reasons :o

Look at the Dockerfile as well as your application files. Now, try to fix these 2 issues!

Once the image builds successfully, check that it appears in the list of Docker images present in your machine:

```console
docker images | grep twkoins_webui
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
docker inspect twkoins_webui
```

Which ports will the _twkoins_webui_ service be exposing?

```console
docker inspect -f '{{ .Config.ExposedPorts }}' twkoins_webui
```

Finally, view the build history for the _twkoins_webui_ image:

```console
docker history twkoins_webui:latest
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

In this exercise you will publish your previously built Docker image to a public Docker Hub Container Registry registry.

Publishing is done via the `docker push` command. However, if you were to use that right now Docker would attempt to push your images to the public Docker Hub (and could fail as you may be not logged in the Docker Hub).

### Tag the Docker images

To let Docker know you want to publish to our own registry, you need to _tag_ the image with the registry server location (_address:port_).
The GCP registry created for this workshop is `rotcaus/dockerfundamentals`.

When tagging an image, a recommended practice is to add a version to the tag name.
From now on, we will use the **team name** as the version to tag all our Docker images.

Update the `TEAM_NAME` environment variable with your own team name in the following command and run it to tag the `twkoins_webui` Docker image.

If you are using PowerShell on Windows:

```console
$env:TEAM_NAME="[team-name-placeholder]"
docker tag twkoins_webui rotcaus/twkoins_webui:$env:TEAM_NAME
```

If you are on MacOS:

```console
export TEAM_NAME="joe"
docker tag twkoins_webui rotcaus/twkoins_webui:${TEAM_NAME}
```

Check the image listing:

```console
docker images | grep twkoins_webui
```

The expected output should be similar to this:

```output
# ==> Outputs:
twkoins_webui                                                    latest               34d55f835d15        31 minutes ago      218MB
rotcaus/twkoins_webui                trainers             34d55f835d15        31 minutes ago      218MB
```

Note that tagging an image does not create a new image. It only creates another reference to the same image. This can be seen by the shared image IDs (3rd column in the console output).

### Authenticate to the Docker Hub registry

Docker HUB

- Logout from your current user account:

  ```bash
  docker logout
  ```

- Use the rotcaus Docker account to login:

  ```bash
  # Ask for the password
  echo "[account-password]" | docker login --username rotcaus --password-stdin
  ```

GCP

If your push is denied, make sure you're logged in to GCP - run `gcloud auth login` and try again.

### Publish the Docker image

You can push the _twkoins_webui_ Docker image with the following commands:

```console
# Windows only
docker push rotcaus/twkoins_webui:$env:TEAM_NAME

# MacOS only
docker push rotcaus/twkoins_webui:${TEAM_NAME}
```

_This may take some time..._

## Next steps

[Exercise 02](EXERCISE-02.md)