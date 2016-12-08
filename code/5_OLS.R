# Explore

source("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\Friedmans\\code\\func.r")

# myData <- BaseT2[BaseT2$statusSort == "Occupied",]
myData <- BaseT2[BaseT2$SCALE == "mpPAC" & BaseT2$statusSort == "Occupied" & BaseT2$AREA_HA > 7900,]
attach(myData)

hist(AREA_HA)
hist(log(AREA_HA)) # Use this distribution
hist(1/AREA_HA)
hist(1/AREA_HA^2)

hist(RCCI) # Use this distribution
hist(log(RCCI))
hist(1/RCCI)
hist(1/RCCI^2)

table(AREA_CLUSTER,RCCI_CLUSTER)

ols<-lm(EVT_Agriculture ~ log(AREA_HA) + 1/RCCI^2) # not sure why, but this has sligtly better results.
ols<-lm(EVT_Agriculture ~ log(AREA_HA) + RCCI)
ols<-lm(EVT_Agriculture ~ log(AREA_HA) + RCCI + AreaRCCI)
ols<-lm(EVT_Agriculture ~ AREA_HA + RCCI + AreaRCCI)
summary(ols)
hatmean<-mean(hatvalues(ols)) # can also calculate this as avghat <- ncol(x)/nrow(x) where x is assigned during the OLS
plot(hatvalues(ols))
abline(h=1*(ncol(x))/nrow(x))
abline(h=2*(ncol(x))/nrow(x))
abline(h=3*(ncol(x))/nrow(x))

hist(1/(RCCI)^2)
qqnorm(log(AREA_HA))
qqnorm(log(AREA_HA^2))

qqnorm(1/(RCCI)^2)
qqnorm(RCCI)
density.default(x = rstudent(ols))
plot(density.default(x = rstudent(ols)))

ols2<-lm(EVT_Agriculture~log(AREA_HA)+(1/(RCCI^2)))
summary(ols2)
plot(density.default(x = rstudent(ols2)))
plot(EVT_Agriculture,AREA_HA)


# Run ols on the variables
depvars<-c(colnames(myData[,c(11:18)]))
indvars<-c(colnames(myData[,c(8,9,26)]))

write.table(cbind(paste("ols_", depvars,"<-lm(",depvars," ~ ", "AREA_HA + RCCI + AreaRCCI)",sep = "")), row.names = F,"olstmp.R",quote = F, col.names = F)
write.table(cbind(paste("summary(ols_",depvars,")",sep = "")), row.names = F,"olstmp_summary.R",quote = F, col.names = F)

source("olstmp.R")

summary(ols_EVT_Agriculture)
summary(ols_EVT_Developed)
summary(ols_EVT_Meadows)
summary(ols_EVT_Mountain.Sagebrush)
summary(ols_EVT_Other.Woodland)
summary(ols_EVT_Pasture)
summary(ols_EVT_Sagebrush)
summary(ols_EVT_Wyoming.Sagebrush)


