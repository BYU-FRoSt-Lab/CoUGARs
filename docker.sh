#!/bin/bash

##########################################################
# PULLS AND RUNS THE NEWEST DOCKER IMAGE
# - The "--rm" flag destroys the container on exit. Make
#   sure to commit changes from another terminal while
#   it's still running if you're working on image dev
##########################################################

docker pull snelsondurrant/cougars:latest
docker run -it --rm --name cougars --user frostlab --net=host --privileged -v /home/frostlab/bag:/home/frostlab/ros2_ws/bag -v /dev:/dev -v /run/udev:/run/udev:ro snelsondurrant/cougars:latest