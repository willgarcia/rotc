# 06-00-02 Service Mesh Workshop

Welcome to the Service Mesh Workshop as developed by a large team of dedicated Thoughtworkers. This workshop will run through a series of exercises intended to explore different concepts through the prism of a Service Mesh. Below is a list of the topics covered in the exercises:

 - Feature Toggles
 - Traffic Shifting
 - Fault Injection
 - Canary deployment with Flagger


As they say, the best thing to do is to just get on with it.
So, let's get started!


## Pre-Workshop Setup

Make sure that you have your free account setup in Azure. You can create one here https://azure.microsoft.com/en-au/

Clone the repo

`git clone git@github.com:willgarcia/rotc.git && cd rotc`

We are going to need some enviroment variables setup for our Azure resources. Replace the `<yourname>` with your actual name when you export the variables.

`export AZURE_PREFIX=<yourname>`

`export AZURE_TF_STORAGE_ACCOUNT=<yourname>stgterra1`

Make sure the volume bar on your laptop is halfway

* Run `./.build/scripts/workshop/workshop-setup.sh ` and let Stevie guide you through your installation!

 - if you end up in a shell with `bash-5.0#` in your terminal you've made it! Press `ctrl d` to get out of the container.

 - Run `killall afplay` if your installation is prompt and you've had enough of Stevie. Otherwise the process will end once he's finished.

### Creating the Cluster

We will be using Batect to run our builds. Batect is a really useful tool created by Thoughtworker Charles Korn. We are using Batect to build our containers that will run these processes. You can find more at https://github.com/batect/batect

The first time you use Batect it will download the binaries in order to run it. Similarly, the first time we run our containers they will need to be built and therefore take a tiny bit of time

* Change into the build directory

`cd .build`

* Run `./batect -f azure.yml login_azure` to set up the Azure credentials.

* Run `./batect -f azure.yml setup-azure-backend` to create a resource group, storage account and storage container to house our Terraform state file.

* Check your Azure portal to see if your resources have been created.

* Run `./batect -f azure.yml setup-terraform` to get your terraform environment ready.  This will connect to the storage account and container.

* Run `./batect -f azure.yml plan-terraform` to check to see the resources that will be provisioned

* Run `./batect -f azure.yml apply-terraform` to setup the cluster


### Installing Istio
* Run `./batect -f azure.yml install-istio` to install Istio and deploy the Bookinfo Application

  * n.b. If you are asked to override your kubeconfig file, press `y` and enter 
  
  * If no Ip address appears at the end of the istio install, type this commmand in your terminal:
    `kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}`
    
  * Then make your way to `<yourIPAddress>/productpage` 

### Kiali

Kiali is a management console for Istio based Service Mesh.

Set up Kiali to easily visualise traffic routes.  

Run 
```
`./batect -f azure.yml kiali`
```
and login with the default username *admin* and default password *admin*.

- In the left navigation menu, select Graph and in the Namespace drop down, select default.

- The Kiali dashboard shows an overview of your mesh with the relationships between the services in the Bookinfo sample application. It also provides filters to visualize the traffic flow.


<br>

# Exercises

n.b. *Make sure you are in the `06-k8s-servicemesh` folder*

## Feature Toggles

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
  * Query params

