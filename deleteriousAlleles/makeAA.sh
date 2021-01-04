#!/bin/bash
#after merging ahalleri and alyrata vcfs with main vcf of arabidopsis individuals
bcftools view -m 2 -M 2 -v snps -s ahalleri,alyrata merged.bi.lmiss90.ed.vcf.AA.gz | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n'| awk '{OFS="\t";if($5=="0/0" && $6=="0/0"){print $1,$2,$3,$4,$3}if($5=="0/1" && $6=="0/1"){print $1,$2,$3,$4,$4}if($5=="1/1" && $6=="1/1"){print $1,$2,$3,$4,$4}if($5=="0/1" && $6=="1/1"){print $1,$2,$3,$4,$4}if($5=="1/1" && $6=="0/1"){print $1,$2,$3,$4,$4}}' >  arabidopsisAA.tab
bgzip arabidopsisAA.tab
tabix -s1 -b2 -e2 arabidopsisAA.tab.gz
# in arabidopsisAA.tab.gz 3rd column is ref, 4th column is alt and 5th column is AA ascertained by the criteria described in the methods


