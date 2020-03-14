#!/usr/bin/env python2

# Imports
import subprocess
import os

# Timeout

# Run "rfkill list wifi" for info
xsetProc = subprocess.Popen(["rfkill", "list", "wifi"], stdout=subprocess.PIPE)
(out, err) = xsetProc.communicate()

# No Errors
if err is None:
    # if wifi blocked
    if "blocked: yes" in out:
        # unblock
        os.system("rfkill unblock wifi")
    else:
        # block
        os.system("rfkill block wifi")
else:
    print "[WIFI-Toggle]:ERROR:", err
