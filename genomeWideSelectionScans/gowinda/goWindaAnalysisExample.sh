#!/bin/bash
java -jar ./Gowinda-1.12.jar \
  --snp-file allSNPs.txt \
  --candidate-snp-file testSNPsData.txt \
  --annotation-file converted.gtf \
  --simulations 1000000 \
  --gene-definition gene \
  --min-genes 10 \
  --threads 2 \
  --detailed-log --mode snp \
  --output-file testSNPsOut.txt \
  --gene-set-file association_gominer.ed.txt

