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


#Checking which tracks have Jack as a producer
jack_tracks_test <- subset(df, jack == "1", select = track_name)$track_name
jack_tracks_test

#There should be 142, but in both of these tests it's 189. Are duplicates okay?

length(jack_tracks_test)
table(df$jack)

colnames(df)
str(df)





