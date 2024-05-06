#!/bin/bash

docker run -it --rm --user frostlab --net=host --privileged -v /dev:/dev -v /run/udev:/run/udev:ro -v ros2_ws/bag:~/bag snelsondurrant/cougars:latest