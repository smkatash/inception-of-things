#!/bin/sh

export INSTALL_K3S_EXEC="--node-ip $K3S_CONTROLLER_IP"
curl -sfL https://get.k3s.io/ | sh -
if [ $? -ne 0 ]; then
    echo "Failed to install K3s and start the service."
    exit 1
fi

echo "K3s controller setup complete!"


kubectl apply -f /vagrant/confs/app1.yaml
kubectl apply -f /vagrant/confs/app2.yaml
kubectl apply -f /vagrant/confs/app3.yaml
kubectl apply -f /vagrant/confs/ingress.yaml
echo "Applications are ready!"