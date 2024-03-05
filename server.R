library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)



sat_df <- read.csv("school_scores_and_lang_df.csv")

server <- function(input, output){
  
  # TODO Make outputs based on the UI inputs here
  
  # 1st Interactive Page
  output$scoreVsEnglishPlot <- renderPlotly({
    score_type <- input$scoreType
    p <- ggplot(sat_df, aes_string(x = "English.Speaker", y = score_type)) +
      geom_point() +
      labs(x = "Proportion who speak an extra language", y = score_type)
    
    ggplotly(p)
  })
  
  # 2nd Interactive Page
  
  
  # 3rd Interactive Page
  output$scoreVsGenderPlotFemale <- renderPlotly({
    

    if (is.null(input$selectedState) || length(input$selectedState) == 0) {
      return(NULL) # Prevent the rest of the code from running
    }

    selectedScoreTypeFemale <- input$scoreTypeFemale
    selectedState <- input$selectedState
    
    filtered_data_female <- sat_df %>%
      filter(State.Name == selectedState) %>%
      select(Year, starts_with("Gender.Female")) %>%
      pivot_longer(cols = starts_with("Gender.Female"), 
                   names_to = "ScoreType", 
                   values_to = "value") %>%
      filter(ScoreType == selectedScoreTypeFemale)
  
   
    p_female <- ggplot(filtered_data_female, aes(x = Year, y = value)) +
      geom_point() +
      geom_line() +
      labs(x = "Year", y = selectedScoreTypeFemale) +
      theme_minimal()
    
      ggplotly(p_female)
})
  
  
output$scoreVsGenderPlotMale <- renderPlotly({

    if (is.null(input$selectedState) || length(input$selectedState) == 0) {
      return(NULL) # Prevent the rest of the code from running
    }

    selectedScoreTypeMale <- input$scoreTypeMale
    selectedState <- input$selectedState
    
    filtered_data_male <- sat_df %>%
      filter(State.Name == selectedState) %>%
      select(Year, starts_with("Gender.Male")) %>%
      pivot_longer(cols = starts_with("Gender.Male"), 
                   names_to = "ScoreType",
                   values_to = "value") %>%
      
      filter(ScoreType == selectedScoreTypeMale) 
    
    p_male <- ggplot(filtered_data_male, aes(x = Year, y = value)) +
      geom_point() +
      geom_line() +
      labs(x = "Year", y = selectedScoreTypeMale) +
      theme_minimal()
    
    ggplotly(p_male)

})

}

  