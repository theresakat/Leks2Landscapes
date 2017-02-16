# Use this script to perform exploratory analysis of your data

## Next steps ##
#   - review summary tables
#   - review stem and leaf plots
#   - create boxplots if necessary

source("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\Friedmans\\code\\func.r")

# # Load data for exploration
setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\csv")
BaseT2_wide<-read.csv("BaseData_Task2_wide.csv")

# Create variables
tablesDir<-c("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\tables")


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

# Summary table of variables by area-RCCI group for occupancy = Occupied
bs3<- tabular( Heading("Variable")*(variable+1) ~ 
                 (Heading("groups")*groups + 1) * Heading()*value*((n=1) + Format(digits=1, scientific = FALSE)*(mean + sd + se + Vstar)), 
               data = base_long[base_long$statusSort == "Occupied",])
bs3

# Summary table of variables by spatial unit for occupancy = Occupied
bs4<- tabular( Heading("Variable")*(variable+1) ~ 
                (Heading("Spatial Unit")*SCALE + 1) * Heading()*value*((n=1) + Format(digits=1, scientific = FALSE)*(mean + sd + se + Vstar)), 
              data = base_long[base_long$statusSort == "Occupied",])
bs4

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


# Explore clusters
levels(BaseT2$AREA_CLUSTER)<-c("Medium", "Large", "Small")
#levels(BaseT2$RCCI_CLUSTER)<-c("More regular", "Irregular", "Somewhat irregular")
levels(BaseT2$RCCI_CLUSTER)<-c("Irregular", "Regular", "Less regular")
table(BaseT2$AREA_CLUSTER,BaseT2$RCCI_CLUSTER)
table(BaseT2$statusSort,BaseT2$AREA_CLUSTER)
table(BaseT2$statusSort,BaseT2$RCCI_CLUSTER)

tabular(AREA_CLUSTER ~ (n=1) + (AREA_HA)*(min+Mean+max+sd), data=BaseT2)
tabular(RCCI_CLUSTER ~ (n=1) + (RCCI)*(min+Mean+max+sd), data=BaseT2)
tabular(groupSort ~ (n=1) + (AREA_HA + RCCI)*(min+Mean+max+sd), data = BaseT2 )
table(BaseT2$AREA_CLUSTER,BaseT2$RCCI_CLUSTER) # TABLE SHOWING THAT FRIEDMAN'S IS NOT VALID

# Kruskal-Wallis

#   1a. Kruskal-Wallis rank sum test to test for significant differences among the occupancy statues
sag<-kruskal.test(EVT_Sagebrush ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
agr<-kruskal.test(EVT_Agriculture ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
dev<-kruskal.test(EVT_Developed ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
pas<-kruskal.test(EVT_Pasture ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
mea<-kruskal.test(EVT_Meadows ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
wyo<-kruskal.test(EVT_Wyoming.Sagebrush ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
mtn<-kruskal.test(EVT_Mountain.Sagebrush ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])
otw<-kruskal.test(EVT_Other.Woodland ~ statusSort, data = BaseT2[BaseT2$statusSort != "No Data",])


#   1b. compile data into a table-like format and export it (note: kwResults is a data frame of Htest objects. I don't 
#         have the knowledge to manipulate the Htest objects.)
kwResults<-rbind(sag,agr,dev,pas,mea,wyo,mtn,otw)
# dimnames(kwResults)[[2]]<-c("H statistic", "df", "p.value", "method", "data.name")
setwd(tablesDir)
write.csv(kwResults, file = "kwResults.csv")

rm(sag, agr,dev,pas,mea,wyo,mtn,otw)



### Exploration: occupied records only for leks, complexes, and mpPacs ###

myData <- BaseT2[BaseT2$statusSort == "Occupied",]

tabular(AREA_CLUSTER ~ (n=1) + (AREA_HA)*(min+Mean+max+sd), data=BaseT2 )
tabular(RCCI_CLUSTER ~ (n=1) + (RCCI)*(min+Mean+max+sd), data=BaseT2 )
tabular(groupSort ~ (n=1) + (AREA_HA + RCCI)*(min+Mean+max+sd), data = BaseT2 )
tabular(SCALE ~ (n =1) + (RCCI_CLUSTER) + (AREA_CLUSTER), data=BaseT2 )
table(BaseT2$AREA_CLUSTER,BaseT2$RCCI_CLUSTER)

table(myData$SCALE, myData$RCCI_CLUSTER)
hist(myData$AREA_HA)[myData$SCALE=="snglLek" & myData$RCCI_CLUSTER=="Irregular"]
tabular()


myData <- BaseT2[BaseT2$SCALE == "mpPAC" & BaseT2$statusSort == "Occupied" & BaseT2$AREA_HA > 7900,]
plotData<-myData[,c(8,9,11:18)]  #RCCI, AREA_HA, EVT_Ag:WySagebrush
plotData<-myData[,c(26,11:18)]  #AREA_HA*RCCI, EVT_Ag:WySagebrush

pairs(plotData, upper.panel = panel.cor)
attach(myData)

hist(AREA_HA)
hist(log(AREA_HA)) # Use this distribution
hist(1/AREA_HA)
hist(1/AREA_HA^2)

hist(RCCI)
hist(log(RCCI))
hist(1/RCCI)
hist(1/RCCI^2)

a<-myData[myData$SCALE=="snglLek",]
hist(a$RCCI)
a[1:10,c(1,3,8,9,24)]
tail(a[,c(1,3,8.9,24)])
rm(a)

# Boxplots
boxplot(myData$EVT_Sagebrush~myData$groupSort)
boxplot(myData$EVT_Agriculture~myData$groupSort)
boxplot(myData$EVT_Developed~myData$groupSort)

boxplot(myData$EVT_Sagebrush~myData$SCALE)
boxplot(myData$EVT_Agriculture~myData$SCALE)
boxplot(myData$EVT_Developed~myData$SCALE)

# Kruskal-Wallis rank sum test to test for significant differences among the area-RCCI groups

myData <- BaseT2[BaseT2$statusSort == "Occupied",]
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


### Exploration: mpPacs only (all are "occupied")  ###
myData <- BaseT2[BaseT2$SCALE == "mpPAC" & BaseT2$statusSort == "Occupied",]
plot((myData$AREA_HA*myData$RCCI), myData$EVT_Sagebrush)

myData <- BaseT2[BaseT2$AREA_HA < 7600 & BaseT2$statusSort == "Occupied",]
plot((myData$AREA_HA*myData$RCCI), myData$EVT_Sagebrush)

myData <-BaseT2[BaseT2$SCALE == "snglLek" & BaseT2$statusSort == "Occupied",]
plot((myData$AREA_HA*myData$RCCI), myData$EVT_Sagebrush)
hist(myData$EVT_Sagebrush)
table(myData$statusSort)


pairs(iris, upper.panel = panel.cor)
plotData<-myData[,c(8,9,11:18)]
pairs(plotData, upper.panel = panel.cor)


myData <-BaseT2[BaseT2$SCALE == "dslvComplex" & BaseT2$statusSort == "Occupied",]

# of possible use
x<-lek_lc[nchar(lek_lc$ID)>7,]



