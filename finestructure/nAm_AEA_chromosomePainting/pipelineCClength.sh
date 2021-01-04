#!/bin/bash
while read line
do
for i in {1..5}; do ./chunkAv.py -c merged.bi.lmiss90.ed.chr${i}.bgl.AmericansWithNativeInds.allInds.painting.chunklengths.out -h 0 -i ${line}.txt -o ${line}.chr${i}.avChunkLengthPerCluster.out ; done
for i in {1..5}; do while read a b ; do sed -i "s/\<${a}\>/${b}/g" ${line}.chr${i}.avChunkLengthPerCluster.out ; done < regionsClusters.txt ; done
for i in {1..5}; do ./regionMeans.py -i ${line}.chr${i}.avChunkLengthPerCluster.out -c ${i} -o ${line}.chr${i}.avRegionCLength.out; done
paste ${line}.chr*.avRegionCLength.out|cut -f1,2,4,6,8,10 > ${line}.allChr.avRegionCLength.out
done < newGroups.list
