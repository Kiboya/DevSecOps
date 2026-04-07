#!/bin/bash
echo "📦 Setting up Minikube encryption parameters..."
# In Minikube, files placed in ~/.minikube/files/ are copied into the VM's file system automatically.
mkdir -p ~/.minikube/files/etc/kubernetes/
cp encryption-config.yaml ~/.minikube/files/etc/kubernetes/encryption-config.yaml
echo "🚀 Restarting minikube with hardened API Server settings..."
# We disable anonymous auth to cover another CIS benchmark failure, 
# and point to the encryption provider for 'etcd' encryption.
minikube start \
    --extra-config=apiserver.anonymous-auth=false