library(ggplot2)
library(plotly)
library(bslib)
library(tidyr)
library(shiny)
install.packages("shinythemes")
library(shinythemes)
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

viz_1_tab <- tabPanel("Extra Language Speakers",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel
  )
)

## VIZ 2 TAB INFO
viz_2_sidebar <- sidebarPanel(
  selectInput("sat_type",
              label = "Select a Score Type:",
              choices = c("Verbal",
                          "Math")
))

viz_2_main_panel <- mainPanel(
  h2("Impact of Wealth on SAT Scores"),
  plotlyOutput(outputId = "scoreVsFamilyIncomePlot"),
  p("NOTE: 100k+ range should be at the end of the x-axis of plot."),
  h1("Purpose"),
  p("The purpose of this wealth plot is to illustrate the relationship between SAT scores 
    and family income ranges, aiming to discern whether the SAT truly assesses a student's 
    readiness for college or if it reflects economic advantages. We opted for a scatter plot to present 
    this data due to its effectiveness in depicting the correlation between two continuous variables: 
    SAT scores and family income ranges."),
  h1("Analysis"),
  p("Within our data, we can see that as the family income range of students decreases, so does their SAT score.
  This is an important correlation as income could be a factor in how well a student scores on the SAT. 
  This could give some insight and consideration into universities for them to decide if the SAT is a good measure of a student or their wealth. 
  This exposes the socioeconomic bias of the SAT and equity in admissions. This allows universities to consider a more hollistic
  review process, and giving more support for underserved students.")
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
                              "Total Test Takers" = "Gender.Female.Test.takers")),
      selectInput("scoreTypeMale", "Select Male SAT Score Type:", 
                  choices = c("Math" = "Gender.Male.Math", 
                              "Verbal" = "Gender.Male.Verbal", 
                              "Total Test Takers" = "Gender.Male.Test.takers")),
      selectInput("selectedState", "Select State:",
                  choices = unique(sat_df$State.Name), multiple = TRUE)
    )

viz_3_main_panel <- mainPanel(
  h2("SAT Score vs. Year for Female"),
  plotlyOutput(outputId = "scoreVsGenderPlotFemale"),
  
  h2("SAT Score vs. Year for Male"),
  plotlyOutput(outputId = "scoreVsGenderPlotMale"),
  
  h1("Purpose:"),
    p("The purpose of these graphs is to document the variation in SAT scores based on gender, specifically male and female. 
    Line plots were selected as they effectively illustrate whether the overall trend increases or decreases over time, 
    spanning from 2005 to 2015. The inclusion of a state filter provides the opportunity to compare SAT scores across diverse
    regions in the United States. Additionally, users can filter for math, verbal (reading and writing), or total SAT scores
    to visualize how gender performance differences vary across specific sections of the exam."),
  h1("Analysis:"),
    p("The information demonstrates that males tend to perform better on all sections than females across the United States. Most states have an overall decline in score on the math section. Only a few states, some including Arkansas, Michigan Colorado, Wyoming, and Illinois have increased in the math section. In the verbal section, only some states, 
    similar to the math section, have increased including Colorado, Michigan, and Wyoming. For all of the states, men performed 
    higher than females in all sections, with the gap being slightly larger for math over verbal. Interestingly, the majority of states
    had more female test takers then male. Finally, Indiana has almost remained constant in the math or verbal section, besides a sudden peak in 2010. Ironically, they had fewer test takers then. Overall, these data gives more insight, on how gender bias is present in SAT performance.")

  
)

viz_3_tab <- tabPanel("Gender",
                      sidebarLayout(
                        viz_3_sidebar,
                        viz_3_main_panel
                      )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion",
 h1("Concluding The SAT Debate"),
 img(src = "https://www.amideast.org/sites/default/files//SAT%20logo%20Resized-01_0.png"),
 p("Upon concluding our research, it is evident that the SAT is not simply a test of academic proficiency, 
    but also a reflection of external factors in students’ lives. Our exploration of data specifically on household income, 
    gender, and students who speak a language other than English at home reveals correlation to average SAT scores that imply 
    a broader context underlying test outcomes. "),
 h3("Takeaway #1"),
 p("Firstly, our analysis of household income reveals an association between lower household income and diminished SAT performance. 
   This correlation highlights the impact of economic circumstances on a student's test-taking abilities as well as the role of 
   financial resources in academic achievement. "),
 h3("Takeaway #2"),
 p("Next, our investigations explore the number of students who speak a language other than English at home. It exposed a notable
   trend whereas individuals speaking other languages at home tend to score less favorably on the SAT, particularly in the verbal 
   section. This observation suggests a language barrier, underscoring the challenges faced by non-native English speakers when navigating an English test. "),
 h3("Takeaway #3"),
 p("Lastly, our examination of gender disparities in SAT scores reveals male students outperforming female students across various 
 states despite a higher participation rate among females. This underscores potential differences in test-taking strategies or societal expectations and 
 prompts further research into the factors shaping gender-based academic outcomes."),
 h3("Summary"),
 p("In essence, our findings shed light on the interplay between demographic variables and SAT performance, emphasizing the need for a comprehensive 
   understanding of the diverse influences at play. By acknowledging these underlying factors, educators and policymakers can strive towards more equitable 
   assessment practices and working towards inclusive learning environments to strive for academic success for all students. ")
)




ui <- navbarPage("The SAT Debate",
  theme = shinytheme("cerulean"),

  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)