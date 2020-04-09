# Docker Compose

## Start

In the start state, you are provided with the source code for the _twkoins_ web frontend and all its backend components including `redis`.

You will use **Docker Compose** to define and spin up an entire application stack declaratively.

Run `cd exercise/` and follow the instructions below to get started.

## Create a Compose file

Docker Compose requires that you define an application stack in a YAML file (usually called `docker-compose.yml`)

Create a `docker-compose.yml` file and paste the following contents into the file (`docker-compose.yml`):

```yaml
version: "3"

services:
  rng:
    build: rng
    ports:
    - "8001:3001"

  hasher:
    build: hasher
    ports:
    - "8002:3000"

  webui:
    build: webui
    ports:
    - "8000:80"
    volumes:
    - "./webui/files/:/files/"

  redis:
    image: redis

  worker:
    build: worker
```

Here we have defined our containers and the images they should use.

In Compose v2+, a service is defined by attributes. In this example:

* `build` specifies the location of the Dockerfile that needs to get built for this service
* `depends_on` declares which other services need to exist for the current service to run
* `ports` specifies a list of host/port pairs. The host port exposes the service, opening its access from your host machine.
* `volumes`. During development, new files can be added to the volume directory and shared between the host (your machine) and the Docker running container. This avoids to repeatedly re-build the Docker image when updating files.

See [Docker Compose v3](https://docs.docker.com/compose/compose-file/) for information on the format and supported attributes.

At run time, Docker will share the Web UI files with a volume pointing `./webui/files`) from your host machine to `/files` inside the Web UI container. This is described in the compose file with:

```yaml
volumes:
- "./webui/files/:/files/"
```

Launch the stack in the background:

```console
docker-compose up -d --build
```

Verify that the app is working correctly: <http://localhost:8000>

Verify that all the services defined in the Docker Compose file are running:

```console
docker-compose ps
```

The expected output is similar to this:

```output
      Name                     Command               State          Ports
---------------------------------------------------------------------------------
twkoins_hasher_1   ruby hasher.rb                   Up      0.0.0.0:8002->80/tcp
twkoins_redis_1    docker-entrypoint.sh redis ...   Up      6379/tcp
twkoins_rng_1      python rng.py                    Up      0.0.0.0:8001->80/tcp
twkoins_webui_1    node webui.js                    Up      0.0.0.0:8000->80/tcp
twkoins_worker_1   python worker.py                 Up
```

View the logs:

```console
docker-compose logs -f
```

Look for the HTML tag `<h1>` in this file `webui/files/index.html` and change the title to `twkoins Miner`.

Refresh the page at [http://localhost:8000](http://localhost:8000). The change is immediate as we use a Docker volume between your host and the container.

Volumes are useful:

* to keep data written by the container onto the host machine (typically generated application files, logs, database files)
* to enable development workflows where everything runs in a close-to-production environment inside Docker, without a need for installing utilities (and the "right versions") on your developer machine

**Note**: As you have probably noticed, the commands and options provided by the Docker Compose CLI are very similar to the ones provided by the Docker CLI. You have almost learnt how to use Compose if you already know how to use the Docker CLI!

## Container DNS names

Looking at the code of the Web UI (`webui.js`), you'll notice we did not use any IP or FQDN to reference the `redis` service. So how does each service know about each other?

The name `redis` itself is enough to resolve the newly created Redis service. Compose manages network aliases to make each service reachable by its own name. This is possible because Docker Compose configures DNS aliases in Docker.

When requesting the host name `redis` from the `webui` service, the DNS automatically and successfully resolves `redis`! This can be observed by running:

```console
docker-compose exec webui ping redis
```

## Scaling our app

Docker Compose's `scale` command lets you scale up/down the number of container instances per service.

The mining speed currently maxes out at ~4 hashes per second.

Increase the number of instances of the `worker` service from 1 to 10 to increase the mining speed:

```console
docker-compose up -d --scale worker=10
```

List all the containers to confirm that 10 instances have been created:

```console
docker ps
```

## Docker Compose Limitations

Docker Compose is useful for simple orchestration of application stacks and now supports multi-host deployments.

It is generally used for local development or in CI pipelines for testing purposes.

It might not be your first choice if:

* You need to perform orchestration steps other than just starting Docker containers
* You need to wait or poll for events during orchestration
* You want to manage your containers differently, e.g. using the **systemd** init system to run a container as a background service
* You want to ensure a desired state is maintained

## Cleanup

Kill the containers and remove them:

```console
docker-compose down
```
