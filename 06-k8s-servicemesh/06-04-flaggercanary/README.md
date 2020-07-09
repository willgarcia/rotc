# Canary Deployments with Flagger

1. Remove deployments reviews-v1, reviews-v2, reviews-v3

```
kubectl delete deployment reviews-v1 reviews-v2 reviews-v3
```

2. Create a deployment for reviews-v1

```
kubectl apply -f ./exercise/bookinfo.yml
```

3. Create a Horizontal Pod Autoscaler

```
kubectl apply -f ./exercise/hpa.yml
```

4. Install Flagger

```
kubectl apply -k github.com/weaveworks/flagger//kustomize/istio
```

5. Install Flagger load tester
```
kubectl apply -f ./exercise/loadtester.yml
```

6. Create a canary for reviews

```
kubectl apply -f ./exercise/reviews-canary.yml
```

7. Wait for the canary to initialise. You can check the status using

```
kubectl get canary reviews
kubectl describe canary reviews
```

8. Once initialised, deploy version 2 of reviews

```
kubectl set image deployment/reviews reviews=docker.io/istio/examples-bookinfo-reviews-v2:1.16.2
```
```
kubectl apply -f ./exercise/reviews-v2
```

9. Open the application in the browser and refresh the page. You can see the traffic weight increasing using

```
kubectl describe canary reviews
```

Flagger is creating a new deployment with the new image. It then creates a new service for this deployment. It starts to use traffic management using weight based traffic between the canary service and the primary service. It checks the metrics that are set in the canary and if everything is ok, it increases the weight of traffic going to the canary service. It increases until 50%, if everything is ok, it replaces the canary and primary services with the new image and deletes the old deployment. If there are any problems, it rolls back, deletes the canary and routes traffic to the primary service.