
library(ggplot2)
library(RColorBrewer)
# View all ColorBrewer palettes
# display.brewer.all()  

vars <- levels(base_long2$variable)[3:10]
df <- subset(base_long2, variable %in% vars)

p <- ggplot(df, aes(x=SCALE, y=value, fill=variable)) + geom_bar(position="dodge", stat="identity") + coord_polar()

p + scale_fill_discrete()  # creates blue bars
p + scale_fill_brewer() # creates blue bars

p + scale_fill_brewer(palette = "Greens")
p + scale_fill_brewer(palette = "YlGnBu") + theme_bw()  + ggtitle("Plot Title") # adding theme_bw() makes the background white

# Add Lines to separate the spatial unit types. xintercept seems to see the categories for spatial units as integers ranging from 1 to 3
p + geom_vline(xintercept = .5, size = 1) + geom_vline(xintercept = 1.5, size = 1) + geom_vline(xintercept = 2.5, size = 1)

# And another circular plot source:  http://www.r-graph-gallery.com/224-basic-circular-plot/
#   and http://www.r-graph-gallery.com/226-plot-types-for-circular-plot/

install.packages("circlize")
library(circlize)

# Create data
data = data.frame(
  factor = sample(letters[1:8], 1000, replace = TRUE),
  x = rnorm(1000), 
  y = runif(1000)
)

# Step1: Initialise the chart giving factor and x-axis.
circos.initialize( factors=data$factor, x=data$x )

# Step 2: Build the regions. 
circos.trackPlotRegion(factors = data$factor, y = data$y, panel.fun = function(x, y) {
  circos.axis()
})

# Step 3: Add points
circos.trackPoints(data$factor, data$x, data$y, col = "blue", pch = 16, cex = 0.5) 


