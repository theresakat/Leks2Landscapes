library(stringr)
library(plyr)
library(reshape2)
library(tables)

source("C:\\temp\\BLM Leks to Landscapes Project_287315\\code\\Task2\\functions\\readPatch.R")
source("C:\\temp\\BLM Leks to Landscapes Project_287315\\code\\Task2\\functions\\readClass.R")
source("C:\\temp\\BLM Leks to Landscapes Project_287315\\code\\Task2\\functions\\readPolyAtt.R")


Mean <- function(x) base::mean(x, na.rm=TRUE) ## fixes the NAs in the means, but not the NAs in the variables n's or SE
cv <- function(x) (sd(x, na.rm=TRUE)/mean(x, na.rm=TRUE)*100) # biased CV
Vstar<-function(x) (sd(x, na.rm=TRUE)/mean(x, na.rm=TRUE)*100) * (1 + 1/(4*length(x))) # Unbiased coefficient of variation from Sokal and Rohlf
se <-function(x) sd(x)/sqrt(length(x))

# Function that melts the input data and removes the ID to make summaries using tabular easier
omitIDs<-function(indata) {
  sub <- subset(indata, select = c(-PID, -FID))
  out <- melt(sub)
  return(out)
}

factorSort<-function(inFactor, sortedLevels,indata) {
  x <- factor(inFactor, 
         levels = sortedLevels)
  out <- cbind(x,indata)
  return(out)
}

makeSubset <- function(x, varField, inVar) {
  nm <- colnames(x)
  varCol<-grep(varField,nm)
  param <- droplevels(subset(x, x[,varCol] == inVar))
}


plot_wss <- function(indata) {
  wss <- (nrow(x)-1)*sum(apply(x,2,var))
  for (i in 2:15) wss[i] <- sum(kmeans(x, 
  	centers=i)$withinss)
  plot(1:15, wss, type="b", xlab="Number of Clusters",
  ylab="Within groups sum of squares")
}
