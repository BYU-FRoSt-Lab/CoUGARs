#!/bin/bash

##########################################################
# SETS THE NECESSARY CONFIG PARAMS
##########################################################

DEPTH_KP=0.0
DEPTH_KI=0.0
DEPTH_KD=0.0
DEPTH_MIN_OUTPUT=0
DEPTH_MAX_OUTPUT=0
DEPTH_BIAS=0

HEADING_KP=0.0
HEADING_KI=0.0
HEADING_KD=0.0
HEADING_MIN_OUTPUT=0
HEADING_MAX_OUTPUT=0
HEADING_BIAS=0

VELOCITY_KP=0.0
VELOCITY_KI=0.0
VELOCITY_KD=0.0
VELOCITY_MIN_OUTPUT=0
VELOCITY_MAX_OUTPUT=0
VELOCITY_BIAS=0

cd ~/ros2_ws
source install/setup.bash

ros2 topic pub --once /calibration frost_interfaces/msg/Calibration "{depth_kp: $DEPTH_KP, depth_ki: $DEPTH_KI, depth_kd: $DEPTH_KD, depth_min_output: $DEPTH_MIN_OUTPUT, depth_max_output: $DEPTH_MAX_OUTPUT, depth_bias: $DEPTH_BIAS, heading_kp: $HEADING_KP, heading_ki: $HEADING_KI, heading_kd: $HEADING_KD, heading_min_output: $HEADING_MIN_OUTPUT, heading_max_output: $HEADING_MAX_OUTPUT, heading_bias: $HEADING_BIAS, velocity_kp: $VELOCITY_KP, velocity_ki: $VELOCITY_KI, velocity_kd: $VELOCITY_KD, velocity_min_output: $VELOCITY_MIN_OUTPUT, velocity_max_output: $VELOCITY_MAX_OUTPUT, velocity_bias: $VELOCITY_BIAS}"

# TODO: Add ROS params as necessary, maybe vehicle ID?