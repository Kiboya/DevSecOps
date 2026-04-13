#!/bin/bash
echo "🚀 Restarting minikube with hardened API Server settings..."

# Simplification drastique pour éviter le crash de l'API Server.
# L'attribut encryption-provider-config a prouvé être instable sur certaines
# versions docker/minikube à cause du montage des volumes. Nous nous
# concentrons donc sur la désactivation du profiling pour améliorer le score CIS.

minikube start \
    --extra-config=apiserver.profiling=false \
    --extra-config=controller-manager.profiling=false \
    --extra-config=scheduler.profiling=false