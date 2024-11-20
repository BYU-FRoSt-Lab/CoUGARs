#!/bin/bash
# Created by Nelson Durrant, Sep 2024
#
# Simply pulls all avaliable updates
# - Make sure you run this from the root of the top-level repo

function printInfo {
  echo -e "\033[0m\033[36m[INFO] $1\033[0m"
}

function printWarning {
  echo -e "\033[0m\033[33m[WARNING] $1\033[0m"
}

function printError {
  echo -e "\033[0m\033[31m[ERROR] $1\033[0m"
}

printWarning "This script should be run from the root of the CoUGARS directory"

# Docker updates
docker pull frostlab/cougars:latest

# GitHub updates
git pull

cd ./cougars-ros2
git pull

cd ../cougars-teensy
git pull

cd ../cougars-gpio
git pull

cd ../cougars-docs
git pull

cd ../cougars-base-station
git pull
