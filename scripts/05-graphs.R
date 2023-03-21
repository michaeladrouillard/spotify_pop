#### Preamble ####
# Purpose: Graphs
# Author: Michaela Drouillard
# Data: 28 February 2023
# Contact: michaela.drouillard@mail.utoronto.ca
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(lubridate)

df <- read_csv("inputs/data/df.csv")

str(df)
#For whatever reason, Jack didn't stay a factor. Making it a factor again here
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


