setwd('/ebio/abt6_projects9/Methylome_variation_HPG1/origins/post_vcf1/shapeit_noQD30/combinePops/recomb_rate_perbp_Morgan')

#####CHR1#######
chr1 <- read.table('chr1_recom_rate_Morgan.txt', header = T)
#head(chr1)
chr1$recom_rate_cM_perbp <- chr1$recom_rate_perbp*100
chr1$recom_rate_cM_perMb <- chr1$recom_rate_cM_perbp*1000000
write.table(chr1,"chr1_recom_rate_cMperMb.txt", sep = '\t', row.names=F)
####CHR2########
chr2 <- read.table('chr2_recom_rate_Morgan.txt', header = T)
#head(chr2)
chr2$recom_rate_cM_perbp <- chr2$recom_rate_perbp*100
chr2$recom_rate_cM_perMb <- chr2$recom_rate_cM_perbp*1000000
write.table(chr2,"chr2_recom_rate_cMperMb.txt", sep = '\t', row.names=F)
#####CHR3########
chr3 <- read.table('chr3_recom_rate_Morgan.txt', header = T)
#head(chr3)
chr3$recom_rate_cM_perbp <- chr3$recom_rate_perbp*100
chr3$recom_rate_cM_perMb <- chr3$recom_rate_cM_perbp*1000000
write.table(chr3,"chr3_recom_rate_cMperMb.txt", sep = '\t', row.names=F)
####CHR4#########
chr4 <- read.table('chr4_recom_rate_Morgan.txt', header = T)
#head(chr4)
chr4$recom_rate_cM_perbp <- chr4$recom_rate_perbp*100
chr4$recom_rate_cM_perMb <- chr4$recom_rate_cM_perbp*1000000
write.table(chr4,"chr4_recom_rate_cMperMb.txt", sep = '\t', row.names=F)
#####CHR5########
chr5 <- read.table('chr5_recom_rate_Morgan.txt', header = T)
#head(chr5)
chr5$recom_rate_cM_perbp <- chr5$recom_rate_perbp*100
chr5$recom_rate_cM_perMb <- chr5$recom_rate_cM_perbp*1000000
write.table(chr5,"chr5_recom_rate_cMperMb.txt", sep = '\t', row.names=F)






