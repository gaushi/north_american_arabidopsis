#!/bin/bash
cd /ebio/abt6_projects9/Methylome_variation_HPG1/herbs/postVcf/analysis/fineStructure
#qsub snpcall_gvcf.sh is the execution command
#  Import environment
#$ -V
#  Reserve 6 CPUs for this job
#$ -pe parallel 1
#
#  Request 768G of RAM
#$ -l h_vmem=48G
#
#  The name shown in the qstat output and in the output file(s). The
#  default is to use the script name.
#$ -N i1689_chr4
#
#
#  Use /bin/bash to execute this scripti
#$ -S /bin/bash
#
#
#  Send email when the job begins, ends, aborts, or is suspended
#$ -m beas
source ~/.bash_profile
ChromoPainterv2 -g ../merged.bi.lmiss90.ed.chr4.bgl.phase -t merged.bi.lmiss90.ed.inds.txt -a 0 0 -r recombRate/merged.bi.lmiss90.ed.chr4.recombfile  -n 9838.359 -M 0.01126963 -o cpOutput/merged.bi.lmiss90.ed.chr4.runD
#762_eachCluster5noDup.nAmWGS.chr1.phase
