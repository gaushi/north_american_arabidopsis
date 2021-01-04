#!/bin/bash
while read line
do
for i in {1..5}; do ./chunkAv.py -c merged.bi.lmiss90.ed.chr${i}.bgl.AmericansWithNativeInds.allInds.painting.chunkcounts.out -h 1 -i ${line}.txt -o ${line}.chr${i}.avChunkCountPerCluster.out ; done
for i in {1..5}; do while read a b ; do sed -i "s/\<${a}\>/${b}/g" ${line}.chr${i}.avChunkCountPerCluster.out ; done < regionsClusters.txt ; done
paste ${line}.chr*.avChunkCountPerCluster.out|cut -f1,2,4,6,8,10 > ${line}.allChr.avChunkCountPerCluster.out
for i in {1..5}; do ./regionMeans.py -i ${line}.chr${i}.avChunkCountPerCluster.out -c ${i} -o ${line}.chr${i}.avRegionCCount.out; done
paste ${line}.chr*.avRegionCCount.out|cut -f1,2,4,6,8,10 > ${line}.allChr.avRegionCCount.out
done < newGroups.list
