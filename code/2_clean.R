####################################################################################
# use this script to hold a majority of the lines from "analysis_v0.2.R" (C:\temp\BLM Leks to Landscapes Project_287315\code\Task2) for cleaning the data.

# Clean the following data sets to build the data for Friedman's (and OLS)
# 
# 
# 1. Fragstats CLASS output files for complexes and single leks ==> lek_frag
# 2. Fragstats PATCH output files (multipart PACs only) ==> mpPac_frag
# 3. patch area data (created by Fragstats & exported from polygon attribute tale using Arc) ==> mpPac_area (temporary object)
# 4. landscape summaries
#   a. mpPacs ==> mpPac_lc
#   b. leks/lek complexes ==> lek_lc
# 5. combined RCCI and area data for leks, complexes, Pacs ==> BaseT2
#
# Intermediate output objects are:
# - lek_frag
# - mpPac_frag
# - mpPac_lc
# - lek_lc
#
# Final output object:  BaseT2
####################################################################################

library(reshape2)
library(stringr)
library(plyr)

### 1. clean Fragstats CLASS output files

#   1a. combine Action Areas, BLM Districts, and Populations into a data frame - not used presently
#b1<-[some steps to add on the spatial unit type]
#b2<-subset(rbind(a1,a2,a5),select = c(FID, ID, LID, TYPE, AREA_MN, CIRCLE_MN))

#   1b. combine lek-scale data (snglLeks), trim white space from "TYPE" field (contains ODFW site IDs), 
#       make dissolved complex FIDs distinct from snglLeks$FIDs

calcfid <- a3$FID + nrow(a6)
a3$FID <- calcfid
a3a <- a3[a3$AREA_MN > 7853.6,]
a3a$ID<-factor(str_trim(a3a$ID, side = c("both")))
# write.csv(a3a, file ="dslvLeksSamp_sub2.csv")

#   1c. insert the correct snglLeks CIRCLE and AREA values into snglLeks. [Note: vector to raster 
#       conversion of snglLeks didn't work due to overlapping leks. Since all single leks should be circles, 
#       they should all have the same RCCI and area. I should have computed CIRCLE on a single lek, instead 
#       of the whole set of single leks.] 
#       The following subset results in a mean area of 7854 and is close enough (imho) to the true value.

x1<-a6[a6$AREA_MN > 7853 & a6$AREA_MN < 7860,]  

a6$CIRCLE_MN<-mean(x1$CIRCLE_MN)
a6$AREA_MN<-mean(x1$AREA_MN)

l1_frag<-rbind(a6,a3a)
l1_frag$TYPE<-factor(str_trim(l1_frag$TYPE, side = c("both")))
rm(calcfid,a3,a3a,a6, x1)


### 2 & 3. merge & clean Fragstats outputs (mpPACs only; output formerly called "pacsPatch") and mpPac areas. Keep "ha".
mpPac_frag<-subset(merge(mpPac_frag.raw,
                        mpPac_area, 
                        by.x = "PID", 
                        by.y = "gridcode"), 
                  select = c(-FID,
                             -SHAPE, -SHAPE_CSD, -SHAPE_CPS,
                             -CIRCLE_CSD, -CIRCLE_CPS,-CIRCLE_LSD,-CIRCLE_LPS,
                             -OBJECTID_1, -OBJECTID, -Id, -Shape_Leng, -Shape_Length, -Shape_Area,
                             -sqkm, -ac))
names(mpPac_frag)<-c("PID", "FEATURENAME", "RASTER","LABEL", "RCCI", "SCALE","AREA_HA")
str(mpPac_frag)
mpPac_frag$SCALE<-c("mpPAC")
mpPac_frag<-cbind(mpPac_frag,c("Occupied")) # Add the status field to match the lek data
names(mpPac_frag)[8]<-c("Status")
str(mpPac_frag)
rm(mpPac_frag.raw, mpPac_area)

# 4. clean LANDSCAPE SUMMARIES

#   4a. mpPac_lc landscape condition summaries (multipart PACs (mpPACs))
#   Remove records where nlabel = "Count"
a<-grep("Count", mpPac_lc$nLabel)
mpPac_lc<-mpPac_lc[-c(a),]
rm(a)

#   Create wide form of data
x<-mpPac_lc
x_wide <- dcast(x, fun.aggregate = mean, NAME + nScale ~ nLabel, value.var = "nValue")
x_wide <- cbind(x_wide,1:nrow(x_wide))
x_wide <- x_wide[c(11,1,2,3,4,5,6,7,8,9,10)]
head(x_wide)
names(x_wide)

# pull names from leks_lc for use on x_wide/mpPac_lc_wide landscape variables
lek_lc_names <-cbind(names(lek_lc))
tmpvarnames<-c("PID", "SCALE", lek_lc_names[c(3,6,11,12,14,15,17,19),])  # Ag, Dev, Meadows, MtnSage, OtherWood, Past, Sage, WySage
names(x_wide)<-c(tmpvarnames)
mpPac_lc<-x_wide

names(mpPac_lc)

#   5b. leks and complexes (DRWM data) / 4. clean Max's lek/complex DRWM data

#   4a. merge Max's lek file with fragstats output for leks & lek complexes and subset result

lut<-subset(lek_lc, select = c("ID", "Status"))
l2_frag<-merge(l1_frag,lut, by.x = "TYPE", by.y = "ID")
l2_frag<-subset(l2_frag, select = c("FID", "ID", "LID", "TYPE", "AREA_MN", "CIRCLE_MN","nScale","Status"))
str(l2_frag)
# write.csv(lek_frag1, "C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\csv\\lek_frag1_task2.csv")
rm(l1_frag,lut)

#     5b2. manipulate fields: change field order and names of the lek data fields to match pacPatch fields specified above
names(l2_frag)
lek_frag<-l2_frag[c(1,2,3,4,6,7,5,8)]
names(lek_frag)<-names(mpPac_frag)

names(lek_frag)   
names(mpPac_frag)

rm(l2_frag,a)

#     5b3. combine the shape and area data for analysis
BaseT2 <- rbind(mpPac_frag,lek_frag)

#     5b4. merge landscape conditions summaries with BaseT2 to create final data frame
# [some merging code here]

#     5b1. extract the Occupied leks and complexes
a<-l2_frag[l2_frag$Status == "Occupied",]



