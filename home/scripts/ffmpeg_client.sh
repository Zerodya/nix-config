#!/bin/sh

# Load PulseAudio module
pactl unload-module module-null-sink
pactl load-module module-null-sink sink_name=remote

# Start the ffmpeg client
killall ffmpeg
ffmpeg -f pulse -i "remote.monitor" -ac 2 -acodec libmp3lame -ar 44100 -ab 128000 -f rtp rtp://192.168.1.28:1730
