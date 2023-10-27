#### Preamble ####
# Purpose: Graphs
# Author: Michaela Drouillard
# Data: 28 February 2023
# Contact: michaela.drouillard@mail.utoronto.ca
# License: MIT



#### Workspace setup ####
library(tidyverse)
library(lubridate)

df <- read_csv("inputs/data/clean_df.csv")




str(df)

#### PLOTTING EVERY VARIABLE ##### 



## ENERGY: Antonoff red, everyone else blue

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
          "Lana Del Rey", "Lorde", "Marina", 
          "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = energy, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  
                                "epworth" = "#AED6F1",   
                                "kurstin" = "#5DADE2",   
                                "little" = "#34495E",   
                                "novels" = "#2874A6",    
                                "other" = "#5499C7")) +    
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)


## ENERGY: Antonoff red, everyone else "other", gray

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date),
         producer = ifelse(producer == "antonoff", "antonoff", "other")) %>%
  ggplot(aes(y = energy, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  # Muted pink
                                "other" = "#D5D8DC")) +   # Muted grey
labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)



## DANCEABILITY: Antonoff red, everyone else blue

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = danceability, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  
                                "epworth" = "#AED6F1",   
                                "kurstin" = "#5DADE2",   
                                "little" = "#34495E",   
                                "novels" = "#2874A6",    
                                "other" = "#5499C7")) +    
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)


## DANCEABILITY: Antonoff red, everyone else "other", gray

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date),
         producer = ifelse(producer == "antonoff", "antonoff", "other")) %>%
  ggplot(aes(y = danceability, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  # Muted pink
                                "other" = "#D5D8DC")) +   # Muted grey
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)



## VALENCE: Antonoff red, everyone else blue

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = valence, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  
                                "epworth" = "#AED6F1",   
                                "kurstin" = "#5DADE2",   
                                "little" = "#34495E",   
                                "novels" = "#2874A6",    
                                "other" = "#5499C7")) +    
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)


## VALENCE: Antonoff red, everyone else "other", gray

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date),
         producer = ifelse(producer == "antonoff", "antonoff", "other")) %>%
  ggplot(aes(y = valence, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  # Muted pink
                                "other" = "#D5D8DC")) +   # Muted grey
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)



## ACOUSTICNESS : Antonoff red, everyone else blue

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = acousticness, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  
                                "epworth" = "#AED6F1",   
                                "kurstin" = "#5DADE2",   
                                "little" = "#34495E",   
                                "novels" = "#2874A6",    
                                "other" = "#5499C7")) +    
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)


## ACOUSTICNESS: Antonoff red, everyone else "other", gray

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date),
         producer = ifelse(producer == "antonoff", "antonoff", "other")) %>%
  ggplot(aes(y = acousticness, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  # Muted pink
                                "other" = "#D5D8DC")) +   # Muted grey
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)


## INSTRUMENTALNESS : Antonoff red, everyone else blue

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = instrumentalness, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  
                                "epworth" = "#AED6F1",   
                                "kurstin" = "#5DADE2",   
                                "little" = "#34495E",   
                                "novels" = "#2874A6",    
                                "other" = "#5499C7")) +    
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)


## INSTRUMENTALNESS: Antonoff red, everyone else "other", gray

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date),
         producer = ifelse(producer == "antonoff", "antonoff", "other")) %>%
  ggplot(aes(y = instrumentalness, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  # Muted pink
                                "other" = "#D5D8DC")) +   # Muted grey
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)


## TEMPO : Antonoff red, everyone else blue

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = tempo, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  
                                "epworth" = "#AED6F1",   
                                "kurstin" = "#5DADE2",   
                                "little" = "#34495E",   
                                "novels" = "#2874A6",    
                                "other" = "#5499C7")) +    
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)


## TEMPO: Antonoff red, everyone else "other", gray

df %>%
  filter(album_release_date_precision == "day" &
           artist_name %in% c("Bleachers", "Florence + The Machine", 
                              "Lana Del Rey", "Lorde", "Marina", 
                              "St.Vincent", "Taylor Swift", "The Chicks")) %>%
  mutate(album_release_date = ymd(album_release_date),
         producer = ifelse(producer == "antonoff", "antonoff", "other")) %>%
  ggplot(aes(y = tempo, x = album_release_date, color = producer)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  # Muted pink
                                "other" = "#D5D8DC")) +   # Muted grey
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3) +
  geom_smooth(method = "lm", se = FALSE)




## Plotting CDFs ##
data_reduced <- 
  df |> 
  select(producer, 
         danceability, energy, loudness, mode,
         speechiness, acousticness, instrumentalness, liveness, valence,
         tempo
  ) 


## All Producers ##
data_reduced |> 
  pivot_longer(cols = c(danceability, energy, loudness, mode,
                        speechiness, acousticness, instrumentalness, liveness, valence,
                        tempo),
               names_to = "name",
               values_to = "value"
  ) |> 
  ggplot(aes(x = value, color = producer)) +
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

## Isolate Antonoff ##

# Recode the producer variable
jack_reduced <- data_reduced %>%
  mutate(producer = ifelse(producer == "antonoff", "antonoff", "other"))

# Create the plot
jack_reduced %>%
  pivot_longer(cols = c(danceability, energy, loudness, mode,
                        speechiness, acousticness, instrumentalness, liveness, valence,
                        tempo),
               names_to = "name",
               values_to = "value"
  ) %>%
  ggplot(aes(x = value, color = producer)) +
  stat_ecdf() +
  facet_wrap(vars(name), 
             nrow = 3, 
             ncol = 4,
             scales = "free") +
  theme_minimal() +
  scale_color_manual(values = c("antonoff" = "#D98880",  
                                "other" = "#D5D8DC"))   
labs(
  x = "Value",
  y = "Proportion"
)






## Mean value of each variable


#leaving this here for EDA purposes, but tempo and loudness both don't show large
#differences and are measured on different scales
data_reduced %>%
  group_by(producer) %>%
  summarise(across(everything(), mean)) %>%
  pivot_longer(cols = -producer) %>%
  ggplot(aes(value, name, fill = factor(producer))) +
  geom_col(alpha = 0.8, position = "dodge")


# Every producer

data_reduced %>%
  group_by(producer) %>%
  summarise(across(-c(tempo, loudness), mean)) %>%
  pivot_longer(cols = -producer) %>%
  ggplot(aes(value, name, fill = factor(producer))) +
  geom_col(alpha = 0.8, position = "dodge")


#Isolate Antonoff


data_reduced %>%
  group_by(producer) %>%
  summarise(across(-c(tempo, loudness), mean)) %>%
  pivot_longer(cols = -producer) %>%
  ggplot(aes(value, name, fill = factor(producer))) +
  geom_col(alpha = 0.8, position = "dodge") +
  scale_fill_manual(values = c(
    "antonoff" = "#D98880", 
    "epworth" = "#85C1E9",
    "kurstin" = "#3498DB",
    "little" = "#2874A6",
    "martin" = "#1B4F72",
    "nowels" = "#5499C7",
    "other" = "#AED6F1",
    "rechstshaid" = "#2E86C1"
  )) +
  theme_minimal()

