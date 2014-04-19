library(tm)
library(ggplot2)
library(SnowballC)

# getSources()
# Read the data from the URL for the dataset
# use URISource function
# dataSrc <- URISource('http://www.gutenberg.org/cache/epub/1661/pg1661.txt') # Sherlock
# dataSrc <- URISource('http://www.gutenberg.org/cache/epub/730/pg730.txt') # Oliver Twist
# dataSrc <- URISource('http://www.gutenberg.org/cache/epub/15489/pg15489.txt') # Dream
dataSrc <- URISource('http://www.gutenberg.org/cache/epub/20203/pg20203.txt') # autobio

dataCorpus <- Corpus(dataSrc, readerControl=list(reader = readPlain, language="en"))
# getTransformations()
# Step 1: Remove whitespaces
dataCorpus <- tm_map(dataCorpus, stripWhitespace)
# Step 2: Convert to lower case
dataCorpus <- tm_map(dataCorpus, tolower)
# Step 3: Remove punctuations & numbers
dataCorpus <- tm_map(dataCorpus, removePunctuation)
dataCorpus <- tm_map(dataCorpus, removeNumbers)
# Step 4: Remove stopwords
dataCorpus <- tm_map(dataCorpus, removeWords, stopwords("english"))
# getStemLanguages()
# Step 5: Stem the document
# dataCorpus <- tm_map(dataCorpus, stemDocument, lang="porter")
# inspect(dataCorpus)[[1]]
# Step 6: 
# Calculate frequencies using TermDocumentMatrix 
dataTDM <- TermDocumentMatrix(dataCorpus)

# Convert the TDM to a matrix format and create a dataframe out of the matrix
dataMatrix <- as.matrix(dataTDM)
df <- data.frame(
  word = rownames(dataMatrix),
  # necessary to call rowSums if have more than 1 document
  freq = rowSums(dataMatrix),
  stringsAsFactors = FALSE, row.names=NULL)

# Sort by word frequencies
df <- df[with(df,order(freq, decreasing = TRUE)),]
# head(df,100)
rownames(df) <- NULL
write.csv(df, file='autobio.csv', row.names=FALSE)

# plot <- df[which(df$freq >=150 & df$freq <=200),]
# plot$word <- factor(plot$word, levels=plot$word, ordered=TRUE)
# plot$word <- factor(plot$word,levels(plot$word)[nrow(plot):1])
# 
# p <- ggplot(plot, aes(x = word, y = freq)) +
#   geom_bar(stat = "identity", fill = "grey60") +
#   ggtitle("Sherlock") +
#   xlab("Top Word Stems (Stop Words Removed)") +
#   ylab("Frequency") +
#   theme_minimal() +
#   scale_x_discrete(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0)) +
#   theme(panel.grid.major.y = element_blank()) +
#   theme(axis.ticks = element_blank()) + 
#   coord_flip()
# p
