# 01-02 Docker

## Tagging and Publishing a Docker Image

In this exercise you will publish your previously built Docker image to a public Docker Hub Container Registry registry.

Publishing is done via the `docker push` command. However, if you were to use that right now Docker would attempt to push your images to the public Docker Hub (and could fail as you may be not logged in the Docker Hub).

### Tag the Docker images

To let Docker know you want to publish to our own registry, you need to _tag_ the image with the registry server location (_address:port_).
The Docker registry used for this workshop is `rotcaus/dockerfundamentals` (Docker Hub).

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

[Exercise 03](EXERCISE-03.md)
