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

chicksaf <- read_csv("inputs/data/chicksaf.csv")
floaf <- read_csv("inputs/data/floaf.csv")
lordeaf <- read_csv("inputs/data/lordeaf.csv")
vincentaf <- read_csv("inputs/data/vincentaf.csv")
lanaaf <- read_csv("inputs/data/lanaaf.csv")
tayloraf <- read_csv("inputs/data/tayloraf.csv")
bleachersaf <- read_csv("inputs/data/bleachersaf.csv")
haimaf <- read_csv("inputs/data/haimaf.csv")
maggierogersaf <- read_csv("inputs/data/maggierogersaf.csv")
sharonaf <- read_csv("inputs/data/sharonaf.csv")
marinaaf <- read_csv("inputs/data/marinaaf.csv")
mitskiaf <- read_csv("inputs/data/mitskiaf.csv")

#### Clean data ####
# Binding Data

df <- rbind(lanaaf, tayloraf, vincentaf, lordeaf, chicksaf, floaf, bleachersaf,
            haimaf, maggierogersaf, sharonaf, marinaaf, mitskiaf)
df$jack = NA

jack_tracks <- c(
  "Green Light",
  "Sober",
  "The Louvre",
  "Liability",
  "Hard Feelings/Loveless",
  "Sober II (Melodrama)",
  "Writer in the Dark",
  "Supercut",
  "Liability (Reprise)",
  "Perfect Places",
  "New York",
  "Masseduction",
  "Happy Birthday, Johnny",
  "Sugarboy",
  "Look What You Made Me Do",
  "Getaway Car",
  "Dress",
  "This Is Why We Can't Have Nice Things",
  "Call It What You Want",
  "New Year's Day",
  "Mariners Apartment Complex",
  "Venice Bitch",
  "hope is a dangerous thing for a woman like me to have - but i have it",
  "How To Disappear",
  "Norman Fucking Rockwell",
  "Fuck It, I Love You",
  "Love Song",
  "Cinnamon Girl",
  "The Greatest",
  "California",
  "Happiness Is a Butterfly",
  "Looking for America",
  "Cruel Summer",
  "Lover",
  "The Archer",
  "I Think He Knows",
  "Paper Rings",
  "Cornelia Street",
  "Death By a Thousand Cuts",
  "London Boy",
  "Soon You'll Get Better",
  "False God",
  "Daylight",
  "Lover (Remix)",
  "Gaslighter",
  "Sleep at Night",
  "Texas Man",
  "Everybody Loves You",
  "For Her",
  "March March",
  "My Best Friend's Weddings",
  "Tights on My Boat",
  "Julianna Calm Down",
  "Young Man",
  "Hope It's Something Good",
  "Set Me Free",
  "My Tears Ricochet",
  "Mirrorball",
  "August",
  "This Is Me Trying",
  "Illicit Affairs",
  "Betty",
  "The Lakes",
  "Gold Rush",
  "Ivy",
  "White Dress",
  "Chemtrails over the Country Club",
  "Tulsa Jesus Freak",
  "Let Me Love You Like a Woman",
  "Wild at Heart",
  "Dark But Just a Game",
  "Not All Who Wander Are Lost",
  "Breaking Up Slowly",
  "Dance Till We Die",
  "For Free",
  "Mr. Perfectly Fine (Taylor's Version)",
  "That's When (Taylor's Version)",
  "Don't You (Taylor's Version)",
  "Bye Bye Baby (Taylor's Version)",
  "Babe (Taylor's Version)",
  "Forever Winter (Taylor's Version)",
  "All Too Well (10 Minute Version) (Taylor's Version)",
  "Pay Your Way in Pain",
  "Down and Out Downtown",
  "Daddy's Home",
  "Live in the Dream",
  "The Melting of the Sun",
  "Humming (Interlude 1)",
  "The Laughing Man",
  "Down",
  "Humming (Interlude 2)",
  "Somebody Like Me",
  "My Baby Wants a Baby",
  "...At the Holiday Party",
  "Candy Darling",
  "Humming (Interlude 3)",
  "The Path",
  "Solar Power",
  "California",
  "Stoned at the Nail Salon",
  "Fallen Fruit",
  "Secrets from a Girl (Who's Seen it All)",
  "The Man with the Axe",
  "Dominoes",
  "Big Star",
  "Leader of a New Regime",
  "Mood Ring",
  "Oceanic Feeling",
  "Helen of Troy",
  "Hold No Grudge",
  "King",
  "Free",
  "Choreomania",
  "Back in Town",
  "Girls Against God",
  "Dream Girl Evil",
  "Prayer Factory",
  "Cassandra",
  "Heaven Is Here",
  "The Bomb",
  "Morning Elvis",
  "Funkytown",
  "Lavender Haze",
  "Maroon",
  "Anti-Hero",
  "Snow On The Beach",
  "You're On Your Own, Kid",
  "Midnight Rain",
  "Question...?",
  "Vigilante Shit",
  "Bejeweled",
  "Labyrinth",
  "Karma",
  "Sweet Nothing",
  "Mastermind",
  "Bigger Than the Whole Sky",
  "Paris",
  "Glitch",
  "Dear Reader",
  "Hits Different",
  "Did You Know That There's a Tunnel Under Ocean Blvd",
  "A&W")
df$jack <- ifelse(df$track_name %in% jack_tracks, "1", "0")
df$jack[df$artist_name == "Bleachers"] <- "1"


df$danceability <- as.numeric(df$danceability)
df$energy <- as.numeric(df$energy)
df$acousticness <- as.numeric(df$acousticness)
df$tempo <- as.numeric(df$tempo)
df$instrumentalness <- as.numeric(df$instrumentalness)
df$loudness <- as.numeric(df$loudness)
df$valence <- as.numeric(df$valence)
df$jack <- as.factor(df$jack)
df$key <- as.numeric(df$key)
df$mode <- as.numeric(df$mode)



#### Save data ####


write.csv(df, "inputs/data/df.csv")


