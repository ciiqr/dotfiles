## IMPORTS ##
#############
# Standard Imports
import os, sys, time
import logging
import math

math.tau = math.pi * 2.0

# Disable Non-critical Logging
#logging.basicConfig(level=100)

# Gtk & Related Tools
try:
	import gi
	gi.require_version('Gtk', '3.0')
	gi.require_version('Gst', '1.0')
	from gi.repository import Gtk, Gdk, GObject, Gst
except ValueError as e:
	pass

# Re-Enable Normal Logging
#logging.basicConfig(level=logging.WARNING)

# Change Prompts
sys.ps1 = "> "
sys.ps2 = ". "

# Function to List items of object that match the signature
def dir_match(object, match):
	# Each Item in Object
	for item in dir(object):
		# Check that item matches
		if item.lower().find(match) != -1:
			# Print Item
			print(item)

# Unicode
def codepointToUTF8Hex(codepoint):
	return unichr(int(codepoint, 16)).encode('utf-8')
