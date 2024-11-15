#!/bin/bash
# Created by Nelson Durrant, Sep 2024
#
# Pulls and runs the most recent Docker image
# - Use 'bash compose.sh down' to stop the image
# - Run this script after running 'setup.sh' to pull the most recent image and run it
# - This can also be used to open a new bash terminal in an already running container
# - Make sure you run this from the root of the top-level repo

source config/bash_vars.sh

function printInfo {
  echo -e "\033[0m\033[36m[INFO] $1\033[0m"
}

function printWarning {
  echo -e "\033[0m\033[33m[WARNING] $1\033[0m"
}

function printError {
  echo -e "\033[0m\033[31m[ERROR] $1\033[0m"
}

printWarning "This script should be run from the root of the CoUGARS directory"

case $1 in
  "down")
    # Check the system architecture
    if [ "$(uname -m)" == "aarch64" ]; then
      printWarning "Stopping the runtime image..."
      docker compose -f docker/docker-compose-rt.yaml down
    else
      printWarning "Stopping the development image..."
      docker compose -f docker/docker-compose-dev.yaml down
    fi
    ;;
  *)
    # Check the system architecture
    if [ "$(uname -m)" == "aarch64" ]; then
      printInfo "Loading the runtime image..."
      docker compose -f docker/docker-compose-rt.yaml up -d
    else
      printInfo "Loading the development image..."
      docker compose -f docker/docker-compose-dev.yaml up -d
    fi

    # Quick permission fix for GPIO access in the container
    docker exec --user root cougars bash -c "bash /home/frostlab/gpio/permission_fix.sh $GPIO_CHIP"

    docker exec -it cougars bash
    ;;
esac
