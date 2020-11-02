# Load functions from other file
source('functions.R')

library(shiny)

# Define application 

shinyServer(function(input, output) {

# Reactive statement for prediction function when user input changes 
    prediction =  reactive( {
        
        # Get input
        input_text <- input$text
        input1 <-  fun.input(input_text)[1, ]
        input2 <-  fun.input(input_text)[2, ]
        number_pred <- input$slider
        
        # Predict
        prediction <- fun.predict(input1, input2, n = number_pred)
    })

    # Output data table 
    output$table <- renderDataTable(prediction(),
                                option = list(pageLength = 5,
                                            lengthMenu = list(c(5, 10, 50), c('5', '10', '50')),
                                            columnDefs = list(list(visible = F, targets = 1))
                                            )
                                    )
    
    # Output word cloud 
    wordcloud_rep <- repeatable(wordcloud)
    output$wordcloud <- renderPlot(
                            wordcloud_rep(
                                prediction()$nextword,
                                prediction()$score,
                                rot.per=0.25,
                                colors = brewer.pal(8, 'Dark2'),
                                scale=c(4, 0.5),
                                max.words = 200
                                )
                        )
})
