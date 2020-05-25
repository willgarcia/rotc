# Feature toggling

The examples are based on the Istio setup [guide](https://istio.io/docs/setup/getting-started/).

After following the setup guide, to view the Bookinfo app webpage, run the following command and paste the output into your browser.
```
echo http://$GATEWAY_URL/productpage
```

During the set up process, you deployed services for details, reviews and ratings, and deployments for reviews v1, v2 & v3. 

Run the following commands to see these:

```
kubectl get services

OUTPUT
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
details       ClusterIP   10.0.0.212      <none>        9080/TCP   29s
kubernetes    ClusterIP   10.0.0.1        <none>        443/TCP    25m
productpage   ClusterIP   10.0.0.57       <none>        9080/TCP   28s
ratings       ClusterIP   10.0.0.33       <none>        9080/TCP   29s
reviews       ClusterIP   10.0.0.28       <none>        9080/TCP   29s
```

```
kubectl get pods

OUTPUT
NAME                              READY   STATUS    RESTARTS   AGE
details-v1-78d78fbddf-tj56d       2/2     Running   1          20m30s
productpage-v1-85b9bf9cd7-zg7tr   1/2     Running   1          20m29s
ratings-v1-6c9dbf6b45-5djtx       2/2     Running   1          20m29s
reviews-v1-564b97f875-dzdt5       2/2     Running   1          20m30s
reviews-v2-568c7c9d8f-p5wrj       2/2     Running   1          20m29s
reviews-v3-67b4988599-7nhwz       2/2     Running   1          20m29s
```

* Istio uses the [VirtualService](https://istio.io/docs/reference/config/networking/virtual-service/) component to handle traffic management.
* A VirtualService defines a set of traffic routing rules to apply when a host is addressed. If the traffic is matched, then it is sent to a named destination service (or subset/version of it) defined in the registry.
* Traffic can be routed based on:
  * A URI 
  * Http Methods 
  * Headers 
  * Port 
  * Queryparmas

* We will use a [HTTPMatchRequest](https://istio.io/docs/reference/config/networking/virtual-service/#HTTPMatchRequest) to illustrate how we can route to specific service versions based on a defined set of rules.

## Exercise 1
The *simple-routing.yaml* file defines that all routes addressed to reviews will be directed to the version 1 subset:

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

Apply the file to route all traffic to version 1 of the reviews service:
```
kubectl apply -f exercise/simple-routing.yaml
```

Open the /productpage of the Bookinfo app in your browser. You will not see any stars next to the reviews as all traffic is routed to reviews:v1.

### Kiali
Set up Kiali to easily visualise traffic routes.  
Run 
```
istioctl dashboard kiali
```
and login with the default username *admin* and default password *admin*.

- In the left navigation menu, select Graph and in the Namespace drop down, select default.

- The Kiali dashboard shows an overview of your mesh with the relationships between the services in the Bookinfo sample application. It also provides filters to visualize the traffic flow.

- In the second dropdown from the left that reads 'No edge labels', select 'Requests percentage'.

- Reload the /productpage in the Bookinfo app a few times. Wait a few seconds and on the Kiali dashboard you will see that 100% of traffic is routed to reviews:v1.

## Exercise 2
The *rule-based-routing.yaml* file uses a [HTTPMatchRequest](https://istio.io/docs/reference/config/networking/virtual-service/#HTTPMatchRequest) to specify the route based on the user.

The productpage service extracts user information from the session and uses it to construct a custom header, 'end-user'. This header is then read by a match condition.

When a user logs in as jason, all routes addressed to reviews will be directed to version 2.  
For everyone else, the routes addressed to reviews will be directed to version 1.

```
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
    - reviews
  http:
  - match:
    - headers:
        end-user:
          exact: jason
    route:
    - destination:
        host: reviews
        subset: v2
  - route:
    - destination:
        host: reviews
        subset: v1
```
Apply the file to to route traffic based on the end user:

```
kubectl apply -f exercise/rule-based-routing.yaml
```

On the /productpage of the Bookinfo app, log in as user jason. 
- Refresh the browser.  
The star ratings will appear next to each review. You are seeing reviews:v2.

Now log in as another user (pick any name). 
- Refresh the browser.  
The star ratings are gone as traffic is routed to reviews:v1 for all users except jason.

### Clean up

```
kubectl delete -f exercise/simple-routing.yaml
kubectl delete -f exercise/rule-based-routing.yaml
```