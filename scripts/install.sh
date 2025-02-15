#!/bin/bash

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "This script is intended to run on Linux. Please visit the following URL to install on your OS:"
    exit 1
fi

if ! [ -x "$(command -v kubectl)" ]; then
    echo "kubectl is not installed. Please install kubectl first."
    exit 1
fi

if ! [ -x "$(command -v kind)" ]; then
    echo "kind is not installed. Please install kind first."
    exit 1
fi

if ! [ -x "$(command -v helm)" ]; then
    echo "helm is not installed. Please install helm first."
    exit 1
fi

# Create a kind cluster

kind delete cluster 
kind create cluster --config ./kind.yaml
kubectl cluster-info --context kind-kind


# Install Grafana, Tempo and OpenTelemetry Operator
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update
helm install tempo grafana/tempo 
helm install grafana grafana/grafana

# install nginx ingress controller to kind
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl rollout status -w deployment/ingress-nginx-controller -n ingress-nginx --timeout=5m

helm install opentelemetry-operator open-telemetry/opentelemetry-operator \
--set "manager.collectorImage.repository=otel/opentelemetry-collector-k8s" \
--set admissionWebhooks.certManager.enabled=false \
--set admissionWebhooks.autoGenerateCert.enabled=true

# install shenlong 

kubectl apply -f ./k8s/values.yaml