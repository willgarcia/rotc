# Feature toggling

The examples are based on the istio setup guide.

Istio [VirtualService](https://istio.io/docs/reference/config/networking/virtual-service/)
Routes requests and can be used to implement feature toggling.

## Exercise 1

Using [HTTPMatchRequest](https://istio.io/docs/reference/config/networking/virtual-service/#HTTPMatchRequest). 
* Extract user information from the session and use it to construct a custom header.
* HTTPMatchRequest then forwards the request to the appropriate Reviews service version based on the rule:
```
    route:
    - destination:
        host: reviews
        subset: v2
```
### Implement

```
kubectl apply -f exercise/request-header.yaml
```

## Exercise 2

Using [DestinationRule](https://istio.io/docs/reference/config/networking/destination-rule/)


### Implement

```
kubectl apply -f exercise/destination-rule.yaml
```

View the webpage

### Clean up

```
kubectl delete -f exercise/request-header.yaml
```

```
kubectl delete -f exercise/destination-rule.yaml
```