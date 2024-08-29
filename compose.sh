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
        docker exec -it cougars bash

        ;;
    dev-down)
        echo ""
        echo "ALERT: Stopping the development image..."
        echo ""

        docker compose -f docker/docker-compose-amd64.yaml down
        ;;
    down)
        echo ""
        echo "ALERT: Stopping the vehicle image..."
        echo ""

        docker compose -f docker/docker-compose-arm64.yaml down
        ;;
    *)
        echo ""
        echo "ALERT: Loading the vehicle image (arm64)..."
        echo "Load the development image (amd64) by running 'bash compose.sh dev'"
        echo ""

        docker compose -f docker/docker-compose-arm64.yaml up -d
        docker exec -it cougars bash
        ;;
esac
