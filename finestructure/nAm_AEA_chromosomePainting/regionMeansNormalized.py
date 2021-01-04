#!/ebio/abt6/gshirsekar/anaconda3/bin/python
# coding: utf-8

# Usage: ./regionMeansNormalized.py -i input.txt -o output.txt


import sys
import os
import csv
import pandas as pd
import numpy as np

cmdargs=str(sys.argv)
print(cmdargs)
chunkfile = str(sys.argv[2])
outfile = str(sys.argv[4])

cLength = pd.read_csv(chunkfile, sep="\t", header=0 , skipinitialspace=True)
#cLength.head()
regionMean =cLength.groupby('cluster').mean()
#regionMean
regionMean.to_csv(outfile, sep="\t")
