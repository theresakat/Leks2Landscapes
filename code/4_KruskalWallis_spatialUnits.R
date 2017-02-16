# 4_KruskalWallis.R
# 
# Purpose: use this script to generate the reported results for Kruskal-Wallis rank sum tests
# 
# Kruskal-Wallis rank sum test to test for significant differences among the spatial units, occupied records

source("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\Friedmans\\code\\func.r")

# # Load data for analysis
# setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\csv")
# BaseT2<-read.csv("BaseData_Task2.csv")
myData <- BaseT2[BaseT2$statusSort == "Occupied",]

# Create variables
tablesDir<-c("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\tables")

# Kruskal-Wallis test
sag<-kruskal.test(EVT_Sagebrush ~ SCALE, data = myData)
agr<-kruskal.test(EVT_Agriculture ~ SCALE, data = myData)
dev<-kruskal.test(EVT_Developed ~ SCALE, data = myData)
pas<-kruskal.test(EVT_Pasture ~ SCALE, data = myData)
mea<-kruskal.test(EVT_Meadows ~ SCALE, data = myData)
wyo<-kruskal.test(EVT_Wyoming.Sagebrush ~ SCALE, data = myData)
mtn<-kruskal.test(EVT_Mountain.Sagebrush ~ SCALE, data = myData)
otw<-kruskal.test(EVT_Other.Woodland ~ SCALE, data = myData)
are<-kruskal.test(AREA_HA ~ SCALE, data = myData)
rcc<-kruskal.test(RCCI ~ SCALE, data = myData)

kwResults<-rbind(sag,agr,dev,pas,mea,wyo,mtn,otw,are,rcc)
kwResults
# dimnames(kwResults)[[2]]<-c("H statistic", "df", "p.value", "method", "data.name")
setwd(tablesDir)
write.csv(kwResults, file = "kwResults_spatialUnits.csv")
rm(sag,agr,dev,pas,mea,wyo,mtn,otw,are,rcc)
