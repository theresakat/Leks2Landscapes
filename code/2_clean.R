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

# Define variables
#   Fragstats fields
fragnames_8<-c("PID", "FID", "FEATURENAME", "RASTER","LABEL", "RCCI", "SCALE","AREA_HA")

### 1. clean Fragstats CLASS output files (leks/complexes)

#   1a. combine Action Areas, BLM Districts, and Populations into a data frame - not used presently
#b1<-[some steps to add on the spatial unit type]
#b2<-subset(rbind(a1,a2,a5),select = c(FID, ID, LID, TYPE, AREA_MN, CIRCLE_MN))

#   1b. combine lek-scale data (dissolved and snglLeks), trim white space from "TYPE" and "ID" fields (contain ODFW site IDs), 
#       make dissolved complex FIDs distinct from snglLeks$FIDs
PID<-a3$FID   # dissolved complexes
a3<-cbind(PID,a3)
calcfid <- a3$FID + nrow(a6)
a3$FID <- calcfid
a3a <- a3[a3$AREA_MN > 7853.6,]

#   1c. insert the correct snglLeks CIRCLE and AREA values into snglLeks. [Note: vector to raster 
#       conversion of snglLeks didn't work due to overlapping leks. Since all single leks should be circles, 
#       they should all have the same RCCI and area. I should have computed CIRCLE on a single lek, instead 
#       of the whole set of single leks.] 
#       The following subset results in a mean area of 7854 and is close enough (imho) to the true value.

x1<-a6[a6$AREA_MN > 7853 & a6$AREA_MN < 7860,]  # single leks

a6$CIRCLE_MN<-mean(x1$CIRCLE_MN)
a6$AREA_MN<-mean(x1$AREA_MN)
PID<-a6$FID
a6<-cbind(PID,a6)
l1_frag<-rbind(a6,a3a)
l1_frag$TYPE<-factor(str_trim(l1_frag$TYPE, side = c("both")))
l1_frag$ID<-factor(str_trim(l1_frag$ID, side = c("both")))

lek_frag<-subset(l1_frag, select = c("PID", "FID", "ID", "LID", "TYPE", "CIRCLE_MN", "nScale", "AREA_MN"))
names(lek_frag)<-fragnames_8
rm(calcfid,a3,a3a,a6,x1)


### 2 & 3. Merge & clean Fragstats PATCH output files (mpPACs only; output formerly called "pacsPatch") and mpPac areas. Keep "ha".
mpPac_frag<-subset(merge(mpPac_frag.raw,
                        mpPac_area.raw, 
                        by.x = "PID", 
                        by.y = "gridcode"), 
                  select = c(-SHAPE, -SHAPE_CSD, -SHAPE_CPS,
                             -CIRCLE_CSD, -CIRCLE_CPS,-CIRCLE_LSD,-CIRCLE_LPS,
                             -OBJECTID_1, -OBJECTID, -Id, -Shape_Leng, -Shape_Length, -Shape_Area,
                             -sqkm, -ac))
names(mpPac_frag)<-fragnames_8
str(mpPac_frag)
mpPac_frag$SCALE<-c("mpPAC")
mpPac_frag<-cbind(mpPac_frag,c("Occupied")) # Add the status field to match the lek data
names(mpPac_frag)[9]<-c("Status")
str(mpPac_frag)
rm(mpPac_frag.raw, mpPac_area.raw)

### 4. clean LANDSCAPE SUMMARIES

#   Clean mpPac_lc landscape condition summaries (multipart PACs (mpPACs))
#   Remove records where nlabel = "Count"
a<-grep("Count", mpPac_lc$nLabel)
mpPac_lc<-mpPac_lc[-c(a),]
rm(a)

#   Create wide form of data (mpPac_lc)
x<-mpPac_lc
x_wide <- dcast(x, fun.aggregate = mean, NAME + nScale ~ nLabel, value.var = "nValue")
x_wide <- cbind(x_wide,1:nrow(x_wide))
x_wide <- x_wide[c(11,1,2,3,4,5,6,7,8,9,10)] # rearrange columns
head(x_wide)
names(x_wide)

