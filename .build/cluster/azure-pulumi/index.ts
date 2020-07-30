import { k8sCluster } from "./cluster";

export let cluster = k8sCluster.name;
export let kubeConfig = k8sCluster.kubeConfigRaw;
