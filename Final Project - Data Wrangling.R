library(dplyr)
language_df <- read.csv("Children who speak a language other than English at home.csv")
school_scores_df <- read.csv("school_scores 3.csv")

language <- language_df %>% 
              mutate(filter(DataFormat == "Number"))
        
joined <- left_join(language, school_scores, by = "State.Name")
