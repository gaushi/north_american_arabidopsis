#!/bin/bash
for file in *maf ; do sed -i "s/arabidopsis_thaliana.${i}/chr${i}/g" $file ; done
for i in *.maf ; do maf-convert sam -r 'ID:alyrata PL:ILLUMINA SM:alyrata' ${i} | samtools view -bt /ebio/abt6_projects9/Methylome_variation_HPG1/RAD15/data/refgenome/TAIR10.fa.fai -o ${i}.bam ; done
ls *.bam > bamlist
bamtools merge -list bamlist -out merged.bam
samtools sort -o mergedSorted.bam -O BAM -@ 20 --reference /ebio/abt6_projects9/Methylome_variation_HPG1/RAD15/data/refgenome/TAIR10.fa merged.bam
samtools index mergedSorted.bam
samtools mpileup -ugf /ebio/abt6_projects9/Methylome_variation_HPG1/RAD15/data/refgenome/TAIR10.fa -l merged.bi.lmiss90.ed.lmiss.pos mergedSorted.bam|bcftools call -m |bcftools view -Oz -o lyrata.vcf.gz
gunzip lyrata.vcf.gz
for i in {1..5} ; do sed -i "s/chr${i}/${i}/g" lyrata.vcf ; done
bgzip lyrata.vcf

bcftools index lyrata.vcf.gz
