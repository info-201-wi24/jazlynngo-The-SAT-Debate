library(ggplot2)
library(plotly)
library(bslib)

sat_df <- read.csv("school_scores_and_lang_df.csv")

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Overview Tab Title",
   h1("Some title"),
   p("some explanation")
)

## VIZ 1 TAB INFO

viz_1_sidebar <- sidebarPanel(
  h2("Select SAT Category"),
  selectInput("scoreType", "Select SAT Score Type:", 
              choices = c("Math" = "Total.Math", 
                          "Verbal" = "Total.Verbal", 
                          "Total" = "Total.Test.takers"))
)

viz_1_main_panel <- mainPanel(
  h2("SAT Scores vs Extra Language Speaker Percent"),
  plotlyOutput(outputId = "scoreVsEnglishPlot")
)

viz_1_tab <- tabPanel("How does percentage of extra language speakers affect SAT scores?",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel
  )
)

## VIZ 2 TAB INFO

viz_2_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
)

viz_2_main_panel <- mainPanel(
  h2("Impact of Wealth on SAT Scores"),
  plotlyOutput(outputId = "")
)

viz_2_tab <- tabPanel("Wealth",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO
viz_3_sidebar <- sidebarPanel(
      h2("Select SAT score by Section"),
      selectInput("scoreTypeFemale", "Select Female SAT Score Type:", 
                  choices = c("Math" = "Gender.Female.Math", 
                              "Verbal" = "Gender.Female.Verbal", 
                              "Total" = "Gender.Female.Test.takers")),
      selectInput("scoreTypeMale", "Select Male SAT Score Type:", 
                  choices = c("Math" = "Gender.Male.Math", 
                              "Verbal" = "Gender.Male.Verbal", 
                              "Total" = "Gender.Male.Test.takers")),
      selectInput("selectedState", "Select State:",
                  choices = unique(sat_df$State.Name), multiple = TRUE)
    )

viz_3_main_panel <- mainPanel(
  h2("SAT Score vs. Year for Female"),
  plotlyOutput(outputId = "scoreVsGenderPlotFemale"),
  
  h2("SAT Score vs. Year for Male"),
  plotlyOutput(outputId = "scoreVsGenderPlotMale")
)

viz_3_tab <- tabPanel("How Does SAT Score Vary by Year for Female and Male",
                      sidebarLayout(
                        viz_3_sidebar,
                        viz_3_main_panel
                      )
)




## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion Tab Title",
 h1("Some title"),
 p("some conclusions")
)



ui <- navbarPage("Example Project Title",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)