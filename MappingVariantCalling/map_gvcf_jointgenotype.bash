#!/bin/bash

cd /ebio/abt6_projects9/Methylome_variation_HPG1/herbs
#  Import environment
#$ -V
#  Reserve 12 CPUs for this job
#$ -pe parallel 12
#
#  Request 240G of RAM
#$ -l h_vmem=24G
#  Limit run time to 48 hours
#$ -l h_rt=120:00:00
#
#  The name shown in the qstat output and in the output file(s). The
#  default is to use the script name.
#$ -N her1
#
#  The path used for standard error stream of the job
#$ -e /ebio/abt6_projects9/Methylome_variation_HPG1/herbs/map.log
#
#  Use /bin/bash to execute this scripti
#$ -S /bin/bash
#
#
#  Send email when the job begins, ends, aborts, or is suspended
#$ -m beas
#
#
source ~/.bash_profile
############map with BWA#################
parallel --jobs 2 bwa mem -M -t 4 -V /ebio/abt6_projects9/Methylome_variation_HPG1/RAD15/data/refgenome/TAIR10.fa '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}'.R1.fastq.gz '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}'.R2.fastq.gz '|' samtools sort -T '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}' -O bam -o '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}'.col0_sorted.bam - ::: *.fastq.gz
parallel --jobs 8 samtools index {} ::: *.col0_sorted.bam &&

rm *.fastq.gz

#######create Reference Variable###########################################
col0=/ebio/abt6_projects9/Methylome_variation_HPG1/RAD15/data/refgenome/TAIR10.fa
#######################################INDEX the BAMfile#########################################
parallel --jobs 5 java -Xmx24g -jar $picard AddOrReplaceReadGroups I={} O='{= s:\.[^.]+$::;=}'.picardRG.bam RGID='{= s:\.[^.]+$::;s:\.[^.]+$::; =}' RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM='{= s:\.[^.]+$::;s:\.[^.]+$::; =}' ::: *.col0_sorted.bam

parallel --jobs 5 samtools index {} ::: *.picardRG.bam

########################################Create Realignment Targets#################################
#This is the first step in a two-step process of realigning around indels
parallel --jobs 5 java -Xmx24g -jar $gatk -T RealignerTargetCreator -nt 8 -R $col0 -I {} -o  '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}'.realignment_targets.list ::: *.col0_sorted.picardRG.bam

########################################Realign Indels############################################
#This step performs the relalignment around the indels which were identified in the previous step
parallel --jobs 5 java -Xmx24g -jar $gatk -T IndelRealigner -R $col0  -I {} -targetIntervals '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}'.realignment_targets.list -o '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}'.realigned_reads.bam ::: *.col0_sorted.picardRG.bam
########################################Create Realignment Targets#################################
parallel --jobs 5 java -Xmx24g -jar $gatk -T HaplotypeCaller -nct 8 -R $col0 -I {} -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.raw_variants.vcf ::: *.realigned_reads.bam
#This step separates SNPs and Indels so they can be processed and used independently
parallel --jobs 5 java -Xmx24g -jar $gatk -T SelectVariants -nt 8 -R $col0 -V {} -selectType SNP -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.raw_snps.vcf ::: *.raw_variants.vcf
parallel --jobs 5 java -Xmx24g -jar $gatk -T SelectVariants -nt 8 -R $col0 -V {} -selectType INDEL -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.raw_indels.vcf ::: *.raw_variants.vcf
####################################Filter SNPs##################################################
#QD = The QD is the QUAL score normalized by allele depth (AD) for a variant. For a single sample, the HaplotypeCaller calculates the QD by taking QUAL/AD
#MQ = This annotation provides an estimation of the overall mapping quality of reads supporting a variant call. It produce both raw data (sum of square and num of total reads) and the calculated root mean square.
#MQRankSum =This variant-level annotation compares the mapping qualities of the reads supporting the reference allele with those supporting the alternate allele. The ideal result is a value close to zero, which indicates there is little to no difference.
#ReadPosRankSum = This variant-level annotation tests whether there is evidence of bias in the position of alleles within the reads that support them, between the reference and alternate alleles. A negative value indicates that the alternate allele is found at the ends of reads more often than the reference allele.



varfilt() {
        vcf=$1
        out=$2
        java -Xmx24g -jar $gatk -T VariantFiltration -R /ebio/abt6_projects9/Methylome_variation_HPG1/RAD15/data/refgenome/TAIR10.fa -V "$vcf" --filterExpression 'QD < 2.0 || ReadPosRankSum < -8.0|| MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0' --filterName "basic_snp_filter" -o "$out"
        }
export -f varfilt
parallel --jobs 5 varfilt {} '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.filtered_snps.vcf ::: *.raw_snps.vcf

#####################################Filter Indels##################################################
varfiltindels() {
        vcf=$1
        out=$2
        java -Xmx24g -jar $gatk -T VariantFiltration -R /ebio/abt6_projects9/Methylome_variation_HPG1/RAD15/data/refgenome/TAIR10.fa -V "$vcf" --filterExpression 'QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0 || SOR > 10.0' --filterName "basic_indel_filter" -o "$out"
        }
