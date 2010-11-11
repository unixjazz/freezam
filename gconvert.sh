#!/bin/sh
if [ $@ -ne 2 ]; then echo "Gstreamer-base Audio Converter ANY-TO-WAV, usage: $0 arq1.ANY arq2.wav"; return 1; fi 
gst-launch-0.10 filesrc location=$1 ! decodebin ! audioconvert ! audio/x-raw-int,channels=1 ! wavenc ! filesink location=$2
