import * as azure from "@pulumi/azure";
import * as k8s from "@pulumi/kubernetes";
import * as pulumi from "@pulumi/pulumi";
import * as config from "./config";

// Allocate an AKS cluster.
export const k8sCluster = new azure.containerservice.KubernetesCluster("aksCluster", {
    name: `${process.env.AZURE_PREFIX}-k8s`,
    resourceGroupName: config.resourceGroup.name,
    location: config.location,
    defaultNodePool: {
        name: "aksagentpool",
        nodeCount: config.nodeCount,
        vmSize: config.nodeSize,
    },
    identity: {
        type: "SystemAssigned"
    },
    dnsPrefix: `${pulumi.getStack()}-kube`,
});

// Expose a K8s provider instance using our custom cluster instance.
export const k8sProvider = new k8s.Provider("aksK8s", {
    kubeconfig: k8sCluster.kubeConfigRaw,
});
