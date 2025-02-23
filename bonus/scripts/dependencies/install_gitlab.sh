#!/bin/sh

# Gitlab
kubectl create namespace gitlab
helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.hosts.domain=localhost \
  --set postgresql.install=false \
  --set global.edition=ce