#!/bin/bash

# Update kubeconfig for EKS cluster
aws eks update-kubeconfig --region eu-west-1 --name orbiton-dev-eks

# Apply the Kubernetes manifests
kubectl apply -f kubernetes/deployment.yaml

# Wait for the deployment to be ready
kubectl rollout status deployment/tiny-node-app

# Get the LoadBalancer URL
echo "Waiting for LoadBalancer to be ready..."
sleep 30
kubectl get service tiny-node-app-service