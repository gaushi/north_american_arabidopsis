#!/ebio/abt6/gshirsekar/anaconda3/bin/python
#/usr/bin/env python
# coding: utf-8

#############Usage Example ##############################
# ./regionMeans.py -i regionChunkfile -c chrN -o outputRegionAverage.txt
import sys
import os
import csv
import pandas as pd
import numpy as np

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--input', '-i', help="input file in region chunk length format", type= str)
parser.add_argument('--chr', '-c', help="number of chromosome", type= int, default= 0)
parser.add_argument('--output', '-o', help="path to output file", type=str)
print(parser.format_help())
# usage: ./regionMeans.py -i regionChunkfile -c chrN -o outputRegionAverage.txt
#
# optional arguments:
#   -h, --help         show this help message and exit
#   --input STR, -i STR  input file in region chunk length format (.txt)
#   --chr INT, -c INT  number of chromosome
#   --output STR -o STR output file path

args = parser.parse_args("--foo pouet".split())
print(args)  # Namespace(bar=0, foo='pouet')
print(args.input) # pouet
print(args.chr) # 0
print(args.output)

#cmdargs=str(sys.argv)
#print (cmdargs)
#chunkfile = str(sys.argv[2])
#chr= int(sys.argv[4])
#outfile=str(sys.argv[6])
#print ("region file is: " +str(chunkfile))
#print ("chromosome : "+ str(chrN))
#print ("output will be saved in: " +str(outfile))


##read all regions and their mean chunk length 
#meanCLength = "chr"+ str(chr)+ "_meanCLength" 
colnames=['region', meanCLength] 
cLength = pd.read_csv(chunkfile, sep="\t", header=None , skipinitialspace=True, names = colnames)

#take average of region

regionMean =cLength.groupby('region').mean()

#outfile = "testRegionMean2.txt"
regionMean.to_csv(outfile, sep="\t")

