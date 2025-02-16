#!/bin/sh

K3S_TOKEN_FILE="/vagrant/k3s-token"
K3S_CONTROLLER_HOSTNAME_FILE="/vagrant/k3s-controller-hostname"
K3S_CONTROLLER_IP=$(hostname -I | awk '{print $1}')

export INSTALL_K3S_EXEC="--node-ip $K3S_CONTROLLER_IP --bind-address=$K3S_CONTROLLER_IP --advertise-address=$K3S_CONTROLLER_IP"
echo "$K3S_CONTROLLER_IP" > ${K3S_CONTROLLER_HOSTNAME_FILE}
curl -sfL https://get.k3s.io/ | sh -
if [ $? -ne 0 ]; then
    echo "Failed to install K3s and start the service."
    exit 1
fi

K3S_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
echo "$K3S_TOKEN" > ${K3S_TOKEN_FILE}
if [ $? -ne 0 ]; then
    echo "Failed to save k3s token to vagrant file."
    exit 1
fi

echo "K3s controller setup complete!"