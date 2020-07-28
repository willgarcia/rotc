# 9. Use App Gateway for network isolation in Azure

Date: 2020-07-28

## Status

Deferred

## Context
We've played fast and loose with infrastructure security in our set up processes.  Let's avoid putting our kube stacks on the internet without protection.
Other ADRS may focus on AWS and GCP, this one focuses on Azure.

## Decision

Use App Gateway on Azure.

Our terraform recipes use Azures simple provisioning which create a managed subnet and a managed identity, and virtual IP, and then expose the kube API to the internet.

Instead, we propose putting an App Gateway between the internet and the kube cluster. 

We have decided to defer this deciusion until later.  Progress is available in the azure-app-gateway branch of this repository.

### Background
Diagram - TBD.

Trade-offs:

* Configuration gets more complicated
* Resources have to be explicitly managed
* Sequencing - references between resources not always created in the right order
* Cost - app gateways cost money even when not being used

* Service-mesh awareness - The AGIC does not understand istio configuration - so traffic has to be routed through the AGIC and then to the istio-gateway-service.

* Stability - App Gateway Ingres controller is availble either as an AKS add-on (not supported by Terraform, and in preview from Azure), otherwide provision by Helm.

### Links

* AGIC configuration page from Microsoft
* App Gateway provisioning using terraform

## Consequences

We will continue to expose our workshop cluster on the internet.