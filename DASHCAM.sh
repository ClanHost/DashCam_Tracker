#!/bin/bash
ffmpeg -f alsa -channels 1 -i hw:3,0 -framerate 30 -video_size 800x600 -i /dev/video0 -vf \
"drawtext=fontfile=/hom/pi/font.ttf:textfile=/home/pi/SPEED.dashcam:reload=1:fontcolor=white:fontsize=24:box=1:boxcolor=black@0.5:boxborderw=5:x=10:y=h-th-10, \
drawtext=fontfile=/hom/pi/font.ttf:textfile=/home/pi/LOCATION.dashcam:reload=1:fontcolor=white:fontsize=24:box=1:boxcolor=black@0.5:boxborderw=5:x=10:y=10, \
drawtext=fontfile=/hom/pi/font.ttf:textfile=/home/pi/DATE.dashcam:reload=1:fontcolor=white:fontsize=24:box=1:boxcolor=black@0.5:boxborderw=5:x=w-tw-10:y=10" \
-input_format h264 -preset ultrafast -shortest -y -segment_time 05:00.000 -f segment -strftime 1 "/home/pi/DASHCAM/%Y-%m-%d_%H-%M-%S.mp4"
