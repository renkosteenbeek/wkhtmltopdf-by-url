#!/usr/bin/env bash
exec Xvfb :0 -screen 0, 640x480x16 &
exec php -S 0.0.0.0:80