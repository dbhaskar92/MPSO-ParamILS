#!/usr/bin/env python

import glob
import os

path = "./mpso_run2_output_*.txt"

ofname = "./output_run2_log.txt"

if os.path.isfile(ofname):
	print 'Error: Output file already exists'

ofile = open(ofname,'w')

file_list = glob.glob(path)
file_list.sort(key=os.path.getmtime)

for fname in file_list:

	fd = os.path.basename(fname)
	ofile.write(fname+"\n")
	
	with open(fd) as ifile:
		for line in ifile:
			ofile.write(line)
			
	ofile.write("\n\n")
	
	os.remove(fname)
	
ofile.close()
