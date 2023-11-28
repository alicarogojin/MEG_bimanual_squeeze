#! /usr/bin/python
"""
usage: python make_epoch_times_1sec.py evtfile outputfilename

This script is used to generate a .prn file to feed to the addMarkers program.
It reads in an evt file with markers, and generates new times at 1 second intervals based on those markers.

"""
# Single block:
# Block start (250 ms), Ready trial (750 ms), Rest trial (20,000 ms), Block end (20 ms) = 21,020 ms
# Total rest times = 21 (every 1 second)
begintimes = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]

import sys, os, re
import numpy as npy

if len(sys.argv) != 3:
	print >> sys.stderr, "usage: %s-file evtfile outputfilename" % sys.argv[0]
	sys.exit(1)

#testing without arg input
#evt_filename = 'leftSlow_epoch_begintimes.evt'
#output_filename = 'leftSlow_1sec_times.prn'

evt_filename = sys.argv[1]
output_filename = sys.argv[2]


# Make sure the files exist.

try:
	os.stat(evt_filename)
except OSError as msg:
	print >> sys.stderr, "%s: %s" % (sys.argv[0], msg)
	sys.exit(1)

inlines = open(evt_filename).readlines()[1:]
outtimes = []
for line in inlines:
	vals = line.split()
	synctime = float(vals[1])
	thesetimes = map(lambda x: x + synctime, begintimes)
	outtimes = outtimes + list(thesetimes)

outlines = []
for time in outtimes:
	outlines.append('0\t'+str(time)+'\n')


outfile = open(output_filename,'w')
outfile.writelines(outlines)
outfile.close()