export -f varfiltindels
parallel --jobs 5 varfiltindels {} '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.filtered_indels.vcf ::: *.raw_indels.vcf
################################Base Quality Score Recalibration####################### Step 1##########
parallel --jobs 5 java -Xmx24g -jar $gatk -T BaseRecalibrator -nct 8 -R $col0 -I {} -knownSites '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.filtered_snps.vcf -knownSites '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.filtered_indels.vcf -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.recal_data.table ::: *realigned_reads.bam
################################BQSR Step2######################################################
parallel --jobs 5 java -Xmx24g -jar $gatk -T BaseRecalibrator -nct 8 -R $col0 -I {} -knownSites '{= s:\.[^.]+$::;s:\.[^.]+$::;=}'.filtered_snps.vcf -knownSites '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.filtered_indels.vcf -BQSR '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.recal_data.table -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.post_recal_data.table ::: *realigned_reads.bam

###############################Apply BQSR#######################################################
#This step applies the recalibration computed in the first BQSR step to the bam file.
parallel --jobs 5 java -Xmx24g -jar $gatk -T PrintReads -nct 8 -R $col0 -I {} -BQSR '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.recal_data.table -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.recal_reads.bam ::: *realigned_reads.bam
###############################Call Variants gVCF######################################################
#Second round of variant calling performed on recalibrated bam

parallel --jobs 5 java -Xmx24g -jar $gatk -T HaplotypeCaller -nct 8 -R $col0 -I {} --emitRefConfidence GVCF -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.raw_variants_recal.g.vcf ::: *.recal_reads.bam

### Make a list of all the g.vcf files ==> herbs_grand_gvcf_irish_SP1.list

###############################Merge and jointly genotype gVCFs##########################################
#-stand_emit_conf [number]
#Variants with quality score (QUAL) less than [number] will not be written to VCF file. Good to set this low – better have too many raw variants than too few. Can always filter VCF file later. Default: 30.
#-stand_call_conf [number]
#Variants with QUAL< [number] will be marked as LowQual in FILTER field of VCF. Default: 30

nice -n 2 java -Xmx16g -jar $gatk -T GenotypeGVCFs -R /ebio/abt6_projects9/Methylome_variation_HPG1/RAD15/data/refgenome/TAIR10.fa -nt 24 -V herbs_grand_gvcf_irish_SP1.list -stand_call_conf 30 -stand_emit_conf 10 -o herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.vcf
###############################Extract SNPs and Indels #############################################
#This step separates SNPs and Indels so they can be processed and analyzed independently

java -Xmx16g -jar $gatk -T SelectVariants -nt 24 -R $col0 -V herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.vcf  -selectType SNP  -o herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.snps.vcf &&
bgzip herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.snps.vcf &&
tabix -p vcf herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.snps.vcf.gz &&
###############################Filter SNPs ########################################################


java -Xmx16g -jar $gatk -T VariantFiltration -R $col0 -V herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.snps.vcf.gz --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0 || SOR > 4.0' --filterName "basic_snp_filter" -o herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.vcf


bgzip herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.vcf &&
tabix -p vcf herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.vcf.gz &&
rm herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.snps.vcf.gz


###############################only PASS snps#####################################################
zcat herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.vcf.gz |grep 'PASS\|^#' > herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.vcf &&
rm herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.vcf.gz
bgzip  herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.vcf &&
tabix -p vcf herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.vcf.gz


###############################only Bi allelic #######################################################
java -Xmx16g -jar $gatk -T SelectVariants -nt 64 -R $col0 -V herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.vcf.gz --restrictAllelesTo BIALLELIC -o herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.vcf &&
rm herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.vcf.gz &&
bgzip herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.vcf &&
tabix -p vcf herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.vcf.gz



###############################POST_VCF##########################################################
#make a directory post_vcf and cp herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.vcf there
mkdir -p postVcf
mv herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.vcf.g* ./postVcf
cd ./postVcf
###############################KEEP the SNPS with at the MOST 30% missing data###########################
vcftools --gzvcf herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.vcf.gz --max-missing 0.7 --recode --recode-INFO-all --out herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7 &&
bgzip herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.recode.vcf
tabix -p vcf herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.recode.vcf.gz


#find missingness per individual excluding all singletons and also TE and TE 2k up-down stream
vcftools --gzvcf herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.recode.vcf.gz --exclude-bed ../allChr_TE_positions_2kUp_2kDn.txt --mac 2 --missing-indv --out herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.noTE2kUp2kDn.mac2Up &&
#remove individuals with more than 60% data missing (kept H2106H1 missing data was 0.603)
less -S herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.noTE2kUp2kDn.mac2Up.imiss|awk '($5>0.6)'|cut -f1|sed '/INDV/d'> miss_individuals &&

# removed individuals from and made new vcf
vcftools --gzvcf herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.recode.vcf.gz --exclude-bed ../allChr_TE_positions_2kUp_2kDn.txt --mac 2 --remove miss_individuals --recode --recode-INFO-all --out herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.noTE2kUp2kDn.mac2Up.maximiss0_6

vcffilter -s -f "QD > 20" herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.noTE2kUp2kDn.mac2Up.maximiss0_6.recode.vcf > test.vcf
mv test.vcf herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.noTE2kUp2kDn.mac2Up.maximiss0_6.QDgt20.vcf &&
bgzip herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.noTE2kUp2kDn.mac2Up.maximiss0_6.QDgt20.vcf &&
tabix -p vcf herbs_AL_762subset_AF_IR_p12345_JD_SP1_ZH.filtered_snps_final.PASS.bi.md0_7.noTE2kUp2kDn.mac2Up.maximiss0_6.QDgt20.vcf.gz