#   pull names from leks_lc for use on x_wide/mpPac_lc_wide landscape variables. Leks_lc imported, no cleaning needed above.
lek_lc_names <-cbind(names(lek_lc))
tmpvarnames<-c("PID", "SCALE", lek_lc_names[c(3,6,11,12,14,15,17,19),])  # Ag, Dev, Meadows, MtnSage, OtherWood, Past, Sage, WySage
names(x_wide)<-c(tmpvarnames)
mpPac_lc<-x_wide

names(mpPac_lc)

#   Clean Leks and Lek Complexes (DRWM data) landscape summaries
#   clean Max's lek/complex DRWM data
lek_lc$ID<-factor(str_trim(lek_lc$ID, side = c("both")))
names(lek_lc)[1]<-c("repWM_ID")

#   Combine the frag, lc data for mpPacs and leks+complexes
mpPac_frie<-merge(mpPac_frag, mpPac_lc)  #matches on PID and SCALE fields
lek_frie<-subset(merge(lek_frag,
                       lek_lc, 
                       by.x = "FEATURENAME", 
                       by.y = "ID"),
                 select = c(names(mpPac_frie)))

# Combine mpPac and lek+complex data for Friedman's analysis                
BaseT2<- rbind(lek_frie,mpPac_frie)


### 5. Create the groups and blocks for Friedman test
# Prepare Data
ydata<-cbind(BaseT2,scale(BaseT2$AREA_HA), scale(BaseT2$RCCI))
x<-matrix(ydata[,19], ncol=1) #AREA_HA
x2<-matrix(ydata[,20], ncol=1) #RCCI

# Determine number of clusters
plot_wss(x)
plot_wss(x2)

# K-Means Cluster Analysis
fit <- kmeans(x, 3) # 3 cluster solution identified with plot_wss(x)
fit2 <- kmeans(x2, 3) # 3 cluster solution identified with plot_wss(x2)
# get cluster means 
aggregate(x,by=list(fit$cluster),FUN=mean)
aggregate(x2,by=list(fit2$cluster),FUN=mean)
# append cluster assignment
ydata <- cbind(ydata, fit$cluster)
ydata <- cbind(ydata, fit2$cluster)

names(ydata)[21]<-"AREA_CLUSTER"
names(ydata)[22]<-"RCCI_CLUSTER"

BaseT2<-ydata
rm(ydata)

# Create area-shape groups
BaseT2$groups<-as.factor(with(BaseT2, paste0(AREA_CLUSTER,RCCI_CLUSTER)))

# Create long form of the data
base_long <- melt(subset(BaseT2, select = c(-PID, -FID, -RASTER)), 
                  id = c("statusSort", 
                   "SCALE", 
                   "FEATURENAME", 
                   "LABEL", 
                   "Status",
                   "AREA_CLUSTER", 
                   "RCCI_CLUSTER", 
                   "groups"))


# Export data for archive and import later
setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\csv")
write.csv(BaseT2, file = "BaseData_Task2_wide.csv")
write.csv(base_long, file = "BaseData_Task2_long.csv")

# Clean up workspace
rm(x_wide, l1_frag, l2_frag, lek_lc_names, x, fragnames_8, PID, tmpvarnames, myFile, ydata, x,x2, fit, fit2)


# Extract the Occupied leks and complexes
# a<-l2_frag[l2_frag$Status == "Occupied",]






# Of possible Use
# #   merge Max's lek LC file with fragstats output for leks & lek complexes and subset result
# # lut<-subset(lek_lc, select = c("ID", "Status"))
# # l2_frag<-merge(l1_frag,lut, by.x = "TYPE", by.y = "ID")
# # lek_frag<-subset(l2_frag, select = c("PID", "FID", "ID", "LID", "TYPE", "CIRCLE_MN", "nScale", "AREA_MN", "Status"))

