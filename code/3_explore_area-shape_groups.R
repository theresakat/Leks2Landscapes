# 3_explore_area-shape_groups.R

library(ggplot2)
qplot(value, data=df, binwidth = 0.3)
# This is equivalent to:
p <- ggplot(df, aes(x=value)) + geom_histogram(binwidth = 0.05)
p + facet_wrap(~ variable)
p + facet_grid(groups ~  variable)


# EXPLORE AREA-SHAPE GROUPS (2/15/2017)

# Area values

df<-as.data.frame(base_long[base_long$variable == "AREA_HA", 10]); names(df) <- c("value")

summary(df)
# value         
# Min.   :   166.9  
# 1st Qu.:  7853.7  
# Median :  7853.7  
# Mean   : 11881.2  
# 3rd Qu.:  7853.7  
# Max.   :327134.0  

p<-ggplot(df, aes(x=value))
p + geom_histogram(binwidth = 5000) + labs(x="Area") + ggtitle("Histogram of area values (ha)")

df2<-as.data.frame(df[df$value < 2000,1]); names(df2) <- c("value")
p<-ggplot(df2, aes(x=value))
p + geom_histogram()

# RCCI values
df<-as.data.frame(base_long[base_long$variable == "RCCI", 10]); names(df) <- c("value")

summary(df)
# value         
# Min.   :0.004700  
# 1st Qu.:0.008113  
# Median :0.008113  
# Mean   :0.036139  
# 3rd Qu.:0.008113  
# Max.   :0.762600  

# Boxplots of RCCI and Area in Area-Shape Groups show that I probably should have created area-shape groups using both variables together.
p<-ggplot(base_long[base_long$statusSort == "Occupied" & base_long$variable == "RCCI",], aes(x=as.factor(groups_num), y=value))
p + geom_boxplot() + labs(x = "Area-shape group", y = "RCCI") + ggtitle("RCCI within Area-Shape Groups")

p<-ggplot(base_long[base_long$statusSort == "Occupied" & base_long$variable == "scale(BaseT2$RCCI)",], 
          aes(x=as.factor(groups_num), y=value))
p + geom_boxplot() + labs(x = "Area-shape group", y = "scale(BaseT2$RCCI)") + ggtitle("RCCI within Area-Shape Groups")


p<-ggplot(base_long2[base_long2$statusSort == "Occupied" & base_long2$variable == "AREA_HA",], aes(x=as.factor(groups_num), y=value))
p + geom_boxplot() + labs(x = "Area-shape group", y = "Area (ha)") + ggtitle("Area Distributions within Area-Shape Groups")
