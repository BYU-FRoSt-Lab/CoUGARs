#!/bin/bash

##########################################################
# PULLS AND RUNS THE NEWEST DOCKER IMAGE
# - Run this script after running "setup.sh" to pull the
#   most recent image and run it
##########################################################

docker pull snelsondurrant/cougars:latest
docker compose up -d
bash extra.sh
