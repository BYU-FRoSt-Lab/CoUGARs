#!/bin/bash

docker pull snelsondurrant/cougars:latest
docker run -it --rm --name cougars --user frostlab --net=host --privileged -v /dev:/dev -v /run/udev:/run/udev:ro -v /home/frostlab/bag:/home/frostlab/ros2_ws/bag snelsondurrant/cougars:latest