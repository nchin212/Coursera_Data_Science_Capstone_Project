# Coursera Data Science Capstone Project - Word Prediction
  
## Overview
  
- Created an application that predicts the next word based on the user's input words, achieved an accuracy score of 68%
- Combined text from US blogs, news and twitter
- Used quanteda to tokenize text to 1gram, 2grams and 3grams
- Applied stupid backoff algorithm to compute scores for each word
- Built a Shiny application that allows the user to choose the number of predicted words to display and plot its respective wordcloud
- Created a pitch presentation to promote the application to employers

## Tools Used

- Language: R
- Packages: tidyr, caTools, dplyr, quanteda, wordcloud, RColorBrewer, caTools
- Data: [Coursera](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)
- Topics: R, NLP, Text Prediction, Shiny

## Data

The data is from a corpus called HC Corpora. The zip file contains 4 folders, which are “en\_US”, “de\_DE”, “ru\_RU” and “fi\_FI”. Only
“en\_US” contains English text so it was utilised for this project. It contains 3 text files: blogs, news and twitter. The data from the 3 sources are combined and there are 4 million lines altogether. Due to the size of the dataset, only 1% of the dataset was sampled.

## Stupid Backoff Model

Stupid backoff computes a score rather than a probability for ngrams on very large datasets. The score is
calculated as follows:

![png](https://github.com/nchin212/Coursera_Data_Science_Capstone_Project/blob/gh-pages/final_report/stupid_backoff1.png)

where alpha is set to 0.4 and the recursion ends with the unigrams calculated as follows:

![png](https://github.com/nchin212/Coursera_Data_Science_Capstone_Project/blob/gh-pages/final_report/stupid_backoff2.png)

Let’s take a look at an example.

Suppose our input text ends with “a great” and we are only working with
1grams, 2grams and 3grams.

**Step 1 - Search for the 2gram input in the 3grams dataset :** We first search in the 3grams dataset for the 3grams that start with the
2grams,“a great”. Suppose 1 of those 3 grams is “a great day”. The score for “day” is calculated by taking the count of “a great day” in the
3grams dataset divided by the count of “a great” in the 2grams dataset.

**Step 2 - Backoff to search for 1 gram input in the 2grams dataset :** We next search in the 2grams dataset for the 2grams that start with the
1gram, “great”. Suppose 1 of those 2 grams is “great week”. The score for “week” is calculated by taking the count of “great week” in the
2grams dataset divided by the count of “great” in the 1grams dataset. To account for the backoff, alpha = 0.4 is multiplied to the result.

**Step 3 - Give the most common words in the 1grams dataset :** The scores for each unigram are calculated by taking their count divided by
the total number of unigrams. To account for the backoff, 0.4\*\*2 is multiplied to the result.

The model will output the respective words and their scores and the word with the highest score is most likely to be the next word.

## Data Cleaning

The following was done to clean up the data:

- Split the data into 80% training and 20% validation sets
- Training set transformed into a corpus and tokenized
- Numbers, symbols, punctuation, separators and social media tags removed during tokenization
- Stemming and removing stopwords not done as it would lower the prediction accuracy
- Generated 1gram, 2grams and 3grams
- Computed stupid backoff scores and stored them
- Removed profanities from text

## Exploratory Data Analysis

Histogram of Number of Characters |  Wordcloud for Unigram
:-------------------------:|:-------------------------:
<img src="https://github.com/nchin212/Coursera_Data_Science_Capstone_Project/blob/gh-pages/exploratory_data_analysis/hist.png" width="100%"> | <img src="https://github.com/nchin212/Coursera_Data_Science_Capstone_Project/blob/gh-pages/exploratory_data_analysis/unigram.png" width="100%">

Wordcloud for Bigram |  Wordcloud for Trigram
:-------------------------:|:-------------------------:
<img src="https://github.com/nchin212/Coursera_Data_Science_Capstone_Project/blob/gh-pages/exploratory_data_analysis/bigram.png" width="100%"> | <img src="https://github.com/nchin212/Coursera_Data_Science_Capstone_Project/blob/gh-pages/exploratory_data_analysis/trigram.png" width="100%">

## Modelling

The stupid backoff scores have already been computed for the 1grams, 2grams and 3grams dataframes so now all we have to do is to implement the algorithm itself. The procedure is as follows:

**Step 1 - Take the last 2 words of the user input :** We have to also account for the cases where the user keys in only 1 word or no words at all.

**Step 2 - Implement the stupid backoff algorithm as seen above :** We have to retrieve the scores and account for the backoff (alpha = 0.4) accordingly. If the user keys in no input, the most common words in the 1grams dataset will be predicted as the next word.

**Step 3 - Collate the scores and arrange them from highest to lowest :** The word with the highest score is predicted to be the next most likely word.

## Accuracy

Compute the model accuracy, where accuracy means the percentage of cases where the correct word is predicted within the defined number of predicted words. 

|           | Pred5 | Pred3 | Pred1 |
|-----------|-------|-------|-------|
| Previous2 | 0.68  | 0.61  | 0.50  |
| Previous1 | 0.60  | 0.50  | 0.37  |



## Relevant Links

**Final Report :** https://nchin212.github.io/Coursera_Data_Science_Capstone_Project/final_report/final_report.html

**Shiny Application :** https://nchin212.shinyapps.io/word_prediction_app/

**Pitch Presentation :** https://nchin212.github.io/Coursera_Data_Science_Capstone_Project/pitch_presentation/pitch_presentation.html



