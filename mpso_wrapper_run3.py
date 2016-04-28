#!/usr/bin/env python

#
# Last modified: 18 Apr 2016
# Author: Dhananjay Bhaskar <dbhaskar92@gmail.com>
# 

import re
import sys
import math
import time
import os.path
import matlab.engine

if (len(sys.argv) < 6):
	print 'mpso_wrapper.py is a wrapper for the MPSO algorithm'
	print 'Usage: python mpso_wrapper.py <instance_relname> <instance_specifics> <cutoff_time> <cutoff_length> ...'
	print '<seed> <params to be passed on>'
	sys.exit(1)
	
# Get parameters

instance_name = sys.argv[1]
inst_specifics = re.split(',',sys.argv[2])
cutoff_time = float(sys.argv[3])
cutoff_length = int(sys.argv[4])
seed = int(sys.argv[5])

c1 = c2 = rad = step = tmax = -1

for i in range(6,len(sys.argv)): 
	if sys.argv[i] == '-c1':
		c1 = float(sys.argv[i+1])
	if sys.argv[i] == '-c2':
		c2 = float(sys.argv[i+1])
	if sys.argv[i] == '-rad':
		rad = int(sys.argv[i+1])
	if sys.argv[i] == '-step':
		step = float(sys.argv[i+1])
	if sys.argv[i] == '-iter':
		tmax = int(sys.argv[i+1])
		
if (c1<0 or c2<0 or rad<0 or tmax<0 or step<0):
	print 'Error: Parameters not passed properly to wrapper script'
	sys.exit(1)
	
instance_specific_string = ','.join(map(str,inst_specifics))
seq=(instance_name,instance_specific_string,str(cutoff_time),str(cutoff_length),str(seed),str(c1),str(c2),str(rad),str(step),str(tmax))	

paramstring = ','.join(seq)
	
# Create command and output filename
filename = './paramils-output/mpso_run3_output_'+time.strftime("%Y%m%d-%H%M%S")+'.txt'
cmd = 'matlabdb /r "MPSO('+paramstring+')"'
if os.path.isfile(filename):
	print 'Error: Output file already exists'
	
[xmin,xmax,true_min,errgoal] = [float(inst_specifics[0]), float(inst_specifics[1]), float(inst_specifics[2]), float(inst_specifics[3])]

eng = matlab.engine.start_matlab()
res = eng.MPSO(instance_name,xmin,xmax,true_min,errgoal,filename,cutoff_time,cutoff_length,seed,c1,c2,rad,step,tmax,nargout=3)

if not(os.path.isfile(filename)):
	print 'Error: MATLAB did not create output file'
	
with open(filename) as f:
	last = None
	for last in (line for line in f if line.rstrip('\n')):
		pass

res = re.split(',',last)
print 'Result for ParamILS: '+res[0]+', '+str(res[1])+', '+str(res[2])+', '+str(res[3])+', '+str(res[4])
