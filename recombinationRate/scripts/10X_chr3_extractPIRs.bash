#!/bin/bash
source ~/.bash_profile
extractPIRs --bam 10X_chr3.bamlist --vcf 1001gSet_AL_12345_JD.filtered_snps_final.PASS.bi.lmiss90.imiss50.SOR.noSingletons.noTE_2kUp_2kDn.ResGenes25XaboveFiltered.chr3.recode.vcf.gz --out 10X_chr3_PIRsList
