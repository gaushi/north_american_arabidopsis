#!/ebio/abt6/gshirsekar/anaconda3/bin/python
# coding: utf-8

#############Usage Example ##############################
# ./normalizeChunks.py -i regionChunkfile -c chrN -o outputRegionAverage.txt
import sys
import os
import csv
import pandas as pd
import numpy as np
import argparse


parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input",dest="input",metavar="FILE", help="input file in region chunk length format")
parser.add_argument('--chr', '-c', help="number of chromosome", type=int)
parser.add_argument("-o", "--output", dest="output", metavar="FILE", help="path to output file")
print(parser.format_help())

args = parser.parse_args()
print(args)  # Namespace(bar=0, foo='input.txt')
print(args.input) # input.txt
print(args.chr) # 0
print(args.output)



colnames=['cluster', 'cCount', 'chrs'] 
cLength = pd.read_csv(input, sep="\t", header=None , skipinitialspace=True, names = colnames)
newColNormalized = ("chr" + str(chr)+ "_cCountNormalized")
cLength[newColNormalized] = np.where(cLength['chrs'] < 1, cLength['chrs'], cLength['cCount']/cLength['chrs'])
cLength.to_csv(output, sep="\t", index = False)
