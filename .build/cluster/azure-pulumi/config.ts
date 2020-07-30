import * as azure from "@pulumi/azure";
import * as pulumi from "@pulumi/pulumi";

// Parse and export configuration variables for this stack.
const config = new pulumi.Config();
export const location = config.get("location") || azure.Locations.EastUS;
export const nodeCount = config.getNumber("nodeCount") || 2;
export const nodeSize = config.get("nodeSize") || "Standard_D2_v2";
export const resourceGroup = new azure.core.ResourceGroup("aks", { name: `${process.env.AZURE_PREFIX}-k8s-resources`, location });