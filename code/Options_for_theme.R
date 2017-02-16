# theme() only works if after a compete theme
p + theme_bw() + theme(axis.title.x = element_text(colour="red", size=12))

# Options for the plotting area
p + theme(
  panel.grid.major = element_line(colour="red"),
  panel.grid.minor = element_line(colour="red", linetype="dashed", size=0.2),
  panel.background = element_rect(fill="lightblue"),
  panel.border = element_rect(colour="blue", fill=NA, size=2))

# Options for text items
p + ggtitle("Plot title here") +
  theme(
    axis.title.x = element_text(colour="red", size=14),
    axis.text.x  = element_text(colour="blue"),
    axis.title.y = element_text(colour="red", size=14, angle = 90),
    axis.text.y  = element_text(colour="blue"),
    plot.title = element_text(colour="red", size=20, face="bold"))

# Options for the legend
p + theme(
  legend.background = element_rect(fill="grey85", colour="red", size=1),
  legend.title = element_text(colour="blue", face="bold", size=14),
  legend.text = element_text(colour="red"),
  legend.key = element_rect(colour="blue", size=0.25))

# Options for facets
p + facet_grid(sex ~ .) + theme(
  strip.background = element_rect(fill="pink"),
  strip.text.y = element_text(size=14, angle=-90, face="bold"))
# strip.text.x is the same, but for horizontal facets