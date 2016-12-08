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

# Creates a scree-type plot for determining the number of groups to use for k-means clustering
plot_wss <- function(indata) {
  wss <- (nrow(x)-1)*sum(apply(x,2,var))
  for (i in 2:15) wss[i] <- sum(kmeans(x, 
  	centers=i)$withinss)
  plot(1:15, wss, type="b", xlab="Number of Clusters",
  ylab="Within groups sum of squares")
}

# Create a panel plot for input variables in data = x 
panel.cor <- function(x, y, digits = 2, cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  # correlation coefficient
  r <- cor(x, y)
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste("r= ", txt, sep = "")
  text(0.5, 0.6, txt)
  
  # p-value calculation
  p <- cor.test(x, y)$p.value
  txt2 <- format(c(p, 0.123456789), digits = digits)[1]
  txt2 <- paste("p= ", txt2, sep = "")
  if(p<0.01) txt2 <- paste("p= ", "<0.01", sep = "")
  text(0.5, 0.4, txt2)
}

