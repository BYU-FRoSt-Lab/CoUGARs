#!/bin/bash
# Created by Nelson Durrant, Sep 2024
#
# Simply pulls all avaliable git updates

git pull

cd ./cougars-ros2
git pull

cd ../cougars-teensy
git pull

cd ../cougars-gpio
git pull
