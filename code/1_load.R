# Use this script to load your data for clean up using the 2_clean.R script. 
# Load the following to build the data for Friedman's (and OLS)
# 
# 1. Fragstats CLASS output files for complexes and single leks
# 2. Fragstats PATCH output files (multipart PACs only)
# 3. patch area data (created by Fragstats & exported from polygon attribute tale using Arc)
# 4. landscape summaries
#   a. mpPacs
#   b. leks/lek complexes
# 
# Sample loading code that reads a directory #
# library(plyr) 
# 
# files <- dir("raw", full = T) 
# names(files) <- gsub("\\.csv", "", dir("raw")) 
#    
# # Load all csv files into a single data frame and give informative column names   
# bnames <- ldply(files, read.csv, header = F, skip = 1, nrows = 1000, stringsAsFactors = FALSE) 
# names(bnames) <- c("file", "rank", "boy_name", "boy_num", "girl_name", "girl_num") 

# Source the functions #
library(stringr)
library(plyr)
source("C:\\temp\\BLM Leks to Landscapes Project_287315\\code\\Task2\\functions\\readPatch.R")
source("C:\\temp\\BLM Leks to Landscapes Project_287315\\code\\Task2\\functions\\readClass.R")
source("C:\\temp\\BLM Leks to Landscapes Project_287315\\code\\Task2\\functions\\readPolyAtt.R")

#### I. Load Task2 data sets for Friedmans and OLS ##########

### 1. import Fragstats CLASS output files
setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\results")
a3<-readClass("dslvCmplxSamp.class.csv", "dslvComplex") #formerly a3
a6<-readClass("snglLeks.class.csv","snglLek")  #formerly a6

### 2. import Fragstats outputs (mpPACs only)
setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\results")
mpPac_frag<-readPatch("pacs.patch.csv", "PAC") #formerly p1

### 3. import patch area data (created by Patch-level Fragstats analysis and exported from resulting polygon attribute table)
setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\gis_data\\multipartPAC_summaries")
mpPac_area<-readPolyAtt("mpPacs_pacs_patches_selection_FC_LUT.csv") #formerly p2

### 4. import landscape conditions summaries

#   4a. for 'pacsPatch' (aka. multipart PACs (mpPACs)) ## alternatively can use the mpPAC_Summaries.csv file
setwd("C:\\temp\\BLM Leks to Landscapes Project_287315\\Analysis\\SpatialScaling_task2\\gis_data\\multipartPAC_summaries")
files<-dir(pattern = "ZonalSt") #, full=T)
names(files) <- gsub("\\.csv", "", files)
mpPac_lc<-ldply(files, read.csv, header=F, skip=1)
names(mpPac_lc) <- c("variable","objectID", "gridcode","count", "area", "sum")

#   4b. for leks and complexes (DRWM data)
# setwd("C:\\Users\\tburcsu\\Google Drive\\BLM Leks to Landscapes Project\\Data\\Lek Data")
# lcDrwm<-read.csv(DRWM_and_singleLeks_data_20160524.csv,header=T) # or the file is ComplexDistRepWM_SingleLeks_data_20160515.csv
# # 4. import Max's lek/complex DRWM data (get Max's file)
myFile <- "C:\\Users\\tburcsu\\Google Drive\\BLM Leks to Landscapes Project\\Data\\Lek Data\\repWMsAV_2015.csv"
l1<-read.csv( myFile,header=T)


