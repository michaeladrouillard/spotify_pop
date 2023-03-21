#### Preamble ####
# Purpose: Models the Jack Antonoffification of Pop Music
# Author: Michaela Drouillard
# Data: 17 March 2023
# Contact: michaela.drouillard@mail.utoronto.ca
# License: MIT

#Going to make a smaller df that only had the columns we want to capture correlations

library(ggplot2)

data <- read_csv("inputs/data/df.csv")

#chisquared test from website http://www.sthda.com/english/wiki/chi-square-test-of-independence-in-r
#not including liveness because its negative values
df_chisq <- df[, c("artist_name", "track_name", "danceability",                
                   "energy", "key","loudness", "speechiness", "acousticness",                
                   "instrumentalness", "valence", "jack")]

chisq <- chisq.test(df_chisq)
chisq








# select the relevant columns
cols <- c("danceability", "energy", "key", "loudness", "speechiness", "acousticness", "instrumentalness", "liveness", "valence", "jack")

# create a new dataframe with only the selected columns
df_small <- data[,cols]
levels(df_small$jack)
# Replace NAs with 0 in the jack column
df_small$jack <- ifelse(is.na(df_small$jack), 0, df_small$jack)



# perform t-tests for continuous variables
for (col in cols[!cols %in% c("artist_name", "track_name", "jack")]) {
  ttest <- t.test(df_small[[col]] ~ df_small$jack)
  print(paste("T-test for", col))
  print(ttest)
}

#SIGNIFICANT P VALUES: danceability, energy, loudness, acousticness, instrumentalness, liveness, valence
#NOT SIGNIFCANT: Speechiness, Key


# perform chi-square tests for categorical variables
for (col in cols[!cols %in% c("artist_name", "track_name", "jack")]) {
  chisq <- chisq.test(table(df_small[[col]], df_small$jack))
  print(paste("Chi-square test for", col))
  print(chisq)
}

#SIGNIFICANT P VALUES: all of them??








