#!/bin/bash

# Update kubeconfig for EKS cluster
aws eks update-kubeconfig --region eu-west-1 --name orbiton-dev-eks

# Replace variables in the deployment template
envsubst < kubernetes/deployment.yaml | kubectl apply -f -

# Wait for the deployment to be ready
kubectl rollout status deployment/tiny-node-app

# Wait for the LoadBalancer to be ready
echo "Waiting for LoadBalancer to be ready..."
sleep 30
kubectl get service tiny-node-app-service
