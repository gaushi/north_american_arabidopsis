#!/bin/bash
cd /ebio/abt6_projects9/Methylome_variation_HPG1/origins/post_vcf1/shapeit_noQD30/combinePops
#qsub snpcall_gvcf.sh is the execution command
#  Import environment
#$ -V
#  Reserve 5 CPUs for this job
#$ -pe parallel 32
#
#  Request 768G of RAM
#$ -l h_vmem=16G
#  Limit run time to 24 hours
#$ -l h_rt=192:00:00
#
#  The name shown in the qstat output and in the output file(s). The
#  default is to use the script name.
#$ -N cPops
#
#  The path used for standard error stream of the job
#$ -e /ebio/abt6_projects9/Methylome_variation_HPG1/origins/post_vcf1/shapeit_noQD30/combinePops/uptopade.log
#
#  Use /bin/bash to execute this scripti
#$ -S /bin/bash
#
#
#  Send email when the job begins, ends, aborts, or is suspended
#$ -m beas
source ~/.bash_profile
ldhelmet find_confs --num_threads 32 -w 50 -o output.conf chr1.fa chr2.fa chr3.fa chr4.fa chr5.fa &&
ldhelmet table_gen --num_threads 32 -c output.conf -t 0.005 -r 0.0 0.1 10.0 1.0 100.0 -o output.lk &&
ldhelmet pade --num_threads 32 -c output.conf -t 0.005 -x 11 -o output.pade
/ebio/abt6_projects9/Methylome_variation_HPG1/WGS/src/LDhelmet_v1.7/ldhelmet rjmcmc --num_threads 32 -w 50 -l output.lk -p output.pade -b 50.0 -s chr1.fa -m mutMat.txt --burn_in 300000 -n 3000000 -o output_chr1.post
/ebio/abt6_projects9/Methylome_variation_HPG1/WGS/src/LDhelmet_v1.7/ldhelmet rjmcmc --num_threads 32 -w 50 -l output.lk -p output.pade -b 50.0 -s chr2.fa -m mutMat.txt --burn_in 300000 -n 3000000 -o output_chr2.post
/ebio/abt6_projects9/Methylome_variation_HPG1/WGS/src/LDhelmet_v1.7/ldhelmet rjmcmc --num_threads 32 -w 50 -l output.lk -p output.pade -b 50.0 -s chr3.fa -m mutMat.txt --burn_in 300000 -n 3000000 -o output_chr3.post
/ebio/abt6_projects9/Methylome_variation_HPG1/WGS/src/LDhelmet_v1.7/ldhelmet rjmcmc --num_threads 32 -w 50 -l output.lk -p output.pade -b 50.0 -s chr4.fa -m mutMat.txt --burn_in 300000 -n 3000000 -o output_chr4.post
/ebio/abt6_projects9/Methylome_variation_HPG1/WGS/src/LDhelmet_v1.7/ldhelmet rjmcmc --num_threads 32 -w 50 -l output.lk -p output.pade -b 50.0 -s chr5.fa -m mutMat.txt --burn_in 300000 -n 3000000 -o output_chr5.post

