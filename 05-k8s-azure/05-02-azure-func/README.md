# 05-02 Azure Function Core Tools

You will learn about deploying a simple app to AKS with the Azure Functions core tools

## Start

No code provided. We will build a minimal Web App and expose it to the world!

Run `cd exercise/` and follow the instructions below to get started!

## Cross platform development with func

As part of the  Azure Functions core tools, Microsoft has developed a tool kit to simplify local development and running Azure functions in Function Apps or in Kubernetes.

Today, we will use the `func` CLI to run our first local function and deploy to AKS.

`func` can run in a local Docker container. Use `func init` to generate the function skeleton including the default Dockerfile.

```console
func init --docker
```

And select the following options:

```output
Select a worker runtime:
1. dotnet
2. node
3. python (preview)
4. powershell (preview)
Choose option: 2
node

Select a Language:
1. javascript
2. typescript
Choose option: 2
```

Look at the generated Dockerfile to understand what `func` did for us!

The next step is to add the function code (our application code). `func` provides different app skeleton for different flavours. Run `func new` and create an HTTP Trigger function `http-trigger` (lowercase is important, Kubernetes name must match ^[a-z0-9\-\.]*$.):

```console
func new
```

Select the HTTP Trigger template and make sure your name your function `http-trigger` (lowercase):

```output
Select a template:
1. Azure Blob Storage trigger
2. Azure Cosmos DB trigger
3. Durable Functions activity
4. Durable Functions HTTP starter
5. Durable Functions orchestrator
6. Azure Event Grid trigger
7. Azure Event Hub trigger
8. HTTP trigger
9. IoT Hub (Event Hub)
10. Azure Queue Storage trigger
11. SendGrid
12. Azure Service Bus Queue trigger
13. Azure Service Bus Topic trigger
14. Timer trigger
Choose option: 8
HTTP trigger
Function name: [HttpTrigger]: http-trigger
```

Finally deploy the function to AKS:

```console
# Windows only
$env:TEAM_NAME="[team-name-placeholder]"
func kubernetes deploy --name http-trigger --namespace $env:TEAM_NAME --registry rotcaus.azurecr.io

# MacOS only
export TEAM_NAME=[team-name-placeholder]
func kubernetes deploy \
    --name http-trigger \
    --namespace ${TEAM_NAME} \
    --registry rotcaus.azurecr.io
```

This will:

* create a service principal to grant access to the private Docker registry `ktraining.azurecr.io`
* build the current Dockerfile
* push the image to the ACR registry
* deploy the following Kubernetes resources: Secret, ScaledObject,  Deployment and Service.

The output should be similar to this:

```output
Running 'docker build -t rotcaus.azurecr.io/http-trigger /Users/wgarcia/Workspace/gitlab.com/rise-of-containers/03-02-aks-func-helm/solution'..done
Running 'docker push rotcaus.azurecr.io/http-trigger'..........................done
secret/http-trigger created
service/http-trigger-http created
deployment.apps/http-trigger-http created
```

The function will now publicly accessible! Find its public IP by looking at the EXTERNAL-IP column of this command (the public IP might take some time to become available):

```output
kubectl get services -w
NAME                TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)        AGE
http-trigger-http   LoadBalancer   10.0.126.82   40.78.50.177   80:30612/TCP   2m27s
```

The logs of the application are also available with:

```console
kubectl get pod
kubectl logs pod/[POD-NAME] http-trigger-http -f
```

## Cleanup

Delete all the resources created by `func`:

```console
# Windows only
kubectl delete all --all -n "$env:TEAM_NAME"

# MacOS only
kubectl delete all --all -n "${TEAM_NAME}"
```

Links:

* [Work with Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local)
* [Code and test Azure Functions locally](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-local)
* [Command line tools for Azure Functions
](https://github.com/Azure/azure-functions-core-tools)
* [Azure Functions 2.0: Create, debug and deploy to Azure Kubernetes Service (AKS)
](https://blogs.msdn.microsoft.com/atverma/2018/09/26/azure-functions-2-0-create-debug-and-deploy-to-azure-kubernetes-service-aks/)
