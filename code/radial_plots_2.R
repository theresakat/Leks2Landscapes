# Radial Plot of Land Cover Types within Area-Shape groups

# x = Area shape group --> as this is discrete, the scale will also need to be discrete
# y = value - height of the bars --> the land cover/variable value or proportion of each land cover type
# fill = the land cover types/variables that are graphed as bars


df<-base_long2[base_long2$statusSort == "Occupied" & base_long2$variable %in% vars,]

# Regular bar plot. This is the model to be translated into a circle
ggplot(df, aes(x=as.factor(groups), y=value, fill=variable)) +
  geom_bar(position = "dodge", stat = "identity") 

# Circular plot.
ggplot(df, aes(x=as.factor(groups), y=value, fill=variable)) +
  geom_bar(position = "dodge", stat = "identity") +
  coord_polar() + labs(x = "Area-shape group", y = "Proportion") + ggtitle("Proportions of Habitat Variables by Area-Shape Group")



