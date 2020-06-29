#!/usr/bin/env bash
rm -f /tmp/.X0-lock
exec Xvfb :0 -screen 0, 640x480x16 &
exec php -S 0.0.0.0:80