#!/bin/sh

sudo apt-get update -y && sudo apt-get upgrade -y

echo "Starting dependency installation..."
cd ../dependencies

sh install_docker.sh
if [ $? -ne 0 ]; then
    echo "Failed to install docker."
    exit 1
fi

sh install_kube.sh
if [ $? -ne 0 ]; then
    echo "Failed to install kubectl and k3d."
    exit 1
fi

sh install_argocd.sh
if [ $? -ne 0 ]; then
    echo "Failed to install ArgoCD."
    exit 1
fi

sh install_helm.sh
if [ $? -ne 0 ]; then
    echo "Failed to install helm."
    exit 1
fi

sh install_gitlab.sh
if [ $? -ne 0 ]; then
    echo "Failed to install Gitlab."
    exit 1
fi

echo "All dependencies installed successfully. Rebooting the system."
sudo reboot
