#!/bin/bash
############################################################################################

#convert imputed vcf to plink-tped 
#tped format is chosen because vcftools can't process ~1600 individuals in normal ped format, 
for i in {1..5}
do 
	vcftools --gzvcf merged.bi.lmiss90.ed.chr${i}.bgl.vcf.gz --plink-tped --out merged.bi.lmiss90.ed.chr${i}.bgl
done

#now convert the tped files into bed format
for i in {1..5} 
do 
	plink --tfile  merged.bi.lmiss90.ed.chr${i}.bgl --recode12 --out  merged.bi.lmiss90.ed.chr${i}.bgl 
done &&

#delete tped and tfam to save space
for i in {1..5}
do 
	rm merged.bi.lmiss90.ed.chr${i}.bgl.tped && rm merged.bi.lmiss90.ed.chr${i}.bgl.tfam 
done &&


############################################################################################

#Using plink2Chrompainter.pl
for i in {1..5}
do 
	plink2chromopainter.pl -p=merged.bi.lmiss90.ed.chr${i}.bgl.ped -m=merged.bi.lmiss90.ed.chr${i}.bgl.map -o=merged.bi.lmiss90.ed.chr${i}.bgl.phase 
done &&

############################################################################################
#Convert Recombination rates to suit the phase file
for i in {1..5}
do
	convertrecfile.pl -M plain merged.bi.lmiss90.ed.chr${i}.bgl.phase fineStructure/recombRate/chr${i}_recom_rate_Morgan.txt fineStructure/recombRate/merged.bi.lmiss90.ed.chr${i}.recombfile
done
############################################################################################
#RUN Chromopainter all-vs-all , will take a long time

for i in {1..5}; 
do 
	qsub fineStructure/runChromoPainter_1689.chr${i}.sh
done &&
############################################################################################
mail -s 'Chromopainter allvall started ' gshirsekar@tuebingen.mpg.de <chromoPainterPipeline.sh
