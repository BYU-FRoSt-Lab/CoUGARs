#!/bin/bash

##########################################################
# PULLS AND RUNS THE NEWEST DOCKER IMAGE
# - Run this script after running "setup.sh" to pull the
#   most recent image and run it
# - This can also be used to open a new bash terminal in
#   an already running container
##########################################################

docker pull frostlab/cougars:latest

cd ~/CougarsSetup
docker compose -f latest-docker-compose.yaml up -d
# docker compose -f dev-docker-compose.yaml up -d
docker exec -it cougars bash
