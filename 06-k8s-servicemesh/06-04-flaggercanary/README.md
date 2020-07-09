# Canary Deployments with Flagger

Canary deployment is a technique to avoid downtime while deploying a new version of your application. Instead of replacing all your pods with the new version, you deploy new pods with the new version and redirect a small part of the traffic to them to collect metrics and verify that the new version is stable. After verifying that the new version is working as expected, you increase the traffic until you have a great degree of confidence that the new version is working. Only after it that you start removing the pods of the old version. If you encounter a bug or problem, you just redirect the traffic to the old version.

Flagger is a tool to automate all this process. 

## Setup

1. Remove deployments reviews-v1, reviews-v2, reviews-v3

```
kubectl delete deployment reviews-v1 reviews-v2 reviews-v3
```

2. Create a deployment for reviews-v1

```
kubectl apply -f ./exercise/bookinfo.yml
```

3. Install Flagger

```
kubectl apply -k github.com/weaveworks/flagger//kustomize/istio
```

## Flagger Canary

Flagger adds the type Canary to kubernetes. This type detects changes in a deployment and deploy these changes using the Canary technique. It automates the creation of the new deployments, management of the traffic, analysis of the metrics, roolout and fallback.

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
kubectl apply -f ./exercise/loadtester.yml
```

5. Create a canary for reviews

```
kubectl apply -f ./exercise/reviews-canary.yaml
```

6. Wait for the canary to initialise. You can check the status using

```
kubectl get canary reviews
kubectl describe canary reviews
```

7. Once initialised, deploy version 2 of reviews

```
kubectl apply -f ./exercise/reviews-v2.yml
```

8. Open the application in the browser and refresh the page. You can see the traffic weight increasing using

```
kubectl describe canary reviews
```

Flagger is creating a new deployment with the new image. It then creates a new service for this deployment. It starts to use traffic management using weight based traffic between the canary service and the primary service. It checks the metrics that are set in the canary and if everything is ok, it increases the weight of traffic going to the canary service. It increases until 50%, if everything is ok, it replaces the canary and primary services with the new image and deletes the old deployment. If there are any problems, it rolls back, deletes the canary and routes traffic to the primary service.