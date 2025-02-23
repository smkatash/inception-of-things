#!/bin/sh

echo "Starting part3..."
cd set_up

sh install_dependencies.sh
if [ $? -ne 0 ]; then
    echo "Failed to install dependencies."
    exit 1
fi

sh launch_app.sh
if [ $? -ne 0 ]; then
    echo "Failed to launch the app."
    exit 1
fi