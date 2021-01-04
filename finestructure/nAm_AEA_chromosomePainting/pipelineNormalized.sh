#!/bin/bash
while read line
do
for i in {1..5}; do ./chunkAv.py -c merged.bi.lmiss90.ed.chr${i}.bgl.AmericansWithNativeInds.allInds.painting.chunkcounts.out -h 1 -i ${line}.txt -o ${line}.chr${i}.avChunkCountPerCluster.out ; done
for i in {1..5}; do paste ${line}.chr${i}.avChunkCountPerCluster.out cluterInds.txt |cut -f1,2,4 > tmp && mv tmp ${line}.chr${i}.avChunkCountPerCluster.out ; done
for i in {1..5}; do ./normalizeChunks.py -i ${line}.chr${i}.avChunkCountPerCluster.out -c ${i} -o ${line}.chr${i}.avNormalizedChunkCountPerCluster.out ; done

paste ${line}.chr*.avNormalizedChunkCountPerCluster.out|cut -f1,4,8,12,16,20 > ${line}.allChr.avNormalizedClusterCCount.out
while read a b ; do sed -i "s/\<${a}\>/${b}/g" ${line}.allChr.avNormalizedClusterCCount.out ; done < regionsClusters.txt
done < newGroups.list
