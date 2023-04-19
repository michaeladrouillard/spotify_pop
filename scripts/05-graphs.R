#### Preamble ####
# Purpose: Graphs
# Author: Michaela Drouillard
# Data: 28 February 2023
# Contact: michaela.drouillard@mail.utoronto.ca
# License: MIT



#### Workspace setup ####
library(tidyverse)
library(lubridate)

df <- read_csv("inputs/data/df.csv")

str(df)

df$jack <- as.factor(df$jack)



df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = energy, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)

df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = danceability, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)

df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = valence, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)

df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = acousticness, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)

df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = instrumentalness, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)


df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = tempo, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3)  +
  geom_smooth(method = "lm", se = FALSE)

#adding lines?

df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = energy, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)


df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = energy, x = album_release_date, color = jack, alpha = 0.5)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)

## Plotting cdfs
data_reduced <- 
  df |> 
  select(jack, 
         danceability, energy, loudness, mode,
         speechiness, acousticness, instrumentalness, liveness, valence,
         tempo
  ) 

data_reduced |> 
  pivot_longer(cols = c(danceability, energy, loudness, mode,
                        speechiness, acousticness, instrumentalness, liveness, valence,
                        tempo),
               names_to = "name",
               values_to = "value"
  ) |> 
  ggplot(aes(x = value, color = jack)) +
  stat_ecdf() +
  facet_wrap(vars(name), 
             nrow = 3, 
             ncol = 4,
             scales = "free") +
  theme_minimal() +
  labs(
    x = "Value",
    y = "Proportion"
  )


## Mean value of each variable

data_reduced %>%
  group_by(jack) %>%
  summarise(across(everything(), mean)) %>%
  pivot_longer(cols = -jack) %>%
  ggplot(aes(value, name, fill = factor(jack))) +
  geom_col(alpha = 0.8, position = "dodge")


data_reduced %>%
  group_by(jack) %>%
  summarise(across(-c(tempo, loudness), mean)) %>%
  pivot_longer(cols = -jack) %>%
  ggplot(aes(value, name, fill = factor(jack))) +
  geom_col(alpha = 0.8, position = "dodge")



