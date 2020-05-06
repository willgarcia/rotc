# 01-03 Docker

## Running Docker Containers

In this exercise, you create a running Docker container from your previously published Docker image.

### Remove local Docker images

Run the following commands to remove the local `twkoins_webui` images (including tagged versions):

```console
docker rmi -f twkoins_webui

# Windows only
docker rmi -f rotcaus/twkoins_webui:$env:TEAM_NAME

# MacOS only
docker rmi -f rotcaus/twkoins_webui:${TEAM_NAME}
```

This will prove that we are pulling our published images and not just using our already present local images.

### Start the `twkoins_webui` service container

Before we execute our images, check to see if you have running containers:

```console
docker ps
```

You should not see any running containers yet.

To execute a container from a Docker image, you need to use the _docker run_ command. This will _fetch_ then _run_ the image. You can also fetch the image first using _docker pull_ then run it. Type _docker run --help_ to see available options.

Start the `twkoins_webui` container with the following command:

```console
# Windows
docker run -d -p 3004:80 --name twkoins_webui rotcaus/twkoins_webui:$env:TEAM_NAME

# MacOS
docker run -d -p 3004:80 --name twkoins_webui rotcaus/twkoins_webui:${TEAM_NAME}
```

Verify that the container is up and running:

```console
docker ps
```

Open a browser to: <http://localhost:3004/>

Review the options used with _docker run_:

- `-d` runs the container in the background (i.e. "detached").
- `-p XXXX:YYYY` maps a host port to the exposed container port so that the service can be accessed using the host address instead of the container's ephemeral address. Here `XXXX` is the host port and `YYYY` is the container port.
- `--name` is the container name - if we omit the name one will be generated for us (e.g. "admiring_euclid")
- The last argument, eg. `twkoins_webui`, is the Docker image name (prefixed with our registry server address)

**Tip (optional)**: When launching multiple instances of the same image you would usually let Docker assign a random ephemeral port and a container name -- this avoids host port collisions and container name conflicts. Use the `-P` flag (capital _P_, without any port numbers) to let Docker assign an ephemeral port. Omit the `--name` parameter to let Docker assign a name for you

View the port mapping (format is `[container_port] -> [host_ip]:[host_port]`):

```console
docker port twkoins_webui
```

You can use `docker exec` to execute a process within a running container.

Take a peek at the running processes inside the `twkoins_webui` container:

```console
docker exec twkoins_webui ps -ef
```

```console
docker exec -ti twkoins_webui sh -c "top -n 1"
```

**Note**: Containers can also be paused/unpaused, stopped/started, restarted, killed, removed, and more. _kill_ is more harsh than _stop_, where Docker gives the container a grace period (default 10s) to exit.

By looking at the UI, does the app work?

No, it seems to be broken :( :( :(

The logs might give us more info:

```console
docker logs --follow --tail=20 twkoins_webui
```

```output
# ==> Output:
Redis error { [Error: Redis connection to redis:6379 failed - getaddrinfo ENOTFOUND redis redis:6379]
```

The problem is that the `twkoins_webui` is configured to lookup the `redis` service by host name (`redis`) and port (`6379`) but there is no corresponding `redis` service running and no mechanism to do so yet.

We will use Docker Compose in part 2 to bring `redis` into our application stack!

## Cleanup

For now, ensure that the previous `twkoins_webui` is stopped and removed.

```console
docker kill twkoins_webui
docker rm twkoins_webui
```
