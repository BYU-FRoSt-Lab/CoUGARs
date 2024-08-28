#!/bin/bash

##########################################################
# PULLS AND RUNS THE NEWEST DOCKER IMAGE
# - Specify the dev image by running "bash compose.sh dev"
# - Run this script after running "setup.sh" to pull the
#   most recent image and run it
# - This can also be used to open a new bash terminal in
#   an already running container
##########################################################

cd ~/CougarsSetup
case $1 in
    dev)
        echo ""
        echo "ALERT: Loading the development image (amd64)..."
        echo ""

        docker compose -f docker/docker-compose-amd64.yaml up -d

        ;;
    *)
        echo ""
        echo "ALERT: Loading the latest vehicle image (arm64)..."
        echo "Load the development image (amd64) by running 'bash compose.sh dev'"
        echo ""

        docker compose -f docker/docker-compose-arm64.yaml up -d
        ;;
esac

docker exec -it cougars bash
