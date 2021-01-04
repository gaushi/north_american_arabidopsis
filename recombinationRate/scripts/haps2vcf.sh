#!/bin/bash
source ~/.bash_profile
for i in {1..5}
do
shapeit -convert -T 16 --input-haps 1001gSet_AL_12345_JD.filtered_snps_final.PASS.bi.lmiss90.imiss50.SOR.noSingletons.noTE_2kUp_2kDn.ResGenes25XaboveFiltered.chr${i}.HaplotypeData --output-vcf 1001gSet_AL_12345_JD.filtered_snps_final.PASS.bi.lmiss90.imiss50.SOR.noSingletons.noTE_2kUp_2kDn.ResGenes25XaboveFiltered.chr${i}.HaplotypeData.vcf
done

parallel --jobs 5 bgzip {} ::: 1001gSet_AL_12345_JD.filtered_snps_final.PASS.bi.lmiss90.imiss50.SOR.noSingletons.noTE_2kUp_2kDn.ResGenes25XaboveFiltered.chr*.HaplotypeData.vcf
parallel --jobs 5 tabix -p vcf {} ::: 1001gSet_AL_12345_JD.filtered_snps_final.PASS.bi.lmiss90.imiss50.SOR.noSingletons.noTE_2kUp_2kDn.ResGenes25XaboveFiltered.chr*.HaplotypeData.vcf.gz



#1001gSet_AL_12345_JD.filtered_snps_final.PASS.bi.lmiss90.imiss50.SOR.noSingletons.noTE_2kUp_2kDn.ResGenes25XaboveFiltered.chr1.HaplotypeData
