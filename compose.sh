#!/bin/bash
# Created by Nelson Durrant, Sep 2024

##########################################################
# PULLS AND RUNS THE NEWEST DOCKER IMAGE
# - Use 'bash compose.sh down' to stop the image
# - Run this script after running 'setup.sh' to pull the
#   most recent image and run it
# - This can also be used to open a new bash terminal in
#   an already running container
##########################################################

function printInfo {
  echo -e "\033[0m\033[36m[INFO] $1\033[0m"
}

function printWarning {
  echo -e "\033[0m\033[33m[WARNING] $1\033[0m"
}

function printError {
  echo -e "\033[0m\033[31m[ERROR] $1\033[0m"
}

cd ~/CougarsSetup
case $1 in
    "down")

        # check the system architecture
        if [ "$(uname -m)" == "aarch64" ]; then
            echo ""
            printInfo "Stopping the vehicle image..."
            echo ""

            docker compose -f docker/docker-compose-arm64.yaml down
        else
            echo ""
            printInfo "Stopping the development image..."
            echo ""

            docker compose -f docker/docker-compose-amd64.yaml down
        fi
        ;;
    *)
        
        # check the system architecture
        if [ "$(uname -m)" == "aarch64" ]; then
            echo ""
            printInfo "Loading the vehicle image (arm64)..."
            echo ""

            docker compose -f docker/docker-compose-arm64.yaml up -d
        else
            echo ""
            printInfo "Loading the development image (amd64)..."
            echo ""

            docker compose -f docker/docker-compose-amd64.yaml up -d
        fi
        docker exec -it cougars bash
        ;;
esac
