#!/bin/sh
MANIFEST_GITHUB_REPO="https://github.com/smkatash/ktashbae-iot.git"
MANIFEST_FOLDER_PATH="manifest"

k3d cluster create ktashbaeS

# ArgoCD
kubectl create namespace argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=ready pod --all --timeout=300s -n argocd

kubectl port-forward -n argocd svc/argocd-server 8080:443 > /dev/null 2>&1 &
argo_pass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o=jsonpath="{.data.password}" | base64 --decode)
argocd login 127.0.0.1:8080 --username=admin --password="$argo_pass" --insecure

# Create app on dev
kubectl create namespace dev
argocd app create wil-playground --repo $MANIFEST_GITHUB_REPO --path $MANIFEST_FOLDER_PATH --dest-server https://kubernetes.default.svc --dest-namespace dev
argocd app sync wil-playground
kubectl wait --for=condition=ready pod --all --timeout=300s -n dev
argocd app set wil-playground --sync-policy automated
sleep 2
argocd app set wil-playground --self-heal --auto-prune
kubectl port-forward -n dev svc/wil-playground 8888:8888 > /dev/null 2>&1 &