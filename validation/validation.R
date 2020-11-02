# Load functions in other files
source("../data_cleaning/data_cleaning.r")
source('../word_prediction_app/functions.R')

set.seed(101)
n <- 1/1000
valid_sample <- sample(valid, length(valid) * n)

# Create a quanteda corpus and reshape into sentences
valid_sample <- fun.corpus(valid_sample)

# Get 2-gram tokens 
valid2 <- fun.tokenize(valid_sample, 2)
valid2 <- data.frame(ngrams = valid2) %>%
    separate(ngrams, c('input2', 'nextword'), ' ')
# Put empty string as input1
valid2 <- mutate(valid2, input1 = rep("", nrow(valid2))) %>%
    select(input1, input2, nextword)

# Get 3-gram tokens
valid3 <- fun.tokenize(valid_sample, 3)
valid3 <- data.frame(ngrams = valid3) %>%
    separate(ngrams, c('input1', 'input2', 'nextword'), ' ')

# Create a accuracy function, where accuracy means percentage of cases where  
# correct word is predicted within defined number of predicted words

fun.accuracy <- function(x) {
    
    # Apply prediction function to each input line 
    y <- mapply(fun.predict, x$input1, x$input2)
    
    # Calculate accuracy
    accuracy <- sum(ifelse(x$nextword %in% unlist(y), 1, 0)) / nrow(x)

    # Return accuracy
    return(accuracy)
}

# Rounding precision
precision <- 2

# Accuracy using 1 previous word and 5 predictions
number_pred <- 5
accuracy_1prev_5pred <- round(fun.accuracy(valid2), precision)

# Accuracy using 1 previous word and 3 predictions
number_pred  = 3
accuracy_1prev_3pred <- round(fun.accuracy(valid2), precision)

# Accuracy using 1 previous word and 1 prediction
number_pred  = 1
accuracy_1prev_1pred <- round(fun.accuracy(valid2), precision)

# Accuracy using 2 previous words and 5 predictions
number_pred  = 5
accuracy_2prev_5pred <- round(fun.accuracy(valid3), precision)

# Accuracy using 2 previous words and 3 predictions
number_pred  = 3
accuracy_2prev_3pred <- round(fun.accuracy(valid3), precision)

# Accuracy using 2 previous words and 1 prediction
number_pred  = 1
accuracy_2prev_1pred <- round(fun.accuracy(valid3), precision)

# Accuracy table
accuracy_table <- data.frame(Pred5 = c(accuracy_2prev_5pred, accuracy_1prev_5pred),
                         Pred3 = c(accuracy_2prev_3pred, accuracy_1prev_3pred),
                         Pred1 = c(accuracy_2prev_1pred, accuracy_1prev_1pred),
                         row.names = c('Previous2', 'Previous1')
                         )
#accuracy_table


