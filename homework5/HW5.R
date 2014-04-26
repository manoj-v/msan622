library(ggplot2)
library(reshape2)
source("pretty.r")

# extract Years for grouping later
times <- time(Seatbelts)
Years <- factor(floor(times), ordered = TRUE)
Months <- factor(month.abb[cycle(times)],levels = month.abb,ordered = TRUE)

# BUILD THE DATA FRAME
myData <- data.frame(Seatbelts)
myData <- data.frame(
  times = as.numeric(times), 
  Years = Years, 
  Months = Months, 
  myData)
# names(myData)
# head(myData)
# pairs(myData[,-c(1,2,3)])

# MELT THE DATASET
melted <- melt(myData, id=c("Years", "Months", "times"))
melted

# CREATE A MULTILINE PLOT
p <- ggplot(subset(melted, variable == "DriversKilled"), 
  aes(x = Months, y = value, group = Years, color = Years)
)
p <- p + geom_line(alpha = 0.9)
p <- p + ggtitle("Multiple Lines Plot")
p <- p + theme_bw()
p <- p + theme(axis.title = element_blank())
p <- p + scale_x_discrete(expand=c(0,0))
p <- p + theme(panel.grid.major.x=element_line(size=0.15, color="grey"))
p <- p + theme(panel.grid.major.y=element_line(size=0.15, color="grey"))
p <- p + theme_guide() + theme_legend()
p
ggsave(filename="plot1.png")

# ROTATE THE MULTIPLE LINES PLOT TO GET A MULTIPLE STAR PLOT FOR BETTER INTERPRETATION
p <- p + theme(axis.text.y=element_blank(), axis.ticks.y=element_blank())
p <- p + coord_polar() + facet_wrap(~Years, nrow=2)
p <- p + ggtitle("Small Multiple Star Plot")
p <- p + theme(strip.background=element_blank())
p <- p + theme(panel.border=element_blank())
p <- p + theme(axis.text.x=element_text(size=6))
p
ggsave(filename="plot2.png")

# HEAT MAP VISUALIZATION TECHNIQUE
p <- ggplot(subset(melted, variable == "DriversKilled"),
            aes(x = Months, y = Years))
p <- p + geom_tile(aes(fill = value), colour = "white")
p <- p + scale_fill_gradient(low = "yellow", high = "red")
p <- p + theme_heatmap()
p
ggsave(filename="plot3.png")

# ROTATE THE HEATMAP FOR BETTER INTERPRETATION
p <- p + coord_polar()
p <- p + ggtitle("Circular Heatmap")
p <- p + theme(panel.background=element_blank())
p <- p + theme(panel.grid=element_blank())
p <- p + theme(axis.title=element_blank())
p <- p + theme(axis.ticks=element_blank()) 
p <- p + annotate("text", x=0, y=-9, label="Years increase outwardly", size=3)
p <- p + theme_heatmap() + theme(legend.direction="vertical")
p
ggsave(filename="plot4.png")

# subsetD <- subset(melted, variable == "DriversKilled")
# p2 <- ggplot(subsetD, aes(x=times, y=value, fill=value)) +
#   geom_tile(colour="blue") +
#   scale_fill_gradient(low = "yellow", high = "red") +
#   ylim(c(0, max(subsetD$value) + 0.5)) +
#   #   scale_y_discrete(breaks=y_breaks, labels=y_labels) +
#   coord_polar(theta="x") +
#   theme(panel.background=element_blank(),
#         axis.title=element_blank(),
#         panel.grid=element_blank(),
#         axis.text.x=element_blank(),
#         axis.ticks=element_blank(),
#         axis.text.y=element_text(size=5))
# p2
