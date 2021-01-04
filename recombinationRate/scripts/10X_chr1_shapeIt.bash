#!/bin/bash
source ~/.bash_profile
shapeit -assemble -T 48 --input-vcf 1001gSet_AL_12345_JD.filtered_snps_final.PASS.bi.lmiss90.imiss50.SOR.noSingletons.noTE_2kUp_2kDn.ResGenes25XaboveFiltered.chr1.recode.vcf.gz --input-pir 10X_chr1_PIRsList -O 1001gSet_AL_12345_JD.filtered_snps_final.PASS.bi.lmiss90.imiss50.SOR.noSingletons.noTE_2kUp_2kDn.ResGenes25XaboveFiltered.chr1.HaplotypeData -L chr1_shapeit.log
#1001gSet_AL_12345_JD.filtered_snps_final.PASS.bi.lmiss90.imiss50.SOR.noSingletons.noTE_2kUp_2kDn.ResGenes25XaboveFiltered.chr1.recode.vcf
