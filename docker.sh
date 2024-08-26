#!/bin/bash

##########################################################
# PULLS AND RUNS THE NEWEST DOCKER IMAGE
# - Run this script after running "setup.sh" to pull the
#   most recent image and run it
# - This can also be used to open a new bash terminal in
#   an already running container
##########################################################

cd ~/CougarsSetup
case $1 in
    dev)
        echo ""
        echo "ALERT: Loading the dev image (amd64)..."
        echo ""

        docker compose -f dev-docker-compose.yaml up -d --pull always

        ;;
    *)
        echo ""
        echo "ALERT: Loading the standard image (arm64)..."
        echo "Load the dev image (amd64) by running 'docker.sh dev'"
        echo ""

        docker compose -f latest-docker-compose.yaml up -d --pull always
        ;;
esac

docker exec -it cougars bash
