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
plot1 <- ggplot() + geom_point(data=movies, aes(x=budget/1000000, y=rating, col=Genre), shape=1) +
  xlab("Budget in Millions USD") + xlim(0,200) + 
  ylab("Movie Rating") + scale_y_continuous (expand=c(0,0.1))
  ggtitle("Plot1: Rating Vs Budget") +
  theme(text=element_text(family="Trebuchet MS"), legend.title=element_text(size=12), 
        axis.text = element_text(size=12, colour="black"), axis.title=element_text(size=14, face="bold"))
plot1
ggsave(file="hw1-scatter.png")

# Plot2
plot2 <- ggplot(movies, aes(x=reorder(Genre, Genre, function(x) - length(x)), fill=Genre)) + 
  geom_bar() + xlab("Genre") + ylab("# of Movies") + ggtitle("Plot2: Number of Movies by Genre") + 
  theme(text=element_text(family="Trebuchet MS"), legend.position=c(0.90, 0.80),
        legend.title=element_text(size=12), axis.text = element_text(size=12, colour="black"),
        axis.title=element_text(size=14, face="bold"))
plot2
ggsave(file="hw1-bar.png")

# Plot3
plot3 <- ggplot(movies, aes(x=budget/1000000, y=rating))+ geom_point(aes(fill=Genre, col=Genre)) + 
  facet_wrap(~ Genre) +   xlab("Budget in Millions USD") + xlim(0,250) + ylab("Movie Rating") + 
  ggtitle("Plot3: Movie Ratings by Genre") +
  theme(text=element_text(family="Trebuchet MS"), legend.title=element_text(size=12), 
        axis.text = element_text(size=12, colour="black"), axis.title=element_text(size=14, face="bold"))
plot3
ggsave(file="hw1-multiples.png")

# Plot4
plot4 <- ggplot(data=eu) + geom_line(aes(x=as.numeric(time), y=DAX, col='DAX')) + 
  geom_line(aes(x=as.numeric(time), y=SMI, col='SMI')) + 
  geom_line(aes(x=as.numeric(time), y=CAC, col='CAC')) +
  geom_line(aes(x=as.numeric(time), y=FTSE, col='FTSE')) + 
  xlab("") + scale_x_continuous(breaks=c(seq(1991,1999,1)), limits=c(1991,1998.7)) + 
  ylab("INDEX LEVEL") + scale_y_continuous(breaks=c(seq(0,9000,1000)), limits=c(500,8500)) + 
  ggtitle("Plot4: EU Financial Indices between 1991 and 1999") + 
  theme(text=element_text(family="Trebuchet MS"), legend.title=element_blank(), legend.position=c(0.10, 0.75), 
        axis.text = element_text(size=8, colour="black"), axis.title=element_text(size=8, face="bold"))
plot4
ggsave(file="hw1-multiline.png", height=4, width=8)
