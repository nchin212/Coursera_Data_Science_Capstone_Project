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
        wellPanel(
            h4("Click on the following links to view additional information about the application:"),
            linebreaks(1),
            strong("Pitch Presentation :"),
            tags$a(href="https://nchin212.github.io/Coursera_Data_Science_Capstone_Project/pitch_presentation/pitch_presentation.html",
                   "https://nchin212.github.io/Coursera_Data_Science_Capstone_Project/pitch_presentation/pitch_presentation.html", 
                   target="_blank"),
            linebreaks(3),
            strong("Final Report :"), 
            tags$a(href="https://nchin212.github.io/Coursera_Data_Science_Capstone_Project/final_report/final_report.html",
                   "https://nchin212.github.io/Coursera_Data_Science_Capstone_Project/final_report/final_report.html", 
                   target="_blank"),
            linebreaks(3),
            strong("Github Repository :"),
            tags$a(href="https://github.com/nchin212/Coursera_Data_Science_Capstone_Project",
                   "https://github.com/nchin212/Coursera_Data_Science_Capstone_Project", 
                   target="_blank"),
        )
    )


)

