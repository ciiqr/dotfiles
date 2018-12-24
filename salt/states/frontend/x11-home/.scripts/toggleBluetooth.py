#!/usr/bin/env python2

# Imports
import subprocess
import os

# Functions
def kill_python_script(scriptName):
	output = subprocess.check_output("ps -elf | grep python | grep " + scriptName + " | grep -v sh", shell=True)
	pid = output.split()[3]
	os.system("kill -9 " + pid)

# Timeout

# Run "sudo hciconfig hci0" for info
xsetProc = subprocess.Popen(["sudo", "hciconfig", "hci0"], stdout=subprocess.PIPE)
(out, err) = xsetProc.communicate()

# No Errors
if err is None:
	# if bluetooth off
	if "DOWN" in out:
		# turn on
		os.system("sudo rfkill unblock bluetooth")
		os.system("sudo hciconfig hci0 up")
		os.system("sudo systemctl start bluetooth")
		os.system("blueman-applet")
	else:
		# turn off
		kill_python_script("blueman-applet")
		os.system("sudo hciconfig hci0 down")
		os.system("sudo rfkill block bluetooth")
		os.system("sudo systemctl stop bluetooth")
		
else:
	print "[Bluetooth-Toggle]:ERROR:", err



## TODO: Testing 
# print type(subprocess.check_output("ps -elf | grep python | grep blueman-applet"))
# output = subprocess.check_output("/usr/bin/ps -elf | /usr/bin/grep python | /usr/bin/grep blueman-applet", shell=True))
# output = output.splitlines()[1] # Assumes that the first will be this command
