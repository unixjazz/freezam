#!/bin/bash
if [ $@ -ne $1 $2 ]; then echo "Gstreamer-base Audio Converter ANY-TO-WAV\nUsage: $0 arq1.ANY arq2.wav"; return 1; fi 
#gst-launch-1.0 filesrc location=$1 ! audioconvert ! 'audio/x-raw, rate=8000, format=S16LE, channels=1' ! wavenc ! filesink location=$2

# temp
mplayer -ao pcm:file=$2 -srate 8000 $1 
