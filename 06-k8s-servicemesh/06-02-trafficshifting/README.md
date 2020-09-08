# 06-02 Traffic Shifting
The examples are based on the Istio setup [guide](https://istio.io/docs/setup/getting-started/).

After following the setup guide, to view the Bookinfo app webpage, run the following command and paste the output into your browser.
```
echo http://$GATEWAY_URL/productpage
```

Traffic shifting is used to migrate traffic from one service version to another. Istio achieves this by using the VirtualService resource to configure rules to route a percentage of traffic to a service.

Istio uses [HTTPRouteDestination](https://istio.io/docs/reference/config/networking/virtual-service/#HTTPRouteDestination) to route traffic. You specify a destination host and weight attribute. The [destination](https://istio.io/docs/reference/config/networking/virtual-service/#Destination) is a network addressable service in the service registry. The weight is the percentage of traffic. 

```
- destination:
    host: reviews
    subset: v1
  weight: 50
- destination:
    host: reviews
    subset: v3
  weight: 50
```

## Exercise 

### Kiali
Before starting, set up Kiali to easily visualise traffic routes. Ignore this if you already set up Kiali in 06-01-featuretoggles.

Run 
```
istioctl dashboard kiali
```
and login with the default username *admin* and default password *admin*.

- In the left navigation menu, select Graph and in the Namespace drop down, select default.

- The Kiali dashboard shows an overview of your mesh with the relationships between the services in the Bookinfo sample application. It also provides filters to visualize the traffic flow.

- In the second dropdown from the left that reads 'No edge labels', select 'Requests percentage'.

<br>

1. The *traffic-shifting-v1.yaml* file will route all traffic to reviews:v1:
```
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
  - reviews
  http:
  - route:
    - destination:
        host: reviews
        subset: v1
```
Apply the file:
```
kubectl apply -f exercise/traffic-shifting-v1.yaml
```
- Open the BookInfo site in the browser.  
Notice that the reviews part of the page displays with no rating stars, no matter how many times you refresh. This is because you configured Istio to route all traffic for the reviews service to reviews:v1 and this version of the service does not access the star ratings service.

- Open the Kiali dashboard.
Refresh the Bookinfo app a few times. After a few seconds, you will see that 100% of traffic is routed to reviews:v1.

2. The *traffic-shifting-50-v3.yaml* file will transfer 50% of the traffic from reviews:v1 to reviews:v3:

```
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
    - reviews
  http:
  - route:
    - destination:
        host: reviews
        subset: v1
      weight: 50
    - destination:
        host: reviews
        subset: v3
      weight: 50
```
Apply the file:
```
kubectl apply -f exercise/traffic-shifting-50-v3.yaml
```

- Refresh the /productpage in your browser.  
 You can now see red colored star ratings approximately 50% of the time. This is because the reviews:v3 accesses the star ratings service, but the reviews:v1 does not.

- Open the Kiali dashboard.  
Refresh the Bookinfo app a few times. After a few seconds, you will see that approximately 50% of traffic is routed to reviews:v1 and reviews:v3.

3. The *traffic-shifting-v3.yaml* file will route 100% of the traffic to reviews:v3:
```
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
    - reviews
  http:
  - route:
    - destination:
        host: reviews
        subset: v3
```
Apply the file:
```
kubectl apply -f exercise/traffic-shifting-v3.yaml
```

- Now when you refresh the /productpage you will always see book reviews with red colored star ratings for each review.

- Open the Kiali dashboard.  
Refresh the Bookinfo app a few times. After a few seconds, you will see that 100% of traffic is routed to reviews:v3.

### Clean up

```
kubectl delete -f exercise/traffic-shifting-v1.yaml
kubectl delete -f exercise/traffic-shifting-50-v3.yaml
kubectl delete -f exercise/traffic-shifting-v3.yaml
```
