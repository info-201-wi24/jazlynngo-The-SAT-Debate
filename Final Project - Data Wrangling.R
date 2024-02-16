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
                                filter(TimeFrame == Year) %>% 
                                select(-DataFormat, -LocationType, -Academic.Subjects.Arts.Music.Average.GPA,
                                       -Academic.Subjects.Arts.Music.Average.Years, -Academic.Subjects.Mathematics.Average.GPA,
                                       -Academic.Subjects.Mathematics.Average.Years, -Academic.Subjects.Natural.Sciences.Average.GPA,
                                       -Academic.Subjects.Natural.Sciences.Average.Years, -Academic.Subjects.Social.Sciences.History.Average.GPA,
                                       -Academic.Subjects.Social.Sciences.History.Average.Years, -GPA.A.minus.Verbal, -GPA.A.plus.Math, 
                                       -GPA.A.plus.Test.takers, -GPA.A.plus.Verbal, -GPA.A.Math, -GPA.A.Test.takers, -GPA.A.Verbal, 
                                       -GPA.B.Math)




