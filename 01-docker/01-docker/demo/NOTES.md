# Demo Notes

Save an image to a tar to demonstrate layers:

```shell
> cd tmp
> docker save nginx > nginx.tar
```

Build and tag:

```shell
> docker build -t basehtml .
```

Run the container:

```shell
> docker run -p 8080:80 basehtml
> docker run -P basehtml
```

Connect to the container and change something:

```shell
> docker ps
> docker exec -it <container> sh
> cd /usr/share/nginx/html/
> nano index.html
```

(include React to make it not so minimal: https://cdnjs.cloudflare.com/ajax/libs/react/16.9.0/umd/react.production.min.js)

Commit the change:

```shell
> docker stop <container>
> docker commit <container> basehtml
```

Kill the container and re-run to show it's saved

```shell
> docker run -p 8080:80 basehtml
```

Push to Docker hub:

```shell
> docker login
> docker tag basehtml sesh/basehtml:2019-08-22_1
> docker images
> docker push sesh/basehtml:2019-08-22_1
```

If time, try to push to Github or GCP registry.

Docker Compose: /Users/brenton/Dev/personal/bookmarks
