#!/bin/sh
if [ $@ -ne $1 $2 ]; then echo "Gstreamer-base Audio Converter ANY-TO-WAV\nUsage: $0 arq1.ANY arq2.wav"; return 1; fi 
gst-launch-0.10 filesrc location=$1 ! decodebin ! audioresample ! audio/x-raw-int, rate=8000 ! audioconvert ! audio/x-raw-int,channels=1,width=16,depth=16 ! wavenc ! filesink location=$2
