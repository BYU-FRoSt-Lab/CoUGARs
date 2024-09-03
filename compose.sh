#!/bin/bash

##########################################################
# PULLS AND RUNS THE NEWEST DOCKER IMAGE
# - Use "bash compose.sh down" to stop the image
# - Run this script after running "setup.sh" to pull the
#   most recent image and run it
# - This can also be used to open a new bash terminal in
#   an already running container
##########################################################

cd ~/CougarsSetup
case $1 in
    down)

        # check the system architecture
        if [ "$(uname -m)" == "aarch64" ]; then
            echo ""
            echo "ALERT: Stopping the vehicle image..."
            echo ""

            docker compose -f docker/docker-compose-arm64.yaml down
        else
            echo ""
            echo "ALERT: Stopping the development image..."
            echo ""

            docker compose -f docker/docker-compose-amd64.yaml down
        fi
        ;;
    *)
        
        # check the system architecture
        if [ "$(uname -m)" == "aarch64" ]; then
            echo ""
            echo "ALERT: Loading the vehicle image (arm64)..."
            echo ""

            docker compose -f docker/docker-compose-arm64.yaml up -d
        else
            echo ""
            echo "ALERT: Loading the development image (amd64)..."
            echo ""

            docker compose -f docker/docker-compose-amd64.yaml up -d
        fi
        docker exec -it cougars bash
        ;;
esac
