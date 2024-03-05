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
              choices = c("Verbal" = "Total.Verbal",
                          "Math" = "Total.Math"))
)

viz_1_main_panel <- mainPanel(
  h1("Purpose:"),
  p("The students who take SAT tests come from very diverse backgrounds. 
    Students come from very different upbringings, which is particularly true 
    when it comes to the languages they grew up speaking. From our research, we 
    saw claims about how the SAT could be biased towards students who's first
    language wasn't English."),
  p("To measure non-English speaking students, we weren't able to find data on 
    non-English speaking SAT takers, but we were able to find data on SAT takers 
    who spoke another language besides English. This served as a good metric for 
    students who the SAT might be biased. Though it's certainly not the case that 
    these extra language speakers all learned another language before English, 
    it is likely at least true for some of the extra language speakers."),
  p("We wanted to focus mainly on the verbal SAT section as non-native English
    speakers would likely struggle on this section the most. However, we still
    have plots for the other SAT sections to use as a control and compare with 
    verbal SAT section"),
  h2("SAT Scores vs Extra Language Speaker Percent"),
  plotlyOutput(outputId = "scoreVsEnglishPlot"),
  h1("Analysis"),
  p("We can see very high verbal SAT scores on the lower spectrum of extra language
    speakers, with the highest scores peaking at 600 with an extra language speaker percent of 5%. 
    In this range of the spectrum, we see a high concentration of test scores 
    between 600 and 550, with thse making up around half of the scores in the lower range of extra language speakers."),
  p("As we move towards higher extra language percentages, we see the peak scores drop slightly around an extra language percent of 20%.
    We can see this trend continue as scores drop to 500 at an extra language percent of 45%."),
  p("This trend suggests that states with higher extra language speaking students are more likely to score worse on the SAT verbal section.
    This might not mean that extra language percent is causing lower SAT scores, but it seems that they are correlated.
    It could be that extra language percent is associated with lower income, or another factor that actually causes lower SAT verbal scores."),
  p("We see similar trends with the math SAT section, which could potentially be 
    biased towards non-native English speakers, but is certainly less likely to be biased than the verbal section is.
    This similarity in verbal and math results in relation to extra language speaker percent suggests that either both sections are biased
    towards extra language speakers or that extra language speaker percent is correlated with worse test scores.")
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