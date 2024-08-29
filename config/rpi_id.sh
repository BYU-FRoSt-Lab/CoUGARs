#!/bin/bash

##########################################################
# static ip address of Pi
##########################################################

# run (ifconfig eth0 | grep 'inet ' | awk '{print $2}'), and then put that number 
# for 1 it is 192.168.194.59
STATIC_IP=192.168.194.59

