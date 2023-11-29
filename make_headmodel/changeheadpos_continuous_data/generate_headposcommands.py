#!/usr/bin/python3

# columns are:
# Time    HLC0011 HLC0012 HLC0013 HLC0021 HLC0022 HLC0023 HLC0031 HLC0032 HLC0033 Na      Le      Re

import matplotlib
import os
import pylab
from pylab import *
import numpy

outlines = []
data_dir = '/rri_disks/eugenia/meltzer_lab/wenjing_backup/picture_naming/data/proc/14567/'
runs = ['PWI', 'overt', 'beginMatch']
for run in runs:
    infilename = data_dir + '/pic_onset_' + run + '.dat'
    thisdat = numpy.loadtxt(infilename)
    nax = round((mean(thisdat[:,1])*100),4)
    nay = round((mean(thisdat[:,2])*100),4)
    naz = round((mean(thisdat[:,3])*100),4)
    lex = round((mean(thisdat[:,4])*100),4)
    ley = round((mean(thisdat[:,5])*100),4)
    lez = round((mean(thisdat[:,6])*100),4)
    rex = round((mean(thisdat[:,7])*100),4)
    rey = round((mean(thisdat[:,8])*100),4)
    rez = round((mean(thisdat[:,9])*100),4)    
    outstr = ('changeHeadPos -na ' + str(nax) + ' ' + str(nay) + ' ' + str(naz) 
        + ' -le ' + str(lex) + ' ' + str(ley) + ' ' + str(lez)
        + ' -re ' + str(rex) + ' ' + str(rey) + ' ' + str(rez) + ' pic_onset_' + str(run) + '.ds\n')
    outlines.append(outstr)

outfile = open(data_dir + 'headposcommands.txt','w')
outfile.writelines(outlines)
outfile.close()
