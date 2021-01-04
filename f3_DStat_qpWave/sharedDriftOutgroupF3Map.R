#usethis::edit_r_environ() #put admixtools path in there
library(admixr)
###################################################
library(maptools)
library(ggplot2)
library(ggthemes)
library(raster)
library(akima)
library(wesanderson)
###################################################3
#import data
snps <- eigenstrat("/mnt/bigdisk/work/northAmericanArabidopsis/evolHistory/admixtools/subClusters/merged.bi.lmiss90.ed.nativeClustersAmericanGroups")
#set N. American groups
pops1<- c("newGroup12_2","newGroup15_2","newGroup16_1",
          "newGroup16_2","newGroup17_2","newGroup18_1",
          "newGroup20_1","newGroup22_1","newGroup26_1",
          "newGroup34_1","newGroup35","newGroup36","newGroup37",
          "newGroup38","newGroup39","newGroup9_2","newGroupCol0",
          "newGroupMAAA","newGroupNYBG","newGroupOHOS", "newGroup3")
#set AEA sub-clusters
pops3 <- c("fs11_1","fs11_2",
           "fs20_1","fs20_2","fs20_3","fs20_4",
           "fs10_1","fs10_2",
           "fs4_1","fs4_2","fs4_3","fs4_4","fs4_5","fs4_6","fs4_7","fs4_8",
           "fs3_1","fs3_2","fs3_3","fs3_4","fs3_5","fs3_6",
           "fs7_1","fs7_2","fs7_3",
           "fs8_1","fs8_2",
           "fs18_1","fs18_10","fs18_11","fs18_12","fs18_2","fs18_3","fs18_4","fs18_5","fs18_6","fs18_7","fs18_9",
           "fs17_10","fs17_11","fs17_12","fs17_13","fs17_14","fs17_9","fs17_1","fs17_2","fs17_3","fs17_4","fs17_5","fs17_6","fs17_7","fs17_8",
           "fs18_14","fs18_15",
           "fs15_18","fs15_2","fs15_15","fs15_17",
           "fs16_1","fs16_10","fs16_11","fs16_12","fs16_2","fs16_3","fs16_4","fs16_5","fs16_8","fs16_9",
           "fs18_13","fs18_8",
           "fs3_17","fs13_4","fs2_1","fs9_1","fs9_2","fs9_3","fs9_4",
           "fs5_1","fs5_10","fs5_11","fs5_12","fs5_2","fs5_3","fs5_4","fs5_5","fs5_6","fs5_7","fs5_8","fs5_9",
           "fs3_9","fs15_1","fs15_10","fs15_11","fs15_12","fs15_13","fs15_14","fs15_16","fs15_2","fs15_3","fs15_4","fs15_5",
           "fs15_6","fs15_7","fs15_8","fs15_9","fs16_6","fs16_7","fs10_3","fs10_4","fs10_5","fs10_6",
           "fs12_1","fs12_2",
           "fs13_1","fs13_2","fs13_3",
           "fs6_1","fs6_10","fs6_11","fs6_12","fs6_13","fs6_2","fs6_3","fs6_4","fs6_5","fs6_6","fs6_7","fs6_8","fs6_9",
           "fs15_19","fs16_13","fs16_14",
           "fs19_1","fs19_2","fs19_3","fs19_4","fs19_5","fs19_6",
           "fs21_1","fs21_2","fs21_3","fs21_4","fs21_5","fs3_10","fs3_11","fs3_12","fs3_13","fs3_14","fs3_15",
           "fs3_16","fs4_3","fs14_1","fs14_2","fs14_3","fs1_1","fs1_2","fs1_3","fs1_4","fs1_5")

result_NAmericans_Regions_Fs12 <- f3(A=pops1, B=pops3, C="fs12_3", data = snps)
#Write output to a file
write.table(file="/mnt/bigdisk/work/northAmericanArabidopsis/evolHistory/admixtools/subClusters/result_NAmericans_SubClusters_Fs12_3.f3.txt", result_NAmericans_Regions_Fs12,
            row.names =F, col.names = T, sep="\t" )

###################### Plotting ###############################3
f3Results <- read.table("/mnt/bigdisk/work/northAmericanArabidopsis/evolHistory/admixtools/subClusters/tmp1", header = T)

AmericanGroupList =list("newGroup12_2","newGroup15_2","newGroup16_1","newGroup16_2","newGroup17_2",
                        "newGroup18_1","newGroup20_1","newGroup22_1","newGroup26_1","newGroup3",
                        "newGroup34_1","newGroup35","newGroup36",
                        "newGroup37","newGroup38","newGroup39","newGroup9_2","newGroupCol0","newGroupMAAA",
                        "newGroupNYBG","newGroupOHOS")

### IMPORTANT: newGroups were named after regions for final analysis, the dictionary mapping their new names is:
# newAmericanGroups.Renamed.populationsDictionary.txt, it is kept in the same directory.

#### Loop through the groups #########

for (i in AmericanGroupList){
  
 
	aGroup <- i

	f3NewGroup <- f3Results[f3Results$A==aGroup,]

	data("wrld_simpl")
	mymap <- fortify(wrld_simpl)

	mydf2 <- with(f3NewGroup, interp(x=f3NewGroup$Long, y=f3NewGroup$Lat, z=f3NewGroup$f3,
        	                             xo=seq(min(f3NewGroup$Long), max(f3NewGroup$Long), length=400),
                	                     #yo=seq(min(f3NewGroup$Lat), max(f3NewGroup$Lat), length=100),
                        	             duplicate = "mean"))
	pal <- wes_palette("Zissou1",100, type = "continuous")
	gdat <-interp2xyz(mydf2, data.frame=T)
	p <- ggplot(data=gdat, aes(x=x, y=y, z=z))+theme_bw()+
  	geom_tile(aes(fill=z),alpha=0.8)+
  	stat_contour(aes(fill= z), alpha=0.8, geom = "polygon", binwidth = 0.8)+
  	#geom_contour(color="gray90")+
  	geom_path(data=mymap, aes(x=long, y=lat, group=group), inherit.aes = F)+
  	scale_x_continuous(limits = c(-15,62), expand = c(0,0))+
  	scale_y_continuous(limits = c(35,62), expand = c(0,0))+
  	scale_fill_gradientn(colors = c("white", "lightblue", "royalblue", "khaki2","navajowhite", "red"),breaks=seq(0,0.5,0.1))+
  	#scale_fill_gradientn(colors = pal)+
  	coord_equal()+
  	labs(title = aGroup)+
  	xlab("Longitude")+
  	ylab("Latitude")+
  	#theme(legend.position = "top")+
  	#theme(legend.position = "bottom")+
  	theme(legend.justification=c(1,1), legend.position=c(0.99,0.99),legend.title=element_blank(), legend.direction = "horizontal")+
  	theme(legend.background = element_rect(fill="seashell2",
                                         size=0.5, linetype="solid", 
                                         colour ="gray"))

	savefileName <- paste0("~/Desktop/nAmericanArabidopsis/admixtoolsFigures/",aGroup,".pdf")
	pdf(savefileName)
	print(p)
	dev.off()
}

