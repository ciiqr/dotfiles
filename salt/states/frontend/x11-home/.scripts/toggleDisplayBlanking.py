#!/usr/bin/env python2

# Imports
import subprocess
import os

# Timeout
# SCREEN_TIMEOUT=10

# Run "xset q" for info
xsetProc = subprocess.Popen(["xset", "q"], stdout=subprocess.PIPE)
(out, err) = xsetProc.communicate()

# No Errors
if err is None:
    # if DPMS is enabled
    if "DPMS is Enabled" in out:
        # Disable
        os.system("xset -dpms; xset s off")
    else:
        # Enable
        os.system("xset dpms; xset s on")#; xset s " + str(SCREEN_TIMEOUT))
        # Turn Off
        os.system("xset dpms force off")
