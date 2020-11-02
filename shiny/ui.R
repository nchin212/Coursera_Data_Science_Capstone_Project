# Load libraries
library(shiny)
library(shinythemes)

linebreaks <- function(n){HTML(strrep(br(), n))}

# Define the app

navbarPage("Word Prediction",

    # Theme
    theme = shinytheme("united"),
    
    tabPanel("Main",

        # Sidebar
        sidebarLayout(
            
            sidebarPanel(
            
            # Text input
            textInput("text", label = ('Enter text here'), value = ''),
            
            # Number of words slider input
            sliderInput('slider',
                        'Maximum number of predictions',
                        min = 0,  max = 200,  value = 10
            ),
    
            # Table output
            dataTableOutput('table')
            ),
    
            # Mainpanel 
            mainPanel(
                wellPanel(
                    # Wordcloud output
                    plotOutput('wordcloud')
                )
        )
    ) 
    ),
    tabPanel("Links",
    h4("Click on the following links to view additional information about the application:"),
    linebreaks(1),
    strong("Pitch Presentation"), "link",
    linebreaks(3),
    strong("Final Report"), "link",
    linebreaks(3),
    strong("Github Repository"), "link"
    )

)

