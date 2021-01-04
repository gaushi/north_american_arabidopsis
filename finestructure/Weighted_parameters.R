setwd('/ebio/abt6_projects9/Methylome_variation_HPG1/origins/post_vcf1/shapeit_noQD30/combinePops/EurasianOnly')
parameters <- read.table('EurasianOnly.parameter_summary.txt', header = T)
head(parameters)
parameters$sum_chr_Ne <- parameters$N_SNPs*parameters$Ne 
parameters$sum_chr_Mu <- parameters$N_SNPs*parameters$Mu
weighted_Ne = sum(parameters$sum_chr_Ne)/sum(parameters$N_SNPs)
weighted_Mu = sum(parameters$sum_chr_Mu)/sum(parameters$N_SNPs)
weighted_Ne
weighted_Mu
