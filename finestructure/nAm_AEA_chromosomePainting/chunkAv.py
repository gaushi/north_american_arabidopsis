#!/ebio/abt6/gshirsekar/anaconda3/bin/python


# coding: utf-8


#############Usage Example ##############################
# ./chunkAv.py -c chunkfile -h hNo -i individualList.txt -o outputChunkAverage.txt
##############libraries needed############
import sys
import os
import csv
import pandas as pd
import numpy as np
#import seaborn as sns  # if plotting
#import matplotlib.pyplot as plt # if plotting

###############Command line Arguments ###########################
cmdargs=str(sys.argv)
print (cmdargs)
chunkfile = str(sys.argv[2])
hNo = (sys.argv[4])
infile=str(sys.argv[6])
outfile=str(sys.argv[8])
print ("chunk file is: " +str(chunkfile))
print ("header starts at on line: "+ str(hNo))
print ("input file is: " +str(infile))
print ("output will be saved in: " +str(outfile))



#read all the chunklength or chunkcount file
#chunkfile = "merged.bi.lmiss90.ed.allChr.bgl.AmericansWithNativeInds.allInds.painting.chunkcounts.out"
cLength = pd.read_csv(chunkfile, sep=" ", header=int(hNo) , skipinitialspace=True)

#get the list of individuals belonging to a haplogroup
#infile = "newGroup3.txt"
lines= np.genfromtxt(infile, dtype='str')
indsArray= lines.tolist()

#subset based on the haplogroup
newGroup3Colored = cLength.loc[cLength["Recipient"].isin(indsArray)]
#newGroup3Colored2 = newGroup3Colored.set_index('Recipient')
#print(newGroup3Colored.columns.tolist())
#sns.boxplot(x="variable", y="value", data=pd.melt(newGroup3Colored))
columnsAverage = newGroup3Colored.mean(axis=0)
#outfile= "newGroup3.test.txt"
columnsAverage.to_csv(outfile, sep="\t")
