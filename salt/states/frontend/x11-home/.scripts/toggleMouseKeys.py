#!/usr/bin/env python2

# Imports
import subprocess
import os

# Run "xkbset q" for info
xkbsetProc = subprocess.Popen(["xkbset", "q"], stdout=subprocess.PIPE)
(out, err) = xkbsetProc.communicate()

# No Errors
if err is None:
	# if Mose Keys is enabled
	if "Mouse-Keys = On" in out:
		# Disable
		os.system("xkbset -m")
	else:
		# Enable
		os.system("xkbset m; xkbset exp '=m'")
