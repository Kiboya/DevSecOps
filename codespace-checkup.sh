#!/bin/bash

# Codespace Infrastructure Check-up Script
# Ce script vérifie l'état de l'environnement (Minikube, Docker, Helm, Kubernetes) 
# et détecte s'il reste des traces d'anciennes exécutions.

echo "========================================================="
echo "🔍 DIAGNOSTIC DE L'ENVIRONNEMENT CODESPACES (DEVSECOPS)"
echo "========================================================="
echo ""

echo "--- 1. ÉTAT DE DOCKER 🐳 ---"
if command -v docker &> /dev/null; then
    echo "✅ Docker est installé."
    echo "[!] Conteneurs en cours d'exécution ou arrêtés :"
    docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
    echo ""
    echo "[!] Volumes locaux (peuvent contenir de vieux logs ou configs) :"
    docker volume ls
else
    echo "❌ Docker n'est pas installé ou n'est pas dans le PATH."
fi
echo ""

echo "--- 2. ÉTAT DE MINIKUBE ☸️ ---"
if command -v minikube &> /dev/null; then
    echo "✅ Minikube est installé."
    echo "[!] Profils Minikube existants :"
    minikube profile list 2>/dev/null || echo "Aucun profil Minikube actif ou cluster créé."
    echo ""
    echo "[!] Statut global :"
    minikube status 2>/dev/null || echo "Minikube est complètement à l'arrêt."
else
    echo "❌ Minikube n'est pas installé."
fi
echo ""

echo "--- 3. ÉTAT DE KUBERNETES & KUBECTL ☸️ ---"
if command -v kubectl &> /dev/null; then
    echo "✅ Kubectl est installé."
    CONTEXT=$(kubectl config current-context 2>/dev/null)
    if [ ! -z "$CONTEXT" ]; then
        echo "[!] Contexte actuel : $CONTEXT"
        if [ "$CONTEXT" == "minikube" ]; then
            echo "[!] Pods dans le namespace par défaut (Traces potentielles) :"
            kubectl get pods 2>/dev/null || echo "Le serveur API de minikube ne répond pas (cluster éteint)."
            
            echo ""
            echo "[!] Vérification des namespaces critiques (S'il y en a, le cluster n'est pas vierge) :"
            kubectl get ns falco kyverno secure-namespace 2>/dev/null || echo "Aucun namespace spécifique détecté."
        fi
    else
         echo "Aucun contexte Kubernetes configuré."
    fi
else
    echo "❌ Kubectl n'est pas installé."
fi
echo ""

echo "--- 4. ÉTAT DE HELM ⚓ ---"
if command -v helm &> /dev/null; then
    echo "✅ Helm est installé."
    echo "[!] Releases Helm installées toutes namespaces confondus :"
    helm ls -A 2>/dev/null || echo "Le serveur n'est pas atteignable."
else
    echo "❌ Helm n'est pas installé."
fi
echo ""

echo "========================================================="
echo "🧹 POUR NETTOYER COMPLÈTEMENT VOTRE ENVIRONNEMENT :"
echo "1. Supprimer le cluster K8s : minikube delete --all"
echo "2. Nettoyer tout Docker : docker system prune -a --volumes -f"
echo "========================================================="
