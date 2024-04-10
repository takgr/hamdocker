#!/bin/bash
export LANG=en_US.UTF-8
export DISPLAY=:20
Xvfb :20 -screen 0 1800x1200x16 &
fluxbox &
x11vnc -passwd changeme -display :20 -N -forever &
cd /jtdx/bin
./jtdx
