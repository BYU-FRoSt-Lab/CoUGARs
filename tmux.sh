#!/bin/bash
# Created by Nelson Durrant, Sep 2024
#
# Starts or enters the tmux session
# - Use 'bash tmux.sh kill' to kill the session

function printInfo {
  echo -e "\033[0m\033[36m[INFO] $1\033[0m"
}

function printWarning {
  echo -e "\033[0m\033[33m[WARNING] $1\033[0m"
}

function printError {
  echo -e "\033[0m\033[31m[ERROR] $1\033[0m"
}

case $1 in
  "kill")
    printWarning "Killing the tmux session..."
    tmux kill-session -t cougars
    ;;
  *)
    # Check if the tmux session is already running
    if [ -z "$(tmux list-sessions | grep cougars)" ]; then

      printInfo "Starting the tmux session..."

      ### FIRST WINDOW - ROS SCRIPTS ###

      # Start the tmux session
      tmux new-session -d -s cougars
      tmux split-window -h -t cougars
      tmux split-window -v -t cougars
      tmux select-pane -t cougars:0.0
      tmux split-window -v -t cougars
      tmux select-pane -t cougars:0.0

      # Send commands to the tmux session
      tmux send-keys -t cougars:0.0 "bash compose.sh" ENTER
      tmux send-keys -t cougars:0.0 "clear" ENTER
      tmux send-keys -t cougars:0.1 "bash compose.sh" ENTER
      tmux send-keys -t cougars:0.1 "clear" ENTER
      tmux send-keys -t cougars:0.2 "bash compose.sh" ENTER
      tmux send-keys -t cougars:0.2 "clear" ENTER
      tmux send-keys -t cougars:0.3 "bash compose.sh" ENTER
      tmux send-keys -t cougars:0.3 "clear" ENTER

      tmux send-keys -t cougars:0.0 "sudo systemctl restart chrony" ENTER 
      tmux send-keys -t cougars:0.0 "date" ENTER
      tmux send-keys -t cougars:0.0 "bash launch.sh <mission_type>" # Don't start just yet

      tmux send-keys -t cougars:0.1 "cd ~/ros2_ws" ENTER
      tmux send-keys -t cougars:0.1 "bash test.sh <acoustics>" # Don't start just yet

      tmux send-keys -t cougars:0.2 "cd ~/ros2_ws" ENTER
      tmux send-keys -t cougars:0.2 "bash record.sh <acoustics>" # Don't start just yet

      tmux send-keys -t cougars:0.3 "cd ~/config" ENTER
      tmux send-keys -t cougars:0.3 "cat vehicle_params.yaml" ENTER

      ### SECOND WINDOW - MOOS SCRIPTS ###

      tmux new-window -n "moos" # New window or split terminal again?
      tmux split-window -v -t moos
      tmux select-pane -t moos:0.1
      tmux split-window -h -t moos
      tmux send-keys -t moos:0.1 "bash ~/ros2_ws/moos_tools/mission_deploy.sh" ENTER
      tmux send-keys -t moos:0.1 "cat ~/ros2_ws/moos_tools/coug.bhv" ENTER
      tmux send-keys -t moos:0.2 "pAntler timeout 5 <command>" # Don't start just yet

      # TODO: Add more terminals, etc
      # I bet Matthew has some good ideas
tmux new-window -n "My New Window"

    else
      printInfo "Attaching to the tmux session..."
    fi

    # Attach to the tmux session
    tmux attach-session -t cougars
    ;;
esac

# I added some comments -Nelson

#TODO: - figure out how to edit vehicle_params and moos.bhv for the mission (I think just cat the file so we can see it in the terminal, and we can change it using vim if needed)
#      - add in the mission_deploy.sh the pAntler timeout command ('timeout 5 <command>' should work -- number is in seconds)
#      - check with Braden, and Nelson to see if everything else is good to go
#      - how to implement plot juggler
#      - see if any other commands need to be added to the tmux script from new map waypoint stuff