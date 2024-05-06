#!/bin/bash

##########################################################
# STARTS A NEW TERMINAL IN THE RUNNING DOCKER CONTAINER
# - Use this to add additional terminals to the running
#   container, as well as re-enter containers you left
#   without shutting down. You can see currently running
#   containers by running "docker ps"
##########################################################

docker exec -it cougars bash