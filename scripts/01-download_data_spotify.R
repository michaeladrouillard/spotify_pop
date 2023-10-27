#### Preamble ####
# Purpose: Downloads and saves the data from Spotify
# Author: Michaela Drouillard
# Data: 27 February 2023
# Contact: michaela.drouillard@mail.utoronto.ca
# License: MIT
# Pre-requisites: -
# Any other information needed?-

#### Workspace setup ####

library(spotifyr)
library(tidyverse)


#### Download data audio features ####


CP <- read.csv("inputs/data/combined_producers.csv")

