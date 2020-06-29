#!/bin/bash

# if there is a zombie process, then most likely a process is crashed
ZOMBIES=$(ps aux | awk {'print $8'} | grep -c Z)

if [[ "$ZOMBIES" > 0 ]]; then
  exit 1;
else
  exit 0;
fi;