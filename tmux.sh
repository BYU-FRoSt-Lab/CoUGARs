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
      tmux new-session -d -s cougars -n "ros2"
      tmux split-window -h -t cougars
      tmux split-window -v -t cougars
      tmux select-pane -t cougars:ros2.0
      tmux split-window -v -t cougars
      tmux select-pane -t cougars:ros2.0

      # Send commands to the tmux session
      tmux send-keys -t cougars:ros2.0 "bash compose.sh" ENTER
      tmux send-keys -t cougars:ros2.1 "bash compose.sh" ENTER
      tmux send-keys -t cougars:ros2.2 "bash compose.sh" ENTER
      tmux send-keys -t cougars:ros2.3 "bash compose.sh" ENTER

      tmux send-keys -t cougars:ros2.0 "cd ~/ros2_ws" ENTER
      tmux send-keys -t cougars:ros2.0 "clear" ENTER
      tmux send-keys -t cougars:ros2.0 "bash launch.sh <mission_type>" # Don't start just yet

      tmux send-keys -t cougars:ros2.1 "cd ~/ros2_ws" ENTER
      tmux send-keys -t cougars:ros2.1 "clear" ENTER
      tmux send-keys -t cougars:ros2.1 "bash test.sh <acoustics>" # Don't start just yet

      tmux send-keys -t cougars:ros2.2 "cd ~/ros2_ws" ENTER
      tmux send-keys -t cougars:ros2.2 "clear" ENTER
      tmux send-keys -t cougars:ros2.2 "bash record.sh <acoustics>" # Don't start just yet

      tmux send-keys -t cougars:ros2.3 "cd ~/config" ENTER
      tmux send-keys -t cougars:ros2.3 "clear" ENTER
      tmux send-keys -t cougars:ros2.3 "cat vehicle_params.yaml" ENTER

      ### SECOND WINDOW - MOOS SCRIPTS ###

      tmux new-window -t cougars -n "moos"
      tmux split-window -h -t cougars:moos
      tmux split-window -v -t cougars:moos
      tmux select-pane -t cougars:moos.0
      tmux split-window -v -t cougars:moos.0
      tmux select-pane -t cougars:moos.0

      tmux send-keys -t cougars:moos.0 "bash compose.sh" ENTER
      tmux send-keys -t cougars:moos.1 "bash compose.sh" ENTER
      tmux send-keys -t cougars:moos.3 "bash compose.sh" ENTER
      
      tmux send-keys -t cougars:moos.0 "cd ~/ros2_ws/moos_tools" ENTER
      tmux send-keys -t cougars:moos.0 "clear" ENTER
      tmux send-keys -t cougars:moos.0 "timeout 120s bash mission_start.sh" # Don't start just yet

      tmux send-keys -t cougars:moos.1 "cd ~/ros2_ws/moos_tools" ENTER
      tmux send-keys -t cougars:moos.1 "clear" ENTER
      tmux send-keys -t cougars:moos.1 "bash mission_deploy.sh" # Don't start just yet

      tmux send-keys -t cougars:moos.2 "echo 'frostlab' | sudo -S systemctl restart chrony" ENTER
      tmux send-keys -t cougars:moos.2 "date" ENTER
      tmux send-keys -t cougars:moos.2 "cgps" ENTER

      tmux send-keys -t cougars:moos.3 "cd ~/ros2_ws/moos_tools" ENTER
      tmux send-keys -t cougars:moos.3 "clear" ENTER
      tmux send-keys -t cougars:moos.3 "cat coug.bhv" ENTER

    else
      printInfo "Attaching to the tmux session..."
    fi

    # Attach to the tmux session
    tmux attach-session -t cougars
    ;;
esac
