library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)

sat_df <- read.csv("school_scores_and_lang_df.csv")
# more data wrangling for median household income
sat_family_income_verbal_df <- sat_df %>%
  select(State.Name, Year, starts_with("Family.Income") & ends_with(".Verbal")) %>% 
  rename(
    '0-20k.v' = 'Family.Income.Less.than.20k.Verbal',
    '20-40k.v' = 'Family.Income.Between.20.40k.Verbal',
    '40-60k.v' = 'Family.Income.Between.40.60k.Verbal',
    '60-80k.v' = 'Family.Income.Between.60.80k.Verbal',
    '80-100k.v' = 'Family.Income.Between.80.100k.Verbal',
    '100k+.v' = 'Family.Income.More.than.100k.Verbal') %>% 
  gather(key = "Family.Income.Verbal", value = "Sat.Verbal.Score", -State.Name, -Year) %>% 
  mutate(Income.Level = Family.Income.Verbal, Score.Type = "Verbal", Score = Sat.Verbal.Score) %>% 
  select(-Family.Income.Verbal, -Sat.Verbal.Score)

sat_family_income_math_df <- sat_df %>%
  select(State.Name, Year, starts_with("Family.Income") & ends_with(".Math")) %>% 
  rename(
    '0-20k.m' = 'Family.Income.Less.than.20k.Math',
    '20-40k.m' = 'Family.Income.Between.20.40k.Math',
    '40-60k.m' = 'Family.Income.Between.40.60k.Math',
    '60-80k.m' = 'Family.Income.Between.60.80k.Math',
    '80-100k.m' = 'Family.Income.Between.80.100k.Math',
    '100k+.m' = 'Family.Income.More.than.100k.Math') %>%
  gather(key = "Family.Income.Math", value = "Sat.Math.Score", -State.Name, -Year) %>% 
  mutate(Income.Level = Family.Income.Math, Score.Type = "Math", Score = Sat.Math.Score) %>% 
  select(-Family.Income.Math, -Sat.Math.Score)

sat_family_income_df <- rbind(sat_family_income_verbal_df, sat_family_income_math_df)
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
  
  output$scoreVsFamilyIncomePlot <- renderPlotly({
    sat_type <- input$sat_type
    if (sat_type == "Verbal") {
      df <- sat_family_income_verbal_df
    } else {
      df <- sat_family_income_math_df
    }
    
    income_plot <- ggplot(df) +
      geom_point(mapping = aes(
                   x = Income.Level,
                   y = Score
                 ))
    ggplotly(income_plot)
  })
  
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