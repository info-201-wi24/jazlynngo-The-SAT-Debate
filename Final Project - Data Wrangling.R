library(dplyr)

#DataFrames
language_df <- read.csv("Children who speak a language other than English at home.csv")
school_scores_df <- read.csv("school_scores 3.csv")

#cleaned language_df
language_df <- language_df %>%
                  filter(DataFormat == "Percent")

#joined df
school_scores_and_lang_df <- left_join(language_df, school_scores_df, by = "State.Name")

#clean joined df
school_scores_and_lang_df <- school_scores_and_lang_df %>% 
                                filter(State.Name != "Puerto Rico") %>% 
                                filter(TimeFrame == Year)


