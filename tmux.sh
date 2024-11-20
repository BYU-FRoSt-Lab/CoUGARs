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
      tmux split-window -v -t cougars
      tmux select-pane -t cougars:0.2
      tmux split-window -h -t cougars
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
      # tmux send-keys -t cougars:0.4 "bash compose.sh" ENTER
      # tmux send-keys -t cougars:0.4 "clear" ENTER
      

      

      # 
      tmux send-keys -t cougars:0.0 "cd ~/gpio" ENTER
      tmux send-keys -t cougars:0.0 "bash permission_fix.sh" ENTER
      tmux send-keys -t cougars:0.0 "cd ~/ros2_ws/dvl_tools" ENTER
      tmux send-keys -t cougars:0.0 "bash calibrate_gyro.sh" ENTER
      tmux send-keys -t cougars:0.0 "cd ~/ros2_ws" ENTER
      tmux send-keys -t cougars:0.0 "colcon build" ENTER
      tmux send-keys -t cougars:0.0 "sudo systemctl restart chrony" ENTER #correct spot to put this?
      tmux send-keys -t cougars:0.0 "date" ENTER
      tmux send-keys -t cougars:0.0 "ls" ENTER
      tmux send-keys -t cougars:0.0 "bash launch.sh <put param here>" # Don't start just yet

      tmux send-keys -t cougars:0.1 "cd ~/ros2_ws" ENTER
      tmux send-keys -t cougars:0.1 "colcon build" ENTER
      tmux send-keys -t cougars:0.1 "cd ~/ros2_ws/moos_tools" ENTER
      tmux send-keys -t cougars:0.1 "bash mission_deploy.sh" # is this the best place for mission_deploy?
      tmux send-keys -t cougars:0.1 "bash test.sh <put param here>" # Don't start just yet

      tmux send-keys -t cougars:0.2 "cd ~/ros2_ws" ENTER
      tmux send-keys -t cougars:0.2 "colcon build" ENTER
      tmux send-keys -t cougars:0.2 "bash record.sh" # Don't start just yet

      tmux send-keys -t cougars:0.3 "cd ~/config" ENTER
      tmux send-keys -t cougars:0.3 "cat vehicle_params.yaml" ENTER

      # tmux send-keys -t cougars:0.4 "cd ~/ros2_ws/moos_tools" ENTER
      # tmux send-keys -t cougars:0.4 "bash mission_start.sh" # Don't start just yet
      tmux new-window -t cougars -n moos_mission_start 'bash ~/ros2_ws/moos_tools/mission_start.sh' # New window or split terminal again?

    else
      printInfo "Attaching to the tmux session..."
    fi

    # Attach to the tmux session
    tmux attach-session -t cougars
    ;;
esac


#TODO: - figure out how to edit vehicle_params and moos.bhv for the mission
#      - add in the mission_deploy.sh the pAntler timeout command
#      - check with Braden, and Nelson to see if everything else is good to go
#      - how to implement plot juggler
#      - see if any other commands need to be added to the tmux script from new map waypoint stuff