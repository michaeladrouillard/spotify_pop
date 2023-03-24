

library(spotifyr)
holst <- get_artist_audio_features("Gustav Holst")
nikolai <- get_artist_audio_features("Nikolai Rimsky-Korsakov")
write_csv(holst, "inputs/data/holst.csv") 
write_csv(nikolai, "inputs/data/nikolai.csv") 


subset_planets <- subset(holst, track_id %in% c("08i3LqX0LijeLAiuJShjPm", "3OjbUkoryQX47hd0t9HyuK"))

subset_nikolai <- nikolai[grepl("Bumblebee", nikolai$track_id, ignore.case = TRUE), ]

