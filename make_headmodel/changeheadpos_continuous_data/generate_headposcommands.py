#!/usr/bin/python3

# columns are:
# Time    HLC0011 HLC0012 HLC0013 HLC0021 HLC0022 HLC0023 HLC0031 HLC0032 HLC0033 Na      Le      Re

import matplotlib
import os
import pylab
from pylab import *
import numpy

# Prompt user for input
subj = input("Enter the value for subj: ")

outlines = []

# Construct the data directory path based on user input
data_dir = '/rri_disks/eugenia/meltzer_lab/bilateral_squeeze/PROC/' + subj + '/'

# Specify the input file path
infilename = data_dir + 'bimanualsqueeze_grandDS.dat'

# Check if the specified file exists
if os.path.exists(infilename):
    # Load data from the file into a numpy array
    thisdat = numpy.loadtxt(infilename)

    # Calculate means for specific columns in the data
    nax = round((mean(thisdat[:, 1]) * 100), 4)
    nay = round((mean(thisdat[:, 2]) * 100), 4)
    naz = round((mean(thisdat[:, 3]) * 100), 4)
    lex = round((mean(thisdat[:, 4]) * 100), 4)
    ley = round((mean(thisdat[:, 5]) * 100), 4)
    lez = round((mean(thisdat[:, 6]) * 100), 4)
    rex = round((mean(thisdat[:, 7]) * 100), 4)
    rey = round((mean(thisdat[:, 8]) * 100), 4)
    rez = round((mean(thisdat[:, 9]) * 100), 4)
    
    # Create a string with the formatted output command
    outstr = ('changeHeadPos -na ' + str(nax) + ' ' + str(nay) + ' ' + str(naz) +
              ' -le ' + str(lex) + ' ' + str(ley) + ' ' + str(lez) +
              ' -re ' + str(rex) + ' ' + str(rey) + ' ' + str(rez) + ' bimanualsqueeze_grandDS.ds\n')
    # Append the output string to the list of outlines
    outlines.append(outstr)
    
    # Open a file for writing and write the list of outlines to the file
    outfile = open(data_dir + 'headposcommands.txt', 'w')
    outfile.writelines(outlines)
    outfile.close()
else:
    # Print a message if the specified file does not exist
    print(f"The file {infilename} does not exist.")
