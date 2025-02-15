#!/bin/sh

K3S_TOKEN_FILE="/vagrant/k3s-token"
K3S_CONTROLLER_HOSTNAME_FILE="/vagrant/k3s-controller-hostname"
K3S_CONTROLLER_IP=$(cat "$K3S_CONTROLLER_HOSTNAME_FILE")
K3S_AGENT_IP=$(hostname -I | awk '{print $1}')

if [ ! -f "$K3S_TOKEN_FILE" ]; then
    echo "K3s token file not found."
    exit 1
fi

echo "Installing K3s agent..."
export INSTALL_K3S_EXEC="agent --server https://${K3S_CONTROLLER_IP}:6443 --node-ip $K3S_AGENT_IP --token-file $K3S_TOKEN_FILE"
curl -sfL https://get.k3s.io/ | sh -
if [ $? -ne 0 ]; then
    echo "Failed to install K3s agent."
    exit 1
fi

echo "K3s agent setup complete!"
