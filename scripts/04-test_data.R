#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Data: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
# [...UPDATE THIS...]

#### Test data ####

colnames(df)
str(df)

df$danceability <- as.numeric(df$danceability)
df$energy <- as.numeric(df$energy)
df$acousticness <- as.numeric(df$acousticness)
df$tempo <- as.numeric(df$tempo)
df$instrumentalness <- as.numeric(df$instrumentalness)
df$loudness <- as.numeric(df$loudness)
df$valence <- as.numeric(df$valence)
df$jack <- as.numeric(df$jack)
df$key <- as.numeric(df$key)
df$mode <- as.numeric(df$mode)

# Fit a logistic regression model
model <- glm(jack ~ danceability + energy + acousticness + tempo + instrumentalness + key + mode + loudness + valence, data = df, family = binomial)

# Print the model summary
summary(model)

# Calculate the Pearson correlation coefficients
correlations <- cor(df[c("danceability", "energy", "acousticness", "liveness", "tempo", "key", "valence", "loudness", "mode", "jack")], method = "pearson")

# Print the correlation matrix
print(correlations)

