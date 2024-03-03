library(ggplot2)
library(plotly)
library(dplyr)

sat_df <- read.csv("school_scores_and_lang_df.csv")

server <- function(input, output){
  
  # TODO Make outputs based on the UI inputs here
  
  # 1st Interactive Page
  output$scoreVsEnglishPlot <- renderPlotly({
    score_type <- input$scoreType
    p <- ggplot(sat_df, aes_string(x = "English.Speaker", y = score_type)) +
      geom_point() +
      labs(x = "Proportion of English Speakers", y = score_type)
    
    ggplotly(p)
  })
  
  # 2nd Interactive Page
  
  
  # 3rd Interactive Page
}