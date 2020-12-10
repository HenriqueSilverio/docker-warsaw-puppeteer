#!/bin/bash -xe

/usr/bin/dpkg -D10 -i /w.deb
service warsaw restart

runuser -l user -c "DISPLAY=:20 /usr/bin/chromium-browser --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 --disable-dev-shm-usage --start-maximized"
