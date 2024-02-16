getwd()
language <- read.csv("Children who speak a language other than English at home.csv")
school_scores <- read.csv("school_scores 3.csv")
library(dplyr)

joined <- left_join(language, school_scores, by = "State.Name")