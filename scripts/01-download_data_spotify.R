#### Preamble ####
# Purpose: Downloads and saves the data from Spotify
# Author: Michaela Drouillard
# Data: 27 February 2023
# Contact: rohan.alexander@utoronto.ca 
# License: MIT
# Pre-requisites: -
# Any other information needed?-

#### Workspace setup ####

#run install.packages in console!!!!
library(spotifyr)
library(tidyverse)


#### Download data ####


?spotifyr
lana <- get_artist_audio_features("lana del rey")
taylor <- get_artist_audio_features("taylor swift")
vincent <- get_artist_audio_features("st vincent")
chicks <- get_artist_audio_features("the chicks")
lorde <- get_artist_audio_features("lorde")
flo <- get_artist_audio_features("florence and the machine")


#### Save data ####

saveRDS(lana, "inputs/data/lana.rds")
saveRDS(taylor, "inputs/data/taylor.rds")
saveRDS(vincent, "inputs/data/vincent.rds")
saveRDS(lorde, "inputs/data/lorde.rds")
saveRDS(chicks, "inputs/data/chicks.rds")
saveRDS(flo, "inputs/data/flo.rds")
?spotifyr


