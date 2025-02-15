#!/bin/sh

export INSTALL_K3S_EXEC="--node-ip $K3S_CONTROLLER_IP"
curl -sfL https://get.k3s.io/ | sh -
if [ $? -ne 0 ]; then
    echo "Failed to install K3s and start the service."
    exit 1
fi

echo "K3s controller setup complete!"


kubectl apply -f /vagrant/apps/app1.yaml
kubectl apply -f /vagrant/apps/app2.yaml
kubectl apply -f /vagrant/apps/app3.yaml
kubectl apply -f /vagrant/apps/ingress.yaml
echo "Applications are ready!"