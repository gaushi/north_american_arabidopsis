#!/usr/bin/env python
# coding: utf-8
'''
This script is for preparing dendrogram using Ward's 
linkage function (Euclidean distance as metric) with
umap embeddings to put the umap clusters into different 
clades using Hierarchical clustering
'''

import numpy as np
import pandas as pd
from scipy.spatial.distance import cdist
import matplotlib.pyplot as plt
from scipy.cluster.hierarchy import dendrogram, linkage

df = pd.read_csv("./umapEmbedding2RegionsOutput_onlyTargetGroupsOutput.ed.txt", sep = " ")
df = df.groupby('region').mean()
df = df.reset_index()
df_array = df[['emb1', 'emb2']].to_numpy()
dist_mat = cdist(df_array, df_array)
dfDist = pd.DataFrame(dist_mat, columns = df['region'], index = df['region'])
dfDist = dfDist.rename_axis('pop')
dfDist = dfDist.stack().reset_index().rename(columns = {0: 'dist'})
plt.hist(dfDist['dist'])

aeapops = ["andalusiaPortugal","azerbaijanGeorgia","barcelona","britishIsles1","britishIsles2","centralSpain1","centralSpain2","cEuropeBaltic","cSouthItaly","italyBalkanPeninsula","malmoLund","nE_EScania","nGermany","northCentralSpain","northSweden","nWEngland","olandGotland","pyreneesGironaIbRange","region","relictsFs12","relictsFs13","russiaAsia","sEScania","sGermany","sTyrol","uFranceEFranceBIsles","westScania","wNCFrance",]
dfDist[(dfDist['region'].isin(aeapops)) & ~(dfDist['pop'].isin(aeapops))]

linked =linkage(df_array, 'ward',)
labels = list(df['region'])
plt.figure(figsize = (10,7))
dendrogram(linked,orientation='top',
          labels = labels,
          distance_sort='descending',
          show_leaf_counts=True);
plt.savefig("forPublication/results/dendrogram_umap.TargetGroups.pdf")




df2 = pd.read_csv("forPublication/results/envVariablesMean_group_cluster.renamed.txt", sep ="\t")
df2_subset = df2[df2['cluster'].isin(["andalusiaPortugal","azerbaijanGeorgia","barcelona","britishIsles1","britishIsles2",
                         "centralSpain1","centralSpain2","cEuropeBaltic","Connecticut4","cSouthItaly","Haplogroup1",
                         "IndianaTerreHaute1","italyBalkanPeninsula","LongIsland1","malmoLund","Massachusetts1",
                         "Michigan2","Michigan3","MichiganManistee1","MidWestern1","nE_EScania","NewYorkBG","nGermany",
                         "northCentralSpain","northSweden","nWEngland","Ohio2","Ohio7","OhioMich1","OhioMich4",
                         "OhioNewJersey2","OhioOSU","olandGotland","pyreneesGironaIbRange","region","relictsFs12","relictsFs13","RhodeIsland1",
                         "russiaAsia","sEScania","sGermany","SouthIndiana1","SouthIndiana4",
                         "sTyrol","uFranceEFranceBIsles","westScania","wNCFrance",])]



df2_m = df2_subset.groupby('cluster').mean()
df2_m.reset_index(inplace=True)
df2_array = df2_m[['prec', 'tavg','vapr' ]].to_numpy()
linked =linkage(df2_array, 'ward')
labels = list(df2_m['cluster'])

plt.figure(figsize = (16,7))
dendrogram(linked,orientation='top',
          labels = labels,
          distance_sort='descending',
          show_leaf_counts=True,)
plt.savefig("forPublication/results/dendrogram_prec_tavg_vapr.TargetGroups.pdf")

