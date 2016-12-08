# 4_KruskalWallis.R
# 
# Purpose: use this script to generate the reported results for Kruskal-Wallis rank sum tests
# 
# Kruskal-Wallis rank sum test to test for significant differences among the area-RCCI groups

source("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\Friedmans\\code\\func.r")

# # Load data for analysis
# setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\csv")
# BaseT2<-read.csv("BaseData_Task2.csv")
myData <- BaseT2[BaseT2$statusSort == "Occupied",]

# Create variables
tablesDir<-c("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\tables")

# Kruskal-Wallis test
sag<-kruskal.test(EVT_Sagebrush ~ groupSort, data = myData)
agr<-kruskal.test(EVT_Agriculture ~ groupSort, data = myData)
dev<-kruskal.test(EVT_Developed ~ groupSort, data = myData)
pas<-kruskal.test(EVT_Pasture ~ groupSort, data = myData)
mea<-kruskal.test(EVT_Meadows ~ groupSort, data = myData)
wyo<-kruskal.test(EVT_Wyoming.Sagebrush ~ groupSort, data = myData)
mtn<-kruskal.test(EVT_Mountain.Sagebrush ~ groupSort, data = myData)
otw<-kruskal.test(EVT_Other.Woodland ~ groupSort, data = myData)

kwResults<-rbind(sag,agr,dev,pas,mea,wyo,mtn,otw)
kwResults
# dimnames(kwResults)[[2]]<-c("H statistic", "df", "p.value", "method", "data.name")
setwd(tablesDir)
write.csv(kwResults, file = "kwResults_area-RCCI.csv")
rm(sag,agr,dev,pas,mea,wyo,mtn,otw)