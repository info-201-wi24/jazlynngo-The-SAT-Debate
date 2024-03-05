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
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
)

viz_3_main_panel <- mainPanel(
  h2("Vizualization 3 Title"),
  # plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_3_tab <- tabPanel("Viz 3 tab title",
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