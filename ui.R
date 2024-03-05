library(ggplot2)
library(plotly)
library(bslib)

sat_df <- read.csv("school_scores_and_lang_df.csv")

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Introduction",
     h1("The SAT Debate"),
     p("Jazlyn Ngo, Arwa Iqbal, Justin Nguyen, Tiffany Nguyen"),
     p("INFO 201 Final Project"),
     p("March 6th, 2024"),
     img(src = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnnwXJbQ4zug5FW5DoNFV61o2cuLJGZeWztg&usqp=CAU"),
     h3("An Introduction:"),
     p("The SAT is a standardized exam to measure the knowledge of students in
      various subjects such as math, reading, and writing. It is used by many 
      universities to make admission decisions. Since the COVID-19 pandemic of 2020,
      many universities have made the decision to remove this testing requirement        from their admission requirements due to government mandated social distancing. This decision raised the question of how crucial this exam really 
      is in college admission and why underlying demographics may show that this requirement is not all about student knowledge. Now, we aim to explore the impact
      of social demographics on average SAT scores. Through investigating several datasets that focus on household income, English language use at home, and average student GPA
      in relation to average SAT scores, we will aim to answer the following questions:"),
     p("Are there trends between median household income and average SAT score?"),
     p("Do states with more English language speakers have higher average SAT scores?"),
     p("How does gender and SAT score vary by state?"),
     h3("Data usage"),
     p("Our first data source is a dataset consisting of SAT scores from across the country. The dataset holds testing numbers across
       all categories of the SAT test as well as average student GPA through various subjects. The data was generated
       from the college board students who took the exam and also participated in the survey. It also holds data
       on average household income and gender of the participating students."),
     a("US School Scores", href = "https://www.kaggle.com/datasets/mexwell/us-school-scores"),
     p("Our second dataset was generated from the Annie Casey foundation, a group that aims to improve
       student health outcomes. The numbers of children who speak a language other than English home comes
       from government data and contains numbers across different states from 2000-2003"),
     a("Kids Count Data Center", href = "https://www.childstats.gov/americaschildren/family5.asp#:~:text=SOURCE%3A%20U.S.%20Census%20Bureau%2C%20American,and%20had%20difficulty%20speaking%20English"),
     h3("Limitations and ethical questions to consider:"),
     p("As with most datasets, there are inevitable aspects that present us with limitations and ethical questions. Some limitations presented in our own dataset are
       that numbers may be skewed as not every student that took the SAT exam took the corresponding writing exam. With that said, not every student that took the SAT exam 
       chose to participate in the data survey, so the numbers in the dataset are limited to the number of students who chose to participate, not all who attended. Ethical questions
       we can consider are if SAT data collection should also open up gender options to other than female and male and if there are demographics underlying income and English use that may
       be impacting SAT scores. English language use and household income may be connected by another demographic such as immigrant populations or populations of color, which may
       be impacting SAT numbers.")
    
                         
                         
                         
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