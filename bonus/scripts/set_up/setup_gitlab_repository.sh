#!/bin/sh

GITLAB_URL="127.0.0.1"
GITLAB_USER="root"
GITLAB_REPO_NAME="mktashbae-iot"
GITLAB_REPO="root"
GITLAB_REPO_DESCRIPTION="Kubernetes manifests repository for ArgoCD"
GITLAB_REPO_VISIBILITY="public"
MANIFEST_SOURCE_DIR="../../confs"
MANIFEST_FOLDER_PATH="manifest"

# Authenticate to get an API session
GITLAB_PASS=$(kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o=jsonpath="{.data.password}" | base64 --decode)
GITLAB_TOKEN=$(curl --request POST "$GITLAB_URL/api/v4/session" \
    --data "login=$GITLAB_USER&password=$GITLAB_PASS" \
    --header "Content-Type: application/json" \
    --silent | jq -r .private_token)

echo "GitLab token: $GITLAB_TOKEN"

# Create a new GitLab repository
curl --request POST "$GITLAB_URL/api/v4/projects" \
    --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    --data "name=$REPO_NAME&namespace_id=1&description=$GITLAB_REPO_DESCRIPTION&visibility=$GITLAB_REPO_VISIBILITY"

# Clone the repository and push local manifest files
git clone "$GITLAB_URL/$GITLAB_REPO/$GITLAB_REPO_NAME.git"
cd "$GITLAB_REPO_NAME"
mkdir -p $MANIFEST_FOLDER_PATH
cp -r "$MANIFEST_SOURCE_DIR"/* $MANIFEST_FOLDER_PATH

# Add, commit, and push files
git add .
git commit -m "Initial commit with Kubernetes manifests"
git branch -M main
git push origin main

echo "GitLab repository setup completed successfully!"
