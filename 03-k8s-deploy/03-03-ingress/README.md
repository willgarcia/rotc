# Ingress

You will learn about:

* exposing services with an nginx controller

Configuring an ingress controller can be useful in the following scenarios:

* expose a Kubernetes service on a specific path
* expose a Kubernetes service on a path and with a domain name
* expose different Kubernetes services behind the same domain name (`/v1/`, `/v2/`)

## Ingress rules

The ingress resource can expose Kubernetes services on defined hosts and path rules.

The cluster is pre-installed with an Ingress service and its external IP is now the only entrypoint to all app services.

Nginx Ingress defaults comes with a global ingress shared across all namespaces in the cluster. 

The external IP of the Ingress can be found with:

```console
kubectl get service nginx-ingress-controller -n nginx-ingress
```

If the nginx controller is installed successfully, the external IP should respond 200 on `/healthz` and 404 on `/`.

### Nginx ingress controller, path-based routing

Run the following command:

```console
kubectl apply -f ingress-v0-path.yaml
```

The ingress definition `ingress-v0-path.yaml` has an annotation `kubernetes.io/ingress.class: nginx` that defines which ingress controller is used.

When using a GCP Load Balancer that acts as ingress, this value would be `gce` instead of `nginx`.

The service should be accessible on the ingress external IP at `http://[ingress-ip]/coins/index.html`

### Nginx ingress controller, using a domain name

Run the following command which will update the previous route-based version of the ingress:

```console
kubectl apply -f ingress-v1-domain.yaml
```

The ingress definition has a `host` which is mapped to a domain name.

The hosted zone of this domain includes a DNS A record on `dockercoins-v1.wigarcia.com` with the ingress IP as its value.

As a consequence, the DNS resolution of <http://dockercoins-v1.wigarcia.com> works and through the ingress resource, the dockercoins service can also now be reached.

### Nginx ingress controller, one domain name, two services

Run the following command:

```console
kubectl apply -f ingress-v1-v2.yaml
```

With the presence of 2 backends in the list of HTTP paths:

* the service `simpleapp` is available at <http://dockercoins.wigarcia.com/v1>
* the service `dockercoins` is available at <http://dockercoins.wigarcia.com/v2/index.html>

The 2 services are unrelated and run in separate pods. In a real world scenarion, this could be used to expose:

* different versions of the same service under the same domain (`/v1`, `/v2`, etc)
* different products with a path prefix (`/product1`, `/product2`, etc)

Links:

* [Kubernetes Ingress with Nginx Example](https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-ingress-guide-nginx-example.html)
* [NGINX Ingress Controller rewrite](https://kubernetes.github.io/ingress-nginx/examples/rewrite/)