* We will use a [HTTPMatchRequest](https://istio.io/docs/reference/config/networking/virtual-service/#HTTPMatchRequest) to illustrate how we can route to specific service versions based on a defined set of rules.

## Exercise 1.1
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
kubectl apply -f 06-01-featuretoggles/exercise/simple-routing.yaml
```

Open the /productpage of the Bookinfo app in your browser. You will not see any stars next to the reviews as all traffic is routed to reviews:v1.


### Kiali

- In the second dropdown from the left that reads 'No edge labels', select 'Requests percentage'.

- Reload the /productpage in the Bookinfo app a few times. Wait a few seconds and on the Kiali dashboard you will see that 100% of traffic is routed to reviews:v1.

## Exercise 1.2
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
kubectl apply -f 06-01-featuretoggles/exercise/rule-based-routing.yaml
```

On the /productpage of the Bookinfo app, log in as user jason. 
- Refresh the browser.  
The star ratings will appear next to each review. You are seeing reviews:v2.

Now log in as another user (pick any name). 
- Refresh the browser.  
The star ratings are gone as traffic is routed to reviews:v1 for all users except jason.

### Clean up

```
kubectl delete -f 06-01-featuretoggles/exercise/simple-routing.yaml
kubectl delete -f 06-01-featuretoggles/exercise/rule-based-routing.yaml
```
<br>

## Traffic Shifting

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

## Exercise 2.1


The *traffic-shifting-v1.yaml* file will route all traffic to reviews:v1:
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
kubectl apply -f 06-02-trafficshifting/exercise/traffic-shifting-v1.yaml
```
- Open the BookInfo site in the browser.  
Notice that the reviews part of the page displays with no rating stars, no matter how many times you refresh. This is because you configured Istio to route all traffic for the reviews service to reviews:v1 and this version of the service does not access the star ratings service.

- Open the Kiali dashboard.
Refresh the Bookinfo app a few times. After a few seconds, you will see that 100% of traffic is routed to reviews:v1.

## Exercise 2.2

The *traffic-shifting-50-v3.yaml* file will transfer 50% of the traffic from reviews:v1 to reviews:v3:

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
kubectl apply -f 06-02-trafficshifting/exercise/traffic-shifting-50-v3.yaml
```

- Refresh the /productpage in your browser.  
 You can now see red colored star ratings approximately 50% of the time. This is because the reviews:v3 accesses the star ratings service, but the reviews:v1 does not.

- Open the Kiali dashboard.  
Refresh the Bookinfo app a few times. After a few seconds, you will see that approximately 50% of traffic is routed to reviews:v1 and reviews:v3.


## Exercise 2.3

The *traffic-shifting-v3.yaml* file will route 100% of the traffic to reviews:v3:
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
kubectl apply -f 06-02-trafficshifting/exercise/traffic-shifting-v3.yaml
```

- Now when you refresh the /productpage you will always see book reviews with red colored star ratings for each review.

- Open the Kiali dashboard.  
Refresh the Bookinfo app a few times. After a few seconds, you will see that 100% of traffic is routed to reviews:v3.

### Clean up

```
kubectl delete -f 06-02-trafficshifting/exercise/traffic-shifting-v1.yaml
kubectl delete -f 06-02-trafficshifting/exercise/traffic-shifting-50-v3.yaml
kubectl delete -f 06-02-trafficshifting/exercise/traffic-shifting-v3.yaml
```

<br>

## Fault Injection

Fault injection is a testing method where failures are intentionally introduced into a system to test its resiliency and measure recovery times in various scenarios.

Failures are inevitable, and for critical systems it is important to investigate any method which could help reduce the impact of a failure. 

However, some systems are so critical that any down time to test resiliency is out of the question. Service mesh can allow for fault injection testing while minimising the impact on users.

Istio lets you inject faults at the application layer. You can inject two types of faults, both configured using a virtual service:

* Delays: Timing failures that mimic increased network latency or an overloaded upstream service.

* Aborts: Crash failures that mimic failures in upstream services. Aborts usually manifest in the form of HTTP error codes or TCP connection failures.

E.g. this virtual service introduces a 5 second delay for 1 out of every 1000 requests to the ratings service.

```
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ratings
spec:
  hosts:
  - ratings
  http:
  - fault:
      delay:
        percentage:
          value: 0.1
        fixedDelay: 5s
    route:
    - destination:
        host: ratings
        subset: v1

```

Apply application version routing with the following commands:
```
kubectl apply -f 06-03-faultinjection/exercise/virtual-service-all-v1.yaml
kubectl apply -f 06-03-faultinjection/exercise/virtual-service-reviews-test-v2.yaml
```
With this configuration, the request flow looks like:

* productpage &#8594; reviews:v2  &#8594; ratings (for user jason)
* productpage  &#8594; reviews:v1 (for everyone else)

## Exercise 3.1

### Injecting a HTTP delay fault
To test the Istio Bookinfo application microservices for resiliency, inject a 7 second delay between reviews:v2 and ratings microservices for the user 'jason'.

### Configure the rule
1. Create a fault injection rule to delay traffic coming from the test user jason.
```
fault:
  delay:
    percentage:
      value: 100.0
    fixedDelay: 7s
```
Apply the rule:
```
kubectl apply -f 06-03-faultinjection/exercise/ratings-test-delay.yaml
```

2. Confirm the rule was created:
```
kubectl get virtualservice ratings -o yaml
```

### Testing the delay configuration
1. Open the Bookinfo application in your browser.

2. On the /productpage web page, log in as user jason.
You expect the page to load without errors in about 7 seconds. However the Reviews section is displaying an error message:
```
Error fetching product reviews!
Sorry, product reviews are currently unavailable for this book.
```

3. View the web page response times:

    1.  Open the Developer Tools menu in your web browser.
    2. Open the Network tab.
    3. Reload the web page. You will see that the page actually loads in about 6 seconds.

### What happened?
You found a bug. There are hard-coded timeouts in the microservices that have caused the reviews service to fail. 

As expected, the 7 second delay introduced doesn't affect the reviews service because the timeout between the productpage and the reviews services is hard-coded at 10 seconds. However, there is also a hard-coded timeout between the productpage and reviews service, coded as 3 seconds + 1 retry for 6 seconds total. As a result, the productpage call to reviews times out prematurely and throws an error after 6 seconds.

Bugs like this can occur in typical enterprise applications where different teams develop different microservices independently. Fault injection can help you identify such anomalies without impacting end users.

### Fixing the bug

You would normally fix the problem by:

1. Either increasing the productpage to reviews service timeout or decreasing the reviews to ratings timeout
2. Stopping and restarting the fixed microservice
3. Confirming that the /productpage web page returns its response without any errors.

However, there is already a fix running in version 3 of the reviews service. The reviews:v3 service reduces the reviews to ratings timeout from 10 seconds to 2.5 seconds so that it is compatible with (less than) the timeout of the downstream productpage requests.

You can migrate all traffic to reviews:v3:
```
kubectl apply -f 06-03-faultinjection/exercise/traffic-shifting-v3.yaml
```

# Exercise 3.2
## Injecting a HTTP abort fault
Another way to test microservice resiliency is to introduce a HTTP abort fault. In this task, you will introduce a HTTP abort to the ratings microservices for the test user 'jason'.

In this case, you expect the page to load immediately an error message: 
```
Ratings service is currently unavailable
```

### Configure the rule
1. Create a fault injection rule to send a HTTP abort for user jason.
```
fault:
  abort:
    percentage:
      value: 100.0
    httpStatus: 500
```
Apply the rule:
```
kubectl apply -f 06-03-faultinjection/exercise/ratings-test-abort.yaml
```
2. Confirm the rule was created:
```
kubectl get virtualservice ratings -o yaml
```

### Testing the abort configuration
1. Open the Bookinfo application in your browser.
2. On the /productpage web page, log in as user jason. 
If the rule propagated successfully to all pods, the page loads immediately and the error message appears.
3. If you log out from user jason, you will see the /productpage will have no error message.

### Clean up
Remove the application routing rules
```
kubectl delete -f 06-03-faultinjection/exercise/virtual-service-all-v1.yaml
```

## Canary Deployments with Flagger

Canary deployment is a technique to avoid downtime while deploying a new version of your application. Instead of replacing all your pods with the new version, you deploy new pods with the new version and redirect a small part of the traffic to them to collect metrics and verify that the new version is stable. After verifying that the new version is working as expected, you increase the traffic until you have a great degree of confidence that the new version is working. Only after that would you start removing the pods of the old version. If you encounter a bug or problem, you just redirect the traffic to the old version.

Flagger is a tool to automate all this process. 

## Setup

1. Remove deployments reviews-v1, reviews-v2, reviews-v3

```
kubectl delete deployment reviews-v1 reviews-v2 reviews-v3
```

2. Create a deployment for reviews-v1

```
kubectl apply -f 06-04-flaggercanary/exercise/bookinfo.yml
```

3. Install Flagger

```
kubectl apply -k github.com/weaveworks/flagger//kustomize/istio
```

## Flagger Canary

Flagger adds the type Canary to kubernetes. This type detects changes in a deployment and deploy these changes using the Canary technique. It automates the creation of the new deployments, management of the traffic, analysis of the metrics, rollout and fallback.

```
apiVersion: flagger.app/v1beta1
kind: Canary
metadata:
  name: reviews
  namespace: default
spec:
  # deployment reference
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: reviews
  # the maximum time in seconds for the canary deployment
  # to make progress before it is rollback (default 600s)
  progressDeadlineSeconds: 60
  # The service that will be used to control the traffic between the old and new versions. It's a full istio virtual service.
  service:
    port: 9080
    targetPort: 9080
  # Configuration of the analysis and metrics the canary will use to check if it should continue or roolback
  analysis:
    # schedule interval (default 60s)
    interval: 1m
    # max number of failed metric checks before rollback
    threshold: 5
    # max traffic percentage routed to canary
    # percentage (0-100)
    maxWeight: 50
    # canary increment step
    # percentage (0-100)
    stepWeight: 10
    metrics:
    - name: request-success-rate
      # minimum req success rate (non 5xx responses)
      # percentage (0-100)
      thresholdRange:
        min: 99
      interval: 1m
    - name: request-duration
      # maximum req duration P99
      # milliseconds
      thresholdRange:
        max: 500
      interval: 30s
    # testing (optional)
    webhooks:
      - name: load-test
        url: http://flagger-loadtester.default/
        timeout: 5s
        metadata:
          cmd: "hey -z 1m -q 10 -c 2 http://reviews-canary.default:9080/health"
```

For the canary deploy to work we need to have traffic. In the real world we can use real user traffic, but for this exercise we will use a small pod to call our service. (You can remove the webhooks from the Canary and ignore the step 4 if you manually generate traffic, e.g. refreshing your browser to make request to the service)

4. Install Flagger load tester
```
kubectl apply -f 06-04-flaggercanary/exercise/loadtester.yml
```

5. Create a canary for reviews

```
kubectl apply -f 06-04-flaggercanary/exercise/reviews-canary.yaml
```

6. Wait for the canary to initialise. You can check the status using

```
kubectl get canary reviews
kubectl describe canary reviews
```

7. Once initialised, deploy version 2 of reviews

```
kubectl apply -f 06-04-flaggercanary/exercise/reviews-v2.yml
```

8. Open the application in the browser and refresh the page. You can see the traffic weight increasing using

```
kubectl describe canary reviews
```

Flagger is creating a new deployment with the new image. It then creates a new service for this deployment. It starts to use traffic management using weight based traffic between the canary service and the primary service. It checks the metrics that are set in the canary and if everything is ok, it increases the weight of traffic going to the canary service. It increases until 50%, if everything is ok, it replaces the canary and primary services with the new image and deletes the old deployment. If there are any problems, it rolls back, deletes the canary and routes traffic to the primary service.


# Final Cleanup

Thank you very much for participating in the workshop. We've covered a lot of content but hopefully you;ve learned something along the way and had fun. Please make sure that you clean up your resources in Azure so that you donlt get charged money.

You can run the following command rom the `.build` folder. 

* Run `./batect -f azure.yml destroy-terraform` to destroy the environment


Thanks again and see you soon!








