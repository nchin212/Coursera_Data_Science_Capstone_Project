# Load in functions from other file
source('../word_prediction_app/functions.R')

# Load in libraries
library(caTools)
library(tidyr)

# Load in datasets
blogs <- readLines('../data/en_US/en_US.blogs.txt')
news <- readLines('../data/en_US/en_US.news.txt')
twitter <- readLines('../data/en_US/en_US.twitter.txt',skipNul = TRUE) 
combined <- c(blogs, news, twitter)

# Sample the data
set.seed(101)
n <- 1/100
combined_sample <- sample(combined, length(combined) * n)

# Split into train and validation sets
split <- sample.split(combined_sample, 0.8)
train <- subset(combined_sample, split == T)
valid <- subset(combined_sample, split == F)

# Create quanteda corpus and reshape it into sentences
train <- fun.corpus(train)

# Tokenize
train1 <- fun.tokenize(train)
train2 <- fun.tokenize(train, 2)
train3 <- fun.tokenize(train, 3)

# Convert them into dataframes and count the number of each ngram
df1 <- data.frame(ngrams = train1)
dfCount1 <- fun.count(df1)

df2 <- data.frame(ngrams = train2)
dfCount2 <- fun.count(df2)

df3 <- data.frame(ngrams = train3)
dfCount3 <- fun.count(df3)

# Compute stupid backoff scores
dfTrain1 <- fun.score(dfCount1) 

dfTrain2 <- fun.score(dfCount2,dfCount1) %>%
    separate(ngrams, c('prevword', 'nextword'), " ")

dfTrain3 <- fun.score(dfCount3, dfCount2, words = 2) %>%
    separate(ngrams, c('word1','word2','nextword'), " ")

# Profanity filtering
profanity <- readLines("../data/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words.txt")
dfTrain1 <- filter(dfTrain1, !nextword %in% profanity)
dfTrain2 <- filter(dfTrain2, !prevword %in% profanity &!nextword %in% profanity)
dfTrain3 <- filter(dfTrain3, !word1 %in% profanity & !word2 %in% profanity & !nextword %in% profanity)


# Combine back word 1 and word 2 in 3grams
dfTrain3$prevword <- paste(dfTrain3$word1,dfTrain3$word2)
dfTrain3 <- dfTrain3 %>% select(prevword,nextword,score)

# Save the dataframes
#saveRDS(dfTrain1, file = 'dfTrain1.rds')
#saveRDS(dfTrain2, file = 'dfTrain2.rds')
#saveRDS(dfTrain3, file = 'dfTrain3.rds')

