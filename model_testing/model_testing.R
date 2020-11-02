# Load functions from other file
source('../word_prediction_app/functions.R')
source('../data_cleaning/data_cleaning.R')

# Input text sample 
inputText <- ''

# Get inputs as separate strings
input1 = fun.input(inputText)[1, ]
input2 = fun.input(inputText)[2, ]
input1
input2

# Predict
number_pred <- 5
fun.predict(input1, input2)

