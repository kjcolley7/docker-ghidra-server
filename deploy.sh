#!/bin/sh

# Remove (and stop if running) the docker container
docker rm -f ghidra-server 2>/dev/null

# Run the docker container, mounting the repos directory, the timezone file, and mapping server ports
docker run -itd --name ghidra-server -v $(pwd)/repos:/repos -p 13100:13100 -p 13101:13101 -p 13102:13102 kjcolley7/ghidra-server

# Enter interactive user adding interface
python addUsers.py
