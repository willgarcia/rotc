#!/usr/bin/env bash

set -euo pipefail

echo 'Grafana user:' ; 

kubectl get secret \
    --namespace grafana grafana \
    -o jsonpath={.data.admin-user} | base64 -d ; echo
    
echo
echo 'Grafana password:'
kubectl get secret \
    --namespace grafana grafana \
    -o jsonpath={.data.admin-password} | base64 -d ; echo
    
echo
echo 'To start the grafana dashboard, run:'; 
echo kubectl port-forward \
        -n grafana \
        $(kubectl get pod -n grafana -o jsonpath='{.items[0].metadata.name}') \
        3000