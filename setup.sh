#!/bin/bash
# Created by Nelson Durrant, Sep 2024
#
# Sets up environment requirements on a new RPi 5
# - Run this script on a newly flashed Raspberry Pi 5. After running it, run 'compose.sh' to load in and run the most current image
# - This script can also be used to set up a new development environment on a personal machine
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
function printSuccess {
  echo -e "\033[0m\033[32m[SUCCESS] $1\033[0m"
}

function printFailure {
  echo -e "\033[0m\033[31m[FAIL] $1\033[0m"
}

printWarning "This script should be run in the CoUGARS directory"

#TODO make this script so that it can have a case that just runs the setup of the config 

if [ "$(uname -m)" == "aarch64" ]; then

  printInfo "Setting up CoUGARs on a Raspberry Pi 5"
            
  # Install Docker if not already installed
  if ! [ -x "$(command -v docker)" ]; then
      curl -fsSL https://get.docker.com -o get-docker.sh
      sudo sh get-docker.sh
      rm get-docker.sh
      sudo usermod -aG docker $USERNAME
  else
      printWarning "Docker is already installed"
  fi

  # Install dependencies
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y vim tmux chrony git mosh

  # Set up volumes
  mkdir bag
  mkdir config
  cp -r templates/* config/

  # Set up udev rules
  sudo ln -s config/local/00-teensy.rules /etc/udev/rules.d/00-teensy.rules
  sudo udevadm control --reload-rules
  sudo udevadm trigger

  # Quick GPIO permission fix (one of the two should work)
  sudo chmod 777 /dev/gpiochip4
  sudo chmod 777 /dev/gpiochip0

  # Set up config files
  sudo ln -s config/local/chrony.conf /etc/chrony/chrony.conf
  sudo ln -s config/local/.tmux.conf ~/.tmux.conf

  # Copy repos from GitHub
  git clone https://github.com/BYU-FRoSt-Lab/cougars-ros2.git
  git clone https://github.com/BYU-FRoSt-Lab/cougars-teensy.git
  git clone https://github.com/BYU-FRoSt-Lab/cougars-gpio.git

else

  printInfo "Setting up CoUGARs on a development machine"

  # Install dependencies
  sudo apt update
  sudo apt install -y vim tmux git

  # Set up volumes
  mkdir bag
  mkdir config
  cp -r templates/* config/

  # Set up config files
  sudo ln -s config/local/.tmux.conf ~/.tmux.conf

  # Copy repos from GitHub
  git clone git@github.com:BYU-FRoSt-Lab/cougars-ros2.git
  git clone git@github.com:BYU-FRoSt-Lab/cougars-teensy.git
  git clone git@github.com:BYU-FRoSt-Lab/cougars-gpio.git
  git clone git@github.com:BYU-FRoSt-Lab/cougars-docs.git
  git clone git@github.com:BYU-FRoSt-Lab/cougars_base_station.git

fi

current_dir=$(pwd)
source_file="$current_dir/config/bash_vars.sh"

# Ensure the config directory exists
mkdir -p "$current_dir/config"

if ! grep -q "export COUG_WORKSPACE_DIR=" "$source_file"; then
    echo "export COUG_WORKSPACE_DIR=\"$current_dir\"" >> "$source_file"
    printSuccess "Added export statement to $source_file"
else
    printInfo "Bash variable statement already exists in $source_file"
fi

# Append the source command to .bashrc
if ! grep -q "source $source_file" ~/.bashrc; then
    echo "source $source_file" >> ~/.bashrc
    printSuccess "Added CoUGARS workspace bash variables to .bashrc"
else
    printInfo "CoUGARS workspace bash variables already exists in .bashrc"
fi

printWarning "Make sure to update the vehicle-specific configuration files in "config" now"
