#!/usr/bin/env python2

# Imports
import subprocess
import os

# Timeout

# Run "cat /proc/acpi/bbswitch" for info
xsetProc = subprocess.Popen(["cat", "/proc/acpi/bbswitch"], stdout=subprocess.PIPE)
(out, err) = xsetProc.communicate()

# No Errors
if err is None:
    # if Graphics On
    if " ON" in out:
        # Turn Off
        os.system("sudo modprobe -r nvidia; sudo tee /proc/acpi/bbswitch <<<OFF > /dev/null")
    else:
        # Turn On
        os.system("sudo tee /proc/acpi/bbswitch <<<ON > /dev/null; sudo modprobe nvidia")
else:
    print "[Graphics-Toggle]:ERROR:", err
