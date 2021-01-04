setwd("/mnt/bigdisk/work/northAmericanArabidopsis/evolHistory/TAIR10_based")
umapOut = read.table("umapOut_nn100_minDist0_8_euclidean.txt", header = T)
head(umapOut)

library(ggplot2)
library(ggthemes)
library(ggrepel)
cols= c("azerbaijanGeorgia"="#00ADEF","cSouthItaly"="#9D248E","italyBalkanPeninsula"="#7BAA47","britishIsles1"="#F6BF97","northSweden"="#9F8BAA","russiaAsia"="#5E4E43","cEuropeBaltic"="#A0B782","westScania"="#0AA249","nE_EScania"="#AF372F","malmoLund"="#7773B5","olandGotland"="#3C3869","sEScania"="#B75250","sTyrol"="#7CC393","nGermany"="#777364","sGermany"="#E51856","nWEngland"="#53190D","uFranceEFranceBIsles"="#532D90","wNCFrance"="#9C9450","britishIsles2"="#7C98CE","relictsFs12"="#231F20","relictsFs13"="#58585B","barcelona"="#88226D","pyreneesGironaIbRange"="#A7919D","centralSpain1"="#619DD4","northCentralSpain"="#F26A21","centralSpain2"="#00AC4D","andalusiaPortugal"="#005CA2","nAm"="white")
subData = subset(umapOut, (umapOut$region %in% c("andalusiaPortugal","azerbaijanGeorgia","barcelona","britishIsles1","britishIsles2","centralSpain1","centralSpain2","cEuropeBaltic","cSouthItaly","italyBalkanPeninsula","malmoLund","nE_EScania","nGermany","northCentralSpain","northSweden","nWEngland","olandGotland","pyreneesGironaIbRange","relictsFs12","relictsFs13","russiaAsia","sEScania","sGermany","sTyrol","uFranceEFranceBIsles","westScania","wNCFrance")))
subData1 = subset(umapOut, (umapOut$region %in% c("IN","OH","MI","MA","CT","NY","NJ","MD","NC","USA","herbUSA")))
ggplot(umapOut)+
  theme_bw()+
  geom_point(data =subData,aes(emb1,emb2,fill=region),shape=23,size=rel(1.5), color="gray90",stroke=0.2, alpha=0.9)+scale_fill_manual(values = cols)+
  geom_point(data =subData1, mapping = aes(emb1,emb2), shape=21, fill="white", color="gray20", size=rel(1), alpha=0.6, stroke=0.3)+
  #geom_point(subData ,mapping=aes(emb1,emb2), shape=17, color="red", size=rel(2),position = position_nudge(y = -0.1), alpha=0.4)
  #geom_text_repel(subData, mapping=aes(emb1,emb2,label=region),alpha=0.2)
  theme(legend.position="NA", axis.title=element_text(size=15), axis.text=element_text(size=15)) +theme(plot.margin=unit(c(1,2,1,2), "cm"))
