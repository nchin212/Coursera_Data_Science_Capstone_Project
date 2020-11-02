# Load libraries
library(dplyr)
library(quanteda)
library(wordcloud)
library(RColorBrewer)

# Create a quanteda corpus and reshape into sentences
fun.corpus <- function(x) {
    corpus_reshape(corpus(x), to = 'sentences')
}

# Tokenize 
fun.tokenize <- function(x, ngrams=1) {
    
    tokens_ngrams(
        quanteda::tokens(tolower(x),
            remove_numbers = TRUE,
            remove_symbols = TRUE,
            remove_punct = TRUE,
            remove_separators = TRUE,
            what = "word1",  # Remove twitter tags
        ),
        n = ngrams, 
        concatenator = " "
    ) %>%
        as.list() %>%  # Convert tokens object to list of vectors
            unlist() # Convert list to vector of characters
}

# Compute counts of each ngram
fun.count <- function(x, minCount = 1) {
    x <- x %>%
        group_by(ngrams) %>%
        summarize(count = n()) %>%
        filter(count >= minCount)
}

# Compute scores for stupid backoff algorithm
fun.score <- function(x,y =NULL, words = 1) {
    
    # Compute scores for 1gram
    if (is.null(y)){
        x <- x %>%
            mutate(score= count/sum(x$count)) %>%
            select(-count) %>%
            rename(nextword = ngrams)
    }
    else {
        # Function to create the lower order ngram
        fun.lower <- function(x){
            paste(unlist(strsplit(x, " "))[1:words], collapse = " ")
        }
        # Apply function to each row to get lower ngram
        x$lower <- unlist(lapply(x$ngrams, fun.lower))
        
        # Merge the 2 ngrams together
        x <- merge(x, y, by.x = "lower", by.y = "ngrams", all = TRUE, stringsAsFactors = FALSE)
        x <- na.omit(x)
        # rename columns
        names(x) <- c("lower", "ngrams", "c_ngrams", "c_lower")
        
        # Calculate score
        x <- x %>%
            mutate(score = c_ngrams/c_lower) %>%
            select(ngrams,score)
        
        return(x)
    }
}

# Parse tokens from input text 
fun.input = function(x) {
    
    # If empty input, put both words empty
    if(x == "") {
        input1 <- data.frame(word = "")
        input2 <- data.frame(word = "")
    }
    # Tokenize with same functions as training data
    if(length(x) ==1) {
        y <- data.frame(word = fun.tokenize(corpus(x)))
        
    }
    # If only one word, put first word empty
    if (nrow(y) == 1) {
        input1 <- data.frame(word = "")
        input2 <- y
        
        # Get last 2 words    
    }   else if (nrow(y) >= 1) {
        input1 <- tail(y, 2)[1, ]
        input2 <- tail(y, 1)
    }
    
    #  Return data frame of inputs 
    inputs <- data.frame(words = unlist(rbind(input1,input2)))
    return(inputs)
}

# Predict using stupid backoff algorithm 
fun.predict <- function(x, y, n = number_pred) {
    
    # Initiate empty dataframes
    prediction0 <- data.frame(nextword = character(), score = numeric())
    prediction1 <- data.frame(nextword = character(), score = numeric())
    prediction2 <- data.frame(nextword = character(), score = numeric())
    prediction3 <- data.frame(nextword = character(), score = numeric())
    
    # Predict giving just the top 1-gram words, if no input given
    if(x == "" & y == "") {
        prediction0 <- dfTrain1 %>%
            select(nextword, score)
    }   
    
    # Predict using 3-gram model
    if(paste(x,y) %in% dfTrain3$prevword) {
        prediction3 <- dfTrain3 %>%
            filter(dfTrain3$prevword %in% paste(x,y)) %>%
            select(nextword, score)
    }   
    
    # Predict using 2-gram model
    if(y %in% dfTrain2$prevword) {
        prediction2 <- dfTrain2 %>%
            filter(prevword %in% y) %>%
            select(nextword, score)
        if (x != "" & y != ""){ #if there are 2 inputs, add penalty to score
            prediction2$score <- prediction2$score * 0.4
        }
    }   
    
    # Predict using 1-gram model
    if (x != "" | y != "") {
        prediction1 <- dfTrain1 %>%
            select(nextword, score)
        if (x != "" & y != ""){ #If there are 2 inputs, add penalty to score
            prediction1$score <- prediction1$score * 0.4 * 0.4
        }
        else { #If there is 1 input, add penalty to score
            prediction1$score <- prediction1$score * 0.4
        }
    }
    
    # Combine prediction dataframes and arrange them by score
    prediction <- rbind(prediction0, prediction1, prediction2, prediction3)
    prediction <- prediction %>% arrange(desc(score))
    
    # Return top n words
    return(prediction[1:n,])
}
