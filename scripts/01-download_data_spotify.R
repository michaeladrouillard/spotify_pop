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


?spotifyr
lanaaf <- get_artist_audio_features("lana del rey")
tayloraf <- get_artist_audio_features("taylor swift")
vincentaf <- get_artist_audio_features("st vincent")
chicksaf <- get_artist_audio_features("the chicks")
lordeaf <- get_artist_audio_features("lorde")
floaf <- get_artist_audio_features("florence and the machine")
bleachersaf <- get_artist_audio_features("bleachers")


#### Save data audio features ####

write_csv(lanaaf, "inputs/data/lanaaf.csv") 
write_csv(tayloraf, "inputs/data/tayloraf.csv") 
write_csv(vincentaf, "inputs/data/vincentaf.csv") 
write_csv(chicksaf, "inputs/data/chicksaf.csv") 
write_csv(lordeaf, "inputs/data/lordeaf.csv") 
write_csv(floaf, "inputs/data/floaf.csv") 
write_csv(bleachersaf, "inputs/data/bleachersaf.csv") 

#### Download data audio analysis####


?spotifyr
test <- get_track_audio_analysis("4brdb8L2Cy3e9AN8IfV9l8",  authorization = get_spotify_access_token())




