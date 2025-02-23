#!/bin/sh

GITLAB_URL="gitlab.local"
GITLAB_REPO_NAME="mktashbae-iot"
GITLAB_REPO="root"
MANIFEST_REPO=$GITLAB_URL/$GITLAB_REPO/$GITLAB_REPO_NAME.git
MANIFEST_FOLDER_PATH="manifest"

k3d cluster create ktashbaeS

# # ArgoCD
kubectl create namespace argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=ready pod --all --timeout=300s -n argocd

kubectl port-forward -n argocd svc/argocd-server 8080:443 > /dev/null 2>&1 &
argo_pass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o=jsonpath="{.data.password}" | base64 --decode)
argocd login 127.0.0.1:8080 --username=admin --password="$argo_pass" --insecure


# Gitlab
kubectl create namespace gitlab
helm repo add gitlab https://charts.gitlab.io/
helm repo update gitlab
helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  --timeout 600s \
  --set global.hosts.domain=$GITLAB_URL \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.externalIP=127.0.0.1 \
  --set global.hosts.https=false 
  
kubectl wait --for=condition=ready pod --all --timeout=300s -n gitlab
kubectl port-forward -n gitlab svc/gitlab-webservice-default 80:9090 > /dev/null 2>&1 &

# sh setup_gitlab_repository.sh
# if [ $? -ne 0 ]; then
#     echo "Failed to create a new GitLab repository."
#     exit 1
# fi

# # Create app on dev
# kubectl create namespace dev
# argocd app create wil-playground --repo $MANIFEST_REPO --path $MANIFEST_FOLDER_PATH --dest-server https://kubernetes.default.svc --dest-namespace dev
# argocd app sync wil-playground
# kubectl wait --for=condition=ready pod --all --timeout=300s -n dev
# argocd app set wil-playground --sync-policy automated
# sleep 2
# argocd app set wil-playground --self-heal --auto-prune
# kubectl port-forward -n dev svc/wil-playground 8888:8888 > /dev/null 2>&1 &