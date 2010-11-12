#!/usr/bin/python

# Gstreamer 0.10 file converter
import sys, os
import pygst
import gst

filesrc = sys.argv[1:]

def __init__(self):
	self.converter = gst.Pipeline("converter")
	source = gst.element_factory_make("filesrc", "file-source")
	decode = gst.element_factory_make("decodebin", "decode")
	self.decode = gst.element_factory_make("wavenc", "wave-enc")
	audioconv = gst.element_factory_make("audioconvert", "converter")
	filesink = gst.element_factory_make("filesink", "file-output")
	
	self.converter.add(source, decode, self.decode, audioconv, filesink)
	gst.element_link_many(source, decode)
	gst.element_link_many(self.decode, audioconv, filesink)
		
	filepath = self.entry.get_text()
	if os.path.isfile(filepath):
		self.player.get_by_name("file-source").set_property("location", filepath)
		self.player.set_state(gst.STATE_PLAYING)
	else:
		self.player.set_state(gst.STATE_NULL)
		self.button.set_label("Start")
	

#converter = gst.parse_launch("filesrc location=test.mp3 ! decodebin ! audioconvert ! audio/x-raw-int,channels=1 ! wavenc ! filesink location=test.wav")
#converter.set_state(gst.STATE_PLAYING)
