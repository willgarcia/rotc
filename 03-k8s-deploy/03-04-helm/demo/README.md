# Demo - Helm chart releases in Kubernetes

## Package and publish a Helm chart

Download the `DockerCoins` chart:

```console
helm fetch rotcaus/dockercoins
cd dockercoins
```

Apply modification to the YAML definitions as required (example: change default value of webui image to `v2`), bump the version of the Chart and package a new version:

```console
helm package ./dockercoins
```

Push the new version to the chart repository:

```console
az acr helm push dockercoins-0.2.0.tgz
```
