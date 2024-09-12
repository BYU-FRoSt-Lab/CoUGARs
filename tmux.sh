#!/bin/bash

##########################################################
# STARTS (OR ENTERS A RUNNING) TMUX SESSION
# - Use "bash tmux.sh kill" to kill the session
##########################################################

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
        echo ""
        printInfo "Killing the tmux session..."
        echo ""

        tmux kill-session -t cougars
        ;;
    *)
        echo ""
        printInfo "Starting or entering the tmux session..."
        echo ""

        tmux new-session -A -s cougars
        ;;
esac
