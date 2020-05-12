#!/bin/sh

set -e
set -u

export KUBE_NAMESPACE=prometheus
export KUBE_CLUSTER=k8s-cluster
export GCP_REGION=australia-southeast1-a
export GCP_PROJECT=servicemeshlab
export DATA_DIR=/prometheus/
export DATA_VOLUME=prometheus-storage-volume
export SIDECAR_IMAGE_TAG=0.5.2

usage() {
  echo -e "Usage: $0 <deployment|statefulset> <name>\n"
}

if [  $# -le 1 ]; then
  usage
  exit 1
fi


# kubectl create -f clusterRole.yml || true

# kubectl create -f configMap.yml -n prometheus  || true

# kubectl create -f prometheus-deployment.yml -n prometheus  || true

# Override to use a different Docker image name for the sidecar.
export SIDECAR_IMAGE_NAME=${SIDECAR_IMAGE_NAME:-'gcr.io/stackdriver-prometheus/stackdriver-prometheus-sidecar'}

kubectl -n "${KUBE_NAMESPACE}" patch "$1" "$2" --type strategic --patch "
spec:
  template:
    spec:
      containers:
      - name: sidecar
        image: ${SIDECAR_IMAGE_NAME}:${SIDECAR_IMAGE_TAG}
        imagePullPolicy: Always
        args:
        - \"--stackdriver.project-id=${GCP_PROJECT}\"
        - \"--stackdriver.kubernetes.location=${GCP_REGION}\"
        - \"--stackdriver.kubernetes.cluster-name=${KUBE_CLUSTER}\"
        - \"--prometheus.wal-directory=${DATA_DIR}/wal\"
        ports:
        - name: sidecar
          containerPort: 9091
        volumeMounts:
        - name: ${DATA_VOLUME}
          mountPath: ${DATA_DIR}
"