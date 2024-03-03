library(dplyr)
getwd()

#DataFrames
language_df <- read.csv("C:/Users/figne/OneDrive/Documents/Children who speak a language other than English at home.csv")
school_scores_df <- read.csv("C:/Users/figne/OneDrive/Documents/school_scores 3.csv")

#Joining DataFrames
# cleaning language dataframe
language_df <- language_df %>%
                  filter(DataFormat == "Percent")

#joined dataframes
school_scores_and_lang_df <- left_join(language_df, school_scores_df, by = "State.Name")

#Cleaning Joined DataFrame
school_scores_and_lang_df <- school_scores_and_lang_df %>% 
                                filter(State.Name != "Puerto Rico") %>% 
                                filter(TimeFrame == Year) %>% 
                                select(State.Name, English.Speaker, Year, State.Code, Total.Math,
                                       Total.Test.takers, Total.Verbal, Academic.Subjects.English.Average.GPA, Academic.Subjects.English.Average.Years,
                                       Academic.Subjects.Foreign.Languages.Average.GPA, Academic.Subjects.Foreign.Languages.Average.Years,
                                       Academic.Subjects.Mathematics.Average.GPA, Academic.Subjects.Mathematics.Average.Years, Family.Income.Between.20.40k.Math,
                                       Family.Income.Between.20.40k.Test.takers, Family.Income.Between.20.40k.Verbal,
                                       Family.Income.Between.40.60k.Math, Family.Income.Between.40.60k.Test.takers, Family.Income.Between.40.60k.Verbal, Family.Income.Between.60.80k.Math, Family.Income.Between.60.80k.Test.takers, 
                                       Family.Income.Between.60.80k.Verbal, Family.Income.Between.80.100k.Math, Family.Income.Between.80.100k.Test.takers, Family.Income.Between.80.100k.Verbal, 
                                       Family.Income.Less.than.20k.Math, Family.Income.Less.than.20k.Test.takers,
                                       Family.Income.Less.than.20k.Verbal, Family.Income.More.than.100k.Math, Family.Income.More.than.100k.Test.takers, Family.Income.More.than.100k.Verbal, Gender.Female.Test.takers,
                                       Gender.Male.Test.takers, Gender.Female.Math, Gender.Male.Math, Gender.Female.Verbal, Gender.Male.Verbal)

#NEW CATEGORICAL VARIABLE
state_region_lookup <- data.frame(
  State.Code = c("HI", "AK", "WA", "OR", "CA", "ID", "MT", "WY", "NV", "UT", "CO", "AZ", "NM", 
                 "ND", "SD", "MN", "NE", "KS", "MO", "IA", "WI", "IL", "IN", "MI", "OH",
                 "TX", "OK", "AR", "LA", "MS", "AL", "TN", "KY", "WV", "VA", "MD", "DE", "NC", "SC", "GA", "FL",
                 "PA", "NJ", "NY", "CT", "MA", "RI", "NH", "VT", "ME"),
  Region = c("West","West","West", "West", "West", "West", "West", "West", "West", "West", "West", "West", "West",
             "Midwest", "Midwest", "Midwest", "Midwest", "Midwest", "Midwest", "Midwest", "Midwest", "Midwest", "Midwest", "Midwest", "Midwest",
             "South", "South", "South", "South", "South", "South", "South", "South", "South", "South", "South", "South", "South", "South", "South", "South",
             "Northeast", "Northeast", "Northeast", "Northeast", "Northeast", "Northeast", "Northeast", "Northeast", "Northeast"))

school_scores_and_lang_df <- left_join(school_scores_and_lang_df, state_region_lookup, by = "State.Code")

#NEW CONTINUOUS/NUMERICAL VARIABLE
# setup
#   average percent of children who speak another language
national_second_language_avgs <- language_df %>%
                                    filter(`State.Name` == "United States")
national_second_language_avgs <- national_second_language_avgs %>%
                                    rename(`Extra Language Percent` = English.Speaker)

#   join scores with national averages to get diff
school_scores_and_lang_df <- school_scores_and_lang_df %>%
                                left_join(national_second_language_avgs, by = c("Year" = "TimeFrame"))

# adding column for continuous numerical variable
school_scores_and_lang_df <- school_scores_and_lang_df %>%
                                mutate((extra_lang_nat_avg_perc_diff = as.numeric(gsub("[^0-9.]", "", 
                                `English.Speaker`)) - as.numeric(gsub("[^0-9.]", "", `Extra Language Percent`))) * 100)

#reselecting columns
school_scores_and_lang_df <- school_scores_and_lang_df %>% 
                                select(-LocationType, -State.Name.y, -DataFormat)

# SUMMARY DATASET
# Create a new dataset with averaged scores by state
state_averages_df <- school_scores_and_lang_df %>%
                        group_by(`State.Code`) %>%
                        summarise(
                          Average_Math = mean(Total.Math, na.rm = TRUE),
                          Average_Verbal = mean(Total.Verbal, na.rm = TRUE),
                          Average_Extra_Lang_Perc = mean (as.numeric((English.Speaker), na.rm = TRUE) * 100)
                        )