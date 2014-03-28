library(ggplot2) 

# Datasets
data(movies) 
data(EuStockMarkets)

# Cleanup the movie dataset
# Filter out rows with 0, negative or no budget information and remove
idx <- which(movies$budget <=0 | is.na(movies$budget))
movies <- movies[-idx,]

# Data
genre <- rep(NA, nrow(movies))
count <- rowSums(movies[, 18:24])
genre[which(count > 1)] = "Mixed"
genre[which(count < 1)] = "None"
genre[which(count == 1 & movies$Action == 1)] = "Action"
genre[which(count == 1 & movies$Animation == 1)] = "Animation"
genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
genre[which(count == 1 & movies$Drama == 1)] = "Drama"
genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
genre[which(count == 1 & movies$Romance == 1)] = "Romance"
genre[which(count == 1 & movies$Short == 1)] = "Short"

# EU dataset for Plot4
eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))

# Add the Genre column to the movies2 dataframe
movies$Genre <- movies$Genre <- as.factor(genre)

# Plot1
plot1 <- ggplot() + 
  geom_point(data=movies, aes(x=budget/1000000, y=rating, col=Genre), alpha= 0.5, shape=1) +
  xlab("Budget in Millions (USD)") + xlim(0,200) + 
  ylab("Movie Rating") + scale_y_continuous (expand=c(0,0.1), breaks=c(seq(0,10,2))) + 
  ggtitle("Plot1: Rating Vs Budget") +
  theme(text=element_text(family="Trebuchet MS"), 
        legend.text=element_text(size=4.5),
        legend.title=element_text(size=6),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text = element_text(size=6, colour="black"), 
        plot.title = element_text(size=8),
        axis.title=element_text(size=6))
plot1
ggsave(file="hw1-scatter.png", height=4, width=6)

# Plot2
plot2 <- ggplot(movies, aes(x=reorder(Genre, Genre, function(x) - length(x)), fill=Genre)) + 
  geom_bar() + xlab("Genre") +  ylab("Number of Movies") + 
  scale_y_continuous(breaks=c(seq(0,1800,200)), limits=c(0,1800), expand=c(0,1)) + 
  ggtitle("Plot2: Number of Movies by Genre") + 
  theme(text=element_text(family="Trebuchet MS"), 
        legend.position="none",
        #legend.title=element_text(size=7),
        #legend.text=element_text(size=6),
        axis.title.x=element_blank(),
        panel.grid.major.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        plot.title = element_text(size=8, colour="black"),
        axis.text = element_text(size=6, colour="black"),
        axis.title=element_text(size=6, face="bold"))
plot2
ggsave(file="hw1-bar.png", height=4, width=6)

# Plot3
plot3 <- ggplot(movies, aes(x=budget/1000000, y=rating))+ 
  geom_point(alpha=0.3, aes(fill=Genre, col=Genre), shape=1, size=1.5) + 
  facet_wrap(~ Genre) + 
  xlab("Budget in Millions (USD)") + xlim(0,200) + 
  ylab("Movie Rating") +  scale_y_continuous (expand=c(0,0.1), breaks=c(seq(0,10,2))) + 
  ggtitle("Plot3: Movie Ratings by Genre") +
  theme(text=element_text(family="Trebuchet MS"), 
        legend.position="none", 
        axis.title.y=element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text = element_text(size=5, colour="black"), 
        plot.title = element_text(size=8),
        strip.text.x = element_text(size = 6),
        axis.title=element_text(size=5, face="bold"))
plot3
ggsave(file="hw1-multiples.png", height=4, width=6)

# Plot4
plot4 <- ggplot(data=eu) + geom_line(aes(x=as.numeric(time), y=DAX, col='DAX'), size=0.25) + 
  geom_line(aes(x=as.numeric(time), y=SMI, col='SMI'), size=0.25) + 
  geom_line(aes(x=as.numeric(time), y=CAC, col='CAC'), size=0.25) +
  geom_line(aes(x=as.numeric(time), y=FTSE, col='FTSE'), size=0.25) + 
  xlab("YEAR") + scale_x_continuous(breaks=c(seq(1992,1998,1)), limits=c(1991.48,1998.65), expand=c(0,0)) + 
  ylab("INDEX LEVEL") + scale_y_continuous(breaks=c(seq(0,9000,2000)), limits=c(1000,8500), expand=c(0,0)) + 
  ggtitle("Plot4: EU Financial Indices between 1991 and 1999") + 
  theme(text=element_text(family="Trebuchet MS"), 
        legend.title=element_blank(), 
        legend.text=element_text(size=5),
        legend.position=c(0.05, 0.80),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text = element_text(size=5, colour="black"), 
        plot.title = element_text(size=8),
        axis.title=element_text(size=5, face="bold"))
plot4
ggsave(file="hw1-multiline.png", height=4, width=8)
