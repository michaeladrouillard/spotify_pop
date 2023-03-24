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
#cols <- c("danceability", "energy", "key", "loudness", "speechiness", "acousticness", "instrumentalness", "liveness", "valence", "jack")
#jack ~ danceability + energy + loudness + speechiness + key + acousticness + instrumentalness + liveness + valence


jack_model <-
  glm(jack ~ danceability + energy + loudness + speechiness + key + acousticness + instrumentalness + liveness + valence,
      data = df,
      family = "binomial"
  )

library(marginaleffects)

jack_predictions <-
  predictions(jack_model) |>
  as_tibble()

jack_predictions

jack_predictions |>
  ggplot(aes(
    x = valence,
    y = estimate,
    color = jack
  )) +
  geom_jitter(width = 0.01, height = 0.01, alpha = 0.3) +
  labs(
    x = "Valence",
    y = "Estimated probability that Jack produced them",
    color = "Was it actually Jack"
  ) +
  theme_classic() +
  scale_color_brewer(palette = "Set1") +
  theme(legend.position = "bottom")

