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

      # Start the tmux session
      tmux new-session -d -s cougars
      tmux split-window -h -t cougars
      tmux split-window -v -t cougars
      tmux select-pane -t cougars:0.0

      # Send commands to the tmux session
      tmux send-keys -t cougars:0.0 "bash compose.sh" ENTER
      tmux send-keys -t cougars:0.0 "clear" ENTER
      tmux send-keys -t cougars:0.1 "bash compose.sh" ENTER
      tmux send-keys -t cougars:0.1 "clear" ENTER
      tmux send-keys -t cougars:0.2 "bash compose.sh" ENTER
      tmux send-keys -t cougars:0.2 "clear" ENTER

      tmux send-keys -t cougars:0.0 "cd ~/ros2_ws" ENTER
      tmux send-keys -t cougars:0.0 "bash start.sh" # Don't start just yet
      tmux send-keys -t cougars:0.1 "cd ~/ros2_ws" ENTER
      tmux send-keys -t cougars:0.1 "bash record.sh" # Don't start just yet
      tmux send-keys -t cougars:0.2 "cd ~/config" ENTER
      tmux send-keys -t cougars:0.2 "cat vehicle_config.yaml" ENTER
      tmux send-keys -t cougars:0.2 "vim vehicle_config.yaml" # Don't start just yet

    else
      printInfo "Attaching to the tmux session..."
    fi

    # Attach to the tmux session
    tmux attach-session -t cougars
    ;;
esac
