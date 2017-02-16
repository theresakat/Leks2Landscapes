# for_Report.R
# 
# Purpose: use this script to generate graphics for the report
#
# Created: November 19, 2016
#


source("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\Friedmans\\code\\func.r")

# # Load data for exploration
# setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\csv")
# BaseT2<-read.csv("BaseData_Task2.csv")
base_longtest <- melt(subset(BaseT2, select = c(-PID, -FID, -RASTER)), 
                  id = c("statusSort", 
                         "SCALE", 
                         "FEATURENAME", 
                         "LABEL", 
                         "Status",
                         "AREA_CLUSTER", 
                         "RCCI_CLUSTER", 
                         "groups_num",
                         "groupSort",
                         "groups2"))

# Create variables
tablesDir<-c("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\tables")


## Summary table of variables by area-RCCI group for occupancy = Occupied
tab_areashp <- tabular( (groupSort+1) ~  
                         ((n=1) + Format(digits=1, scientific = FALSE)*RCCI*(min + mean + max + Vstar)), 
                       data = base_long[base_long$statusSort == "Occupied",])
tab_areashp

bs3<- tabular( Heading("Variable")*(variable+1) ~ 
                 (Heading("Area-Shape Group")*groupSort + 1) * Heading()*value*((n=1) + Format(digits=1, scientific = FALSE)*(mean + sd + se + Vstar)), 
               data = base_long[base_long$statusSort == "Occupied",])
bs3

# Summary table of variables by spatial unit for occupancy = Occupied
bs4<- tabular( Heading("Variable")*(variable+1) ~ 
                 (Heading("Spatial Unit")*SCALE + 1) * Heading()*value*((n=1) + Format(digits=1, scientific = FALSE)*(mean + sd + se + Vstar)), 
               data = base_long[base_long$statusSort == "Occupied",])
bs

setwd(tablesDir)
write.csv.tabular(bs, file = "tblBaseT2_Occupied_summary.csv")
