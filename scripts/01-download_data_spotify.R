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


#### Download data ####


?spotifyr
lana <- get_artist_audio_features("lana del rey")
taylor <- get_artist_audio_features("taylor swift")
vincent <- get_artist_audio_features("st vincent")
chicks <- get_artist_audio_features("the chicks")
lorde <- get_artist_audio_features("lorde")
flo <- get_artist_audio_features("florence and the machine")


#### Save data ####

write_csv(lana, "inputs/data/lana.csv") 
write_csv(taylor, "inputs/data/taylor.csv") 
write_csv(vincent, "inputs/data/vincent.csv") 
write_csv(chicks, "inputs/data/chicks.csv") 
write_csv(lorde, "inputs/data/lorde.csv") 
write_csv(flo, "inputs/data/flo.csv") 




