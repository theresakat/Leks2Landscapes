# Use this script to perform exploratory analysis of your data

## Next steps ##
#   - review summary tables
#   - review stem and leaf plots
#   - create boxplots if necessary

source("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\Friedmans\\code\\func.r")

# # Load data for exploration
# setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\csv")
# BaseT2<-read.csv("BaseData_Task2.csv")

# Create variables
tablesDir<-c("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\tables")
sortedStatuses<-c("Occupied", "Occupied pending", "Unoccupied", "Unoccupied pending", "Historic", "No Data")

# # Create sorted factor for spatial units. The sort order is specified by the [c(5,4,6,...)]
# BaseT2$scaleSort <- factor(BaseT2$SCALE, levels=levels(BaseT2$SCALE)[c(1,2,3)])
# levels(BaseT2$scaleSort)

# Create sorted factor for occupancy status
BaseT2a<-factorSort(BaseT2$Status,sortedStatuses,BaseT2)
BaseT2a$x<-factor(BaseT2$Status,sortedStatuses)
names(BaseT2a)[1]<-c("statusSort")
BaseT2<-BaseT2a
rm(BaseT2a)

# Basic data summary
summary(BaseT2)

# Summary table of statusSort, scale, RCCI, and landscape vars
summary(BaseT2)[,c(1,3,8,9,11:18)]

# a<-as.matrix(table(BaseT2$statusSort))
# b<-as.matrix(table(BaseT2$SCALE))
# c<-as.matrix(summary(BaseT2$RCCI))
# d<-as.matrix(summary(BaseT2)[,c(11:18)])

# Summary table of the number of polys per PAC
x<-droplevels(BaseT2[BaseT2$SCALE=="mpPAC", ])
tabular(LABEL+1~(n=1), data = x)

# Some tables from a melted data set without PIDs or FIDs
base_long<-omitIDs(BaseT2,base_long)
head(base_long)
levels(base_long$variable)

# Summary table of variables by spatial units
bs<- tabular( Heading("Variable")*(variable+1) ~ 
                (Heading("Spatial Unit")*SCALE + 1) * Heading()*value*((n=1) + Format(digits=1, scientific = FALSE)*(mean + sd + se + Vstar)), 
              data = base_long)
bs
setwd(tablesDir)
write.csv.tabular(bs, file = "tblBaseT2_summary.csv")

# Summary table of variables by spatial unit and occupancy status
bs2<- tabular( (Heading("Spatial Unit")*SCALE + 1) * Status+1 ~ 
                 (variable+1)* Heading()*value*((n=1) + Format(digits=1, scientific = FALSE)*(mean + sd + se + Vstar)),
               data = base_long)
bs2
setwd(tablesDir)
write.csv.tabular(bs2, file = "tblBaseT2_byStatus_summary.csv")
rm(sub1,bs,bs2)


# Stem and leaf plots
stem(BaseT2$AREA_HA)
stem(BaseT2$RCCI)
stem(BaseT2$EVT_Sagebrush)
stem(BaseT2$EVT_Agriculture)
stem(BaseT2$EVT_Developed)
stem(BaseT2$EVT_Pasture)
stem(BaseT2$EVT_Meadows)
stem(BaseT2$EVT_Wyoming.Sagebrush)
stem(BaseT2$EVT_Mountain.Sagebrush)
stem(BaseT2$EVT_Other.Woodland)

histogram(BaseT2$AREA_HA)
myData<-BaseT2
x<-droplevels(myData[myData$AREA_HA > quantile(myData$AREA_HA, 0.05), ])
histogram(x$AREA_HA)
stem(x$AREA_HA)

# Boxplots
boxplot(BaseT2$AREA_HA)


# Kruskal-Wallis

#   a. Kruskal-Wallis rank sum test to test for significant differences among the occupancy statues
#     5b1. Perform the test
sag<-kruskal.test(EVT_Sagebrush ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
agr<-kruskal.test(EVT_Agriculture ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
dev<-kruskal.test(EVT_Developed ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
pas<-kruskal.test(EVT_Pasture ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
mea<-kruskal.test(EVT_Meadows ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
wyo<-kruskal.test(EVT_Wyoming.Sagebrush ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
mtn<-kruskal.test(EVT_Mountain.Sagebrush ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
otw<-kruskal.test(EVT_Other.Woodland ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])


#    b. compile data into a table-like format and export it (note: kwResults is a data frame of Htest objects. I don't 
#         have the knowledge to manipulate the Htest objects.)
kwResults<-rbind(sag,agr,dev,pas,mea,wyo,mtn,otw)
# dimnames(kwResults)[[2]]<-c("H statistic", "df", "p.value", "method", "data.name")
setwd(tablesDir)
write.csv(kwResults, file = "kwResults.csv")

rm(sag, agr,dev,pas,mea,wyo,mtn,otw)



# of possible use
x<-lek_lc[nchar(lek_lc$ID)>7,]
