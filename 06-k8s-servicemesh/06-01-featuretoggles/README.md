# Feature toggling

The examples are based on the istio setup guide.

* Istio uses the [VirtualService](https://istio.io/docs/reference/config/networking/virtual-service/) component to handle traffic management.
* Routing rules can be defined in a [VirtualService](https://istio.io/docs/reference/config/networking/virtual-service/). A routing rule contains a [Match condition](https://istio.io/docs/reference/config/networking/virtual-service/#HTTPMatchRequest) and an action
* Traffic can be routed based on:
  * A URI 
  * Http Methods 
  * Headers 
  * Port 
  * Queryparmas



* We will use a [Match condition](https://istio.io/docs/reference/config/networking/virtual-service/#HTTPMatchRequest) to illustrate how we can route to specific service versions based on a defined set of rules.

## Exercise 1
We will route all traffic to version 1 of the reviews service

```
kubectl apply -f exercise/simple-routing.yaml
```

## Exercise 2
In this example will route traffic based on a rule defined in a
[HTTPMatchRequest](https://istio.io/docs/reference/config/networking/virtual-service/#HTTPMatchRequest). 
* The productpage service extracts user information from the session and use it to construct a custom header, 'end-user'. This header is then read by a match condition.

```
- match:
   - headers:
       end-user:
         exact: version-2-user
```

* The request is then routed to the appropriate Reviews service version based on the rule:
```
    route:
    - destination:
        host: reviews
        subset: v2
```
### Implement

```
kubectl apply -f exercise/rule-based-routing.yaml
```


View the webpage

### Clean up

```
kubectl delete -f exercise/simple-routing.yaml
kubectl delete -f exercise/rule-based-routing.yaml
```