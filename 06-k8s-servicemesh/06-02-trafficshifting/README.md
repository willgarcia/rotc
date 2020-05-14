# Traffic Shifting

Traffic shifting is used to migrate traffic from one service version to another. Istio achieves this by using the VirtualService resource to configure rules to route a percentage of traffic to a service.

Istio uses [HTTPRouteDestination](https://istio.io/docs/reference/config/networking/virtual-service/#HTTPRouteDestination) to route traffic. You specify a destination host and weight attribute. The [destination](https://istio.io/docs/reference/config/networking/virtual-service/#Destination) is a network addressable service in the service registry. The weight is the percentage of traffic. 

```
- destination:
    host: reviews
    subset: v1
  weight: 5
- destination:
    host: reviews
    subset: v3
  weight: 95
```

## Exercise 

1. Route all traffic to version 1 of the microservice.

```
kubectl apply -f exercise/traffic-shifting-v1.yaml
```
Open the BookInfo site in the browser.

Notice that the reviews part of the page displays with no rating stars, no matter how many times you refresh. This is because you configured Istio to route all traffic for the reviews service to the version reviews:v1 and this version of the service does not access the star ratings service.

2. Transfer 50% of the traffic from reviews:v1 to reviews:v3 with the following command:

```
kubectl apply -f exercise/traffic-shifting-50-v3.yaml
```

Refresh the /productpage in your browser and you now see red colored star ratings approximately 50% of the time. This is because the v3 version of reviews accesses the star ratings service, but the v1 version does not.

3. Transfer 100% of the traffic to version 3.

```
kubectl apply -f exercise/traffic-shifting-v3.yaml
```

Now when you refresh the /productpage you will always see book reviews with red colored star ratings for each review.

### Clean up

```
kubectl delete -f exercise/traffic-shifting-v1.yaml
kubectl delete -f exercise/traffic-shifting-50-v3.yaml
kubectl delete -f exercise/traffic-shifting-v3.yaml
```