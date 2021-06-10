#!/usr/bin/env python
# coding: utf-8
'''
This script is used to calculate compositional dissimilarity among
AEA regions and among N. American groups

'''

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import umap
import umap.plot
from sklearn.neighbors import DistanceMetric

from scipy.spatial.distance import pdist
import itertools
from math import radians

import seaborn as sns;




##### Functions Used
def sklearn_haversine(y, x):
    haversine = DistanceMetric.get_metric('haversine')
    latlon = np.hstack((y[:, np.newaxis], x[:, np.newaxis]))
    dists = haversine.pairwise(latlon)
    return 6371*dists #6371 is for distances in kms


# ### American Only: Whole genome sequenced
# Painted with 325 palette genomes



df = pd.read_csv("./nAmPaintingOutput/review_merged.bi.lmiss90.ed.allChrs.bgl.AmericansWithNativeInds.allInds.region15.PCAInput.txt", sep = "\t")




data = df.drop(['newGroup','Recipient', 'newGroupReNamed'], axis = 1).values
dAm = pd.DataFrame(itertools.combinations(df['Recipient'],2), columns= ['i','j'])
dAm[['groupA','groupB']]= list(itertools.combinations(df['newGroupReNamed'],2))
dAm['dist']=pdist(data,'braycurtis')
dAm['dataset'] = "nAm"



# ### 1001 genomes : ~661 genomes painted with 325 palette genomes


df = pd.read_csv("./AEAPaintingOutput/review_merged.bi.lmiss90.ed.allChrs.bgl.restFsWithNativeRegion15Inds.allInds.PCAInput.txt", sep = "\t")
data = df.drop(['Recipient','fsSub', 'region'], axis =1).values
pop = pd.DataFrame(itertools.combinations(df['region'],2), columns = ['groupA','groupB'])
dBrayCurtis = pd.DataFrame(itertools.combinations(df['Recipient'],2),columns=['i','j'])
dBrayCurtis[['groupA','groupB']]= list(itertools.combinations(df['region'],2))
dBrayCurtis['dist'] = pdist(data, 'braycurtis')
dBrayCurtis['dataset']= "1001"



#Concatenate two dataframes
nAm_1001ConcatDist = pd.concat([dAm, dBrayCurtis], axis=0)

## Read GPS data for all the accessions

df_gps = pd.read_csv("allAccessions_GPS_forBioclim.txt", sep = "\t", index_col=0)
##convert GPS coordinates in radians
allLatRad = np.array([radians(_) for _ in df_gps['latitude']])
allLonRad = np.array([radians(_) for _ in df_gps['longitude']])

#Calculate distance matrix (haversine)
distMat = sklearn_haversine(allLatRad, allLonRad)


# #### **add index to distMat**

i_distMat = pd.DataFrame(distMat, index=df_gps.index, columns=df_gps.index)

# convert from long to tall format
i_distMat = i_distMat.stack().rename_axis(('i','j')).reset_index(name = "kms")


# Merge geographic distance with the braycurtis dataframe
nAm_1001Concat_BrayCurtis_Kms = nAm_1001ConcatDist.merge(i_distMat, on =["i","j"])


#Save to a txt file
nAm_1001Concat_BrayCurtis_Kms.to_csv("nAm_1001.PaintedBrayCurtisVGeoDist.txt", sep ="\t", index = None, float_format="%.3f")


#groupby haplogroups and average
nAm_1001Concat_BrayCurtis_KmsMean = nAm_1001Concat_BrayCurtis_Kms.groupby(['groupA','groupB', 'dataset']).mean().reset_index()


#save to txt file
nAm_1001Concat_BrayCurtis_KmsMean.to_csv("nAm_1001.PaintedBrayCurtisVGeoDistMean.txt", sep ="\t", index = None, float_format="%.3f")

# outputs were plotted using R (ggplot)


