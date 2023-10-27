#### Preamble ####
# Purpose: Binding the data
# Author: Michela Drouillard
# Data: 28 February 2023 
# Contact: michaela.drouillard@mail.utoronto.ca
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)

df <- read.csv("inputs/data/combined_producers.csv")


df$producer[is.na(df$producer)] <- "other"

write.csv(df, file = "inputs/data/clean_df.csv", row.names = FALSE)


