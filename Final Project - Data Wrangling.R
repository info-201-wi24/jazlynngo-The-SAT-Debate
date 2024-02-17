library(dplyr)

#DataFrames
language_df <- read.csv("Children who speak a language other than English at home.csv")
school_scores_df <- read.csv("school_scores 3.csv")

#Joining DataFrames
# cleaning language dataframe
language_df <- language_df %>%
                  filter(DataFormat == "Percent")

#joined dataframes
school_scores_and_lang_df <- left_join(language_df, school_scores_df, by = "State.Name")

#Cleaning Joined DataFrame
school_scores_and_lang_df <- school_scores_and_lang_df %>% 
                                filter(State.Name != "Puerto Rico") %>% 
                                filter(TimeFrame == Year)
                                # TO DO: select columns that we want 
                                
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
  filter(`State.Name` == "United States", DataFormat == "Percent")
national_second_language_avgs <- national_second_language_avgs %>%
  rename(`Extra Language Percent` = English.Speaker)

#   join scores with national averages to get diff
school_scores_and_lang_df <- school_scores_and_lang_df %>%
  left_join(national_second_language_avgs, by = c("TimeFrame" = "TimeFrame"))

# adding column for continuous numerical variable
school_scores_and_lang_df <- school_scores_and_lang_df %>%
  mutate((extra_lang_nat_avg_perc_diff = as.numeric(gsub("[^0-9.]", "", 
  `English.Speaker`)) - as.numeric(gsub("[^0-9.]", "", `Extra Language Percent`))) * 100)


# SUMMARY DATASET
# Create a new dataset with averaged scores by state
state_averages_df <- school_scores_and_lang_df %>%
  group_by(`State.Code`) %>%
  summarise(
    Average_Math = mean(Total.Math, na.rm = TRUE),
    Average_Verbal = mean(Total.Verbal, na.rm = TRUE),
    Average_Extra_Lang_Perc = mean (as.numeric((English.Speaker), na.rm = TRUE) * 100)
  )
