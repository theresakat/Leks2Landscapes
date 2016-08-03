####################################################################################
# use this script to hold a majority of the lines from "analysis_v0.2.R" (C:\temp\BLM Leks to Landscapes Project_287315\code\Task2) for cleaning the data.

# Clean the following data sets to build the data for Friedman's (and OLS)
# 
# 
# 1. Fragstats CLASS output files for complexes and single leks
# 2. Fragstats PATCH output files (multipart PACs only)
# 3. patch area data (created by Fragstats & exported from polygon attribute tale using Arc)
# 4. landscape summaries
#   a. mpPacs
#   b. leks/lek complexes
#
####################################################################################


### 1. clean Fragstats CLASS output files

#   1a. combine Action Areas, BLM Districts, and Populations into a data frame - not used presently
#b1<-[some steps to add on the spatial unit type]
#b2<-subset(rbind(a1,a2,a5),select = c(FID, ID, LID, TYPE, AREA_MN, CIRCLE_MN))

#   1b. combine lek-scale data (snglLeks), trim white space from "TYPE" field (contains ODFW site IDs), 
#       make dissolved complex FIDs distinct from snglLeks$FIDs

compfid <- a3$FID + nrow(a6)
a3$FID <- compfid
a3a <- a3[a3$AREA_MN > 7853.6,]
a3a$ID<-factor(str_trim(a3a$ID, side = c("both")))
# write.csv(a3a, file ="dslvLeksSamp_sub2.csv")

#   1c. insert the correct snglLeks CIRCLE and AREA values into snglLeks. [Note: vector to raster 
#       conversion of snglLeks didn't work due to overlapping leks. Since all single leks should be circles, 
#       they should all have the same RCCI and area. I should have computed CIRCLE on a single lek, instead 
#       of the whole set of single leks.] 
#       The following subset results in a mean area of 7854 and is close enough to the true value.

x1<-a6[a6$AREA_MN > 7853 & a6$AREA_MN < 7860,]  

a6$CIRCLE_MN<-mean(x1$CIRCLE_MN)
a6$AREA_MN<-mean(x1$AREA_MN)

grouse<-rbind(a6,a3a)
grouse$TYPE<-factor(str_trim(grouse$TYPE, side = c("both")))
rm(compfid,a3,a3a,a6)



### 2 & 3. merge & clean Fragstats outputs (mpPACs only; output formerly called "pacsPatch") and mpPac areas
mpPac<-subset(merge(mpPac_frag,
                        mpPac_area, 
                        by.x = "PID", 
                        by.y = "gridcode"), 
                  select = c(-PID,
                             -SHAPE, -SHAPE_CSD, -SHAPE_CPS,
                             -CIRCLE_CSD, -CIRCLE_CPS,-CIRCLE_LSD,-CIRCLE_LPS,
                             -OBJECTID_1, -OBJECTID, -Id, -Shape_Leng, -Shape_Length, -Shape_Area,
                             -sqkm, -ac))
names(mpPac)<-c("FID", "FEATURENAME", "RASTER","LABEL", "RCCI", "SCALE","AREA_HA")
str(mpPac)


# 4. clean LANDSCAPE SUMMARIES

#   4a. mpPac_lc landscape condition summaries (multipart PACs (mpPACs)) 

#     5a1. manipulate fields: change pacPatch "ha" field name to "Area_ha"
names(pacsPatch)
names(pacsPatch)[7]<-"AREA_ha"
names(pacsPatch)


#   5b. leks and complexes (DRWM data) / 4. clean Max's lek/complex DRWM data

#   4a. merge Max's file with mine and subset result

lut<-subset(l1, select = c("ID", "Status"))
grouse1<-merge(grouse,lut, by.x = "TYPE", by.y = "ID")
grouse1<-subset(grouse1, select = c("FID", "ID", "LID", "TYPE", "AREA_MN", "CIRCLE_MN","nScale","Status"))
str(grouse1)
write.csv(grouse1, "C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\csv\\grouse_task2.csv")
rm(l1,lut)


#     5b1. extract the Occupied leks and complexes
a<-grouse1[grouse1$Status == "Occupied",]

#     5b2. manipulate fields: change field order and names of the lek data fields to match pacPatch fields specified above
names(a)
leks<-a[c(1,2,3,4,6,7,5)]
names(leks)[5]<-"CIRCLE"
names(leks)[7]<-"AREA_ha"

names(leks)
names(pacsPatch)


#     5b3. combine the shape and area data for analysis
BaseT2 <- rbind(pacsPatch,leks)

#     5b4. merge summaries with BaseT2 to create final data frame
# [some merging code here]


