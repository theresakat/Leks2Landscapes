# Use this script to perform Friedman's analysis of your data



source(func.R)

# # Load data for analysis
# setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\csv")
# base_long<-read.csv("BaseData_Task2_long.csv")

levels(base_long$variable)

friedman.test(value ~ AREA_CLUSTER | RCCI_CLUSTER, data = base_long)

> friedman.test(value ~ AREA_CLUSTER | RCCI_CLUSTER, data = base_long)
Error in friedman.test.default(c(0.00811351351351351, 0.00811351351351351,  : 
  not an unreplicated complete block design
In addition: Warning messages:
1: In .HTMLsearch(query) : Unrecognized search field: title
2: In .HTMLsearch(query) : Unrecognized search field: keyword
3: In .HTMLsearch(query) : Unrecognized search field: alias
> 
  
# ** try: subsetting the data by landscape variable
x<-data.frame(as.factor(BaseT2$AREA_CLUSTER), as.factor(BaseT2$RCCI_CLUSTER), BaseT2$EVT_Agriculture)
names(x)<-c("AREA_CLUSTER", "RCCI_CLUSTER", "EVT_Agriculture")
friedman.test(x$EVT_Agriculture, x$AREA_CLUSTER, x$RCCI_CLUSTER)

#  subset also throws the "Error in friedman.test.default(x$EVT_Agriculture, x$AREA_CLUSTER, x$RCCI_CLUSTER) : 
  # not an unreplicated complete block design"

