setwd('/mnt/bigdisk/work/northAmericanArabidopsis/americanarabidopsis/environmental_factor_analysis')
envemb <- read.table("umapEmbedding2RegionsOutput_onlyTargetGroupsOutput.txt", header=T)
library(ggplot2)
library(ggthemes)
library(ggrepel)
cols= c("azerbaijanGeorgia"="#00ADEF","cSouthItaly"="#9D248E","italyBalkanPeninsula"="#7BAA47","britishIsles1"="#F6BF97","northSweden"="#9F8BAA","russiaAsia"="#5E4E43","cEuropeBaltic"="#A0B782","westScania"="#0AA249","nE_EScania"="#AF372F","malmoLund"="#7773B5","olandGotland"="#3C3869","sEScania"="#B75250","sTyrol"="#7CC393","nGermany"="#777364","sGermany"="#E51856","nWEngland"="#53190D","uFranceEFranceBIsles"="#532D90","wNCFrance"="#9C9450","britishIsles2"="#7C98CE","relictsFs12"="#231F20","relictsFs13"="#58585B","barcelona"="#88226D","pyreneesGironaIbRange"="#A7919D","centralSpain1"="#619DD4","northCentralSpain"="#F26A21","centralSpain2"="#00AC4D","andalusiaPortugal"="#005CA2","nAm"="white")
subData = subset(envemb, (envemb$region %in% c("uFranceEFranceBIsles","britishIsles1","nGermany")))
subDataAm = subset(envemb, (envemb$group %in% c("nAm")))
ggplot(envemb)+
  theme_bw()+
  geom_point(data =subset(envemb, region == "nAm"), mapping = aes(emb1,emb2), shape=21, fill="white", color="gray60", size=rel(3), alpha=0.8, stroke=0.2)+
  geom_point(data =subset(envemb, region != "nAm"),aes(emb1,emb2,color=region),shape=18,size=rel(3), alpha=0.8)+scale_color_manual(values = cols)+
  #geom_point(subData ,mapping=aes(emb1,emb2), shape=17, color="red", size=rel(2),position = position_nudge(y = -0.1), alpha=0.4)
  geom_text_repel(subDataAm, mapping=aes(emb1,emb2,label=cluster),alpha=0.8, size=rel(2))+
  theme(legend.position="NA", axis.title=element_text(size=15), axis.text=element_text(size=15)) +theme(plot.margin=unit(c(1,2,1,2), "cm"))
