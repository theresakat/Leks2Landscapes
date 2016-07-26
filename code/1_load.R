# Use this script to load your data for clean up. 

# Load the following to build the data for Friedman's (and OLS)
# 
# 1. load fragstats output files for complexes, single leks
# 2. load fragstats output files for PACs
# 3. load landscape summaries for appending to leks/complexes/PACs using the clean.R script
# 

# Sample loading code that reads a directory #
# library(plyr) 
# 
# files <- dir("raw", full = T) 
# names(files) <- gsub("\\.csv", "", dir("raw")) 
#  
#  
# # Load all csv files into a single data frame and give informative column 
# # names 
#  
#  
# bnames <- ldply(files, read.csv, header = F, skip = 1, nrows = 1000, stringsAsFactors = FALSE) 
# names(bnames) <- c("file", "rank", "boy_name", "boy_num", "girl_name", "girl_num") 


# Source the functions #

library(stringr)
source("C:\\temp\\BLM Leks to Landscapes Project_287315\\code\\Task2\\functions\\readPatch.R")
source("C:\\temp\\BLM Leks to Landscapes Project_287315\\code\\Task2\\functions\\readClass.R")
source("C:\\temp\\BLM Leks to Landscapes Project_287315\\code\\Task2\\functions\\readPolyAtt.R")


# Load Data #

#### I. Load Task2 data sets for Friedmans and OLS ##########

# 1. import Fragstats CLASS output files
setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\results")
a3<-readClass("dslvCmplxSamp.class.csv", "dslvComplex")
a6<-readClass("snglLeks.class.csv","snglLek")

# 2. import Max's lek/complex DRWM data (get Max's file)
myFile <- "C:\\Users\\tburcsu\\Google Drive\\BLM Leks to Landscapes Project\\Data\\Lek Data\\repWMsAV_2015.csv"
l1<-read.csv( myFile,header=T)
lut<-subset(l1, select = c("ID", "Status"))

# 3. import Fragstats outputs (PACs only)
setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\results")
p1<-readPatch("pacs.patch.csv", "PAC")

# 4. import patch area data (exported from polygon attribute table?)
setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\raw")
p2<-readPolyAtt("pacs_patches_raw.csv")

# 5. import landscape summaries

#   5a. for 'pacsPatch' (aka. multipart PACs (mpPACs))
setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\data\\raw")


#   5b. for leks and complexes (DRWM data)
setwd(xxxxxxxxxxx)
