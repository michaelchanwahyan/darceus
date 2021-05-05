#!/bin/sh
clear
docker rm -f sleepy_arceus
export TZ=Asia/Hong_Kong
mem=$(free -g | head -2 | tail -1 | awk -F " " '{print $2}') # if you run to error, set mem to your system memory (in GB unit)
target_mem=$(echo "$mem * 0.9" | bc) # if you run to error, install bc
docker run -dt \
           --name=sleepy_arceus \
           --memory="$target_mem"g \
           -v /data:/data \
           -v /app:/app \
           darceus:latest \
           /bin/bash
