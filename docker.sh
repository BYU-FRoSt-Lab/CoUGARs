#!/bin/bash

docker run -it --rm --user frostlab --net=host --privileged -v /dev:/dev -v /run/udev:/run/udev:ro -v /home/frostlab/ros2_ws/bag:/home/frostlab/bag snelsondurrant/cougars:latest