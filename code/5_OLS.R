# Explore

source("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\Friedmans\\code\\func.r")

myData <- BaseT2[BaseT2$statusSort == "Occupied",]

attach(myData)

hist(AREA_HA)
hist(log(AREA_HA)) # Use this distribution
hist(1/AREA_HA)
hist(1/AREA_HA^2)

tabular(AREA_CLUSTER ~ (n=1) + (AREA_HA)*(min+Mean+max+sd), data=BaseT2)
tabular(RCCI_CLUSTER ~ (n=1) + (RCCI)*(min+Mean+max+sd), data=BaseT2)
tabular(groups ~ (n=1) + (AREA_HA + RCCI)*(min+Mean+max+sd), data = BaseT2 )
table(BaseT2$AREA_CLUSTER,BaseT2$RCCI_CLUSTER)

hist(RCCI)
hist(log(RCCI))
hist(1/RCCI)
hist(1/RCCI^2)

table(AREA_CLUSTER,RCCI_CLUSTER)

ols<-lm(EVT_Agriculture ~ log(AREA_HA) + 1/RCCI^2)
summary(ols)
hatmean<-mean(hatvalues(ols)) # can also calculate this as avghat <- ncol(x)/nrow(x) where x is assigned during the OLS
plot(hatvalues(ols))
abline(h=1*(ncol(x))/nrow(x))
abline(h=2*(ncol(x))/nrow(x))
abline(h=3*(ncol(x))/nrow(x))

hist(1/(RCCI)^2)
qqnorm(log(AREA_HA^2))
qqnorm(1/(RCCI)^2)
qqnorm(RCCI)
density.default(x = rstudent(ols))
plot(density.default(x = rstudent(ols)))

ols2<-lm(EVT_Agriculture~log(AREA_HA)+(1/(RCCI^2)))
summary(ols2)
plot(density.default(x = rstudent(ols2)))
plot(EVT_Agriculture,AREA_HA)
