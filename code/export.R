# 5_export.R



library(reshape2)

# TASK: CREATE LONG FORM OF repWMs_AV_2015 DATA FOR IMPORT TO BASE DATABASE

x_long<-melt(x, id.vars = c("ID")) # WARNING MESSAGE RECEIVED: Warning message:
# attributes are not identical across measure variables; they will be dropped 


TRY: x_long<-melt(x, id.vars = c("ID"), variable.name = "nLabel", value.name = "nValue", factorsAsStrings = FALSE)