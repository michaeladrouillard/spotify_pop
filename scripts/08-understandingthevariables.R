library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyverse)

mydata <- read_csv("inputs/data/df.csv")
#cleaning lol
#next line of code gets rid of the string variables
#mydata <- data.frame(sapply(mydata, as.numeric))
mydata <- mydata[, c("jack", "danceability", "energy", "loudness", "speechiness", "key", "acousticness", "instrumentalness", "liveness", "valence")]

# Verify the new structure of your dataset
str(mydata)


# Examine the distribution of a variable
hist(mydata$danceability, main = "Distribution of Danceability", xlab = "Danceability Score")

# Calculate the mean, median, and standard deviation of a variable
mean(mydata$danceability)
median(mydata$danceability)
sd(mydata$danceability)

# Calculate basic summary statistics for all variables in the dataset
summary(mydata)



# Create a scatterplot of two variables
plot(mydata$danceability, mydata$energy, main = "Danceability vs. Energy", xlab = "Danceability", ylab = "Energy")



##Plotting all the variables##
df <- read.csv(here::here("inputs/data/df.csv"))
df$jack <- factor(df$jack)

library(lubridate)

#Energy
df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
   ggplot(aes(y = energy, x = album_release_date, color = jack)) +
   geom_point() +
   theme_minimal() +
   scale_color_manual(values = c("#FFB6C1", "#808080")) +
   labs(color = "Has 'y' in jack?") +
   facet_wrap(~ artist_name, ncol = 3)


#Danceability
df %>%
   filter(album_release_date_precision == "day") %>%
   mutate(album_release_date = ymd(album_release_date)) %>%
   ggplot(aes(y = danceability, x = album_release_date, color = jack)) +
   geom_point() +
   theme_minimal() +
   scale_color_manual(values = c("#FFB6C1", "#808080")) +
   labs(color = "Has 'y' in jack?") +
   facet_wrap(~ artist_name, ncol = 3)



#Valence
df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = valence, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3)


#Acousticness
df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = acousticness, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3)


#Instrumentalness
df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = instrumentalness, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3)




#Tempo
df %>%
  filter(album_release_date_precision == "day") %>%
  mutate(album_release_date = ymd(album_release_date)) %>%
  ggplot(aes(y = tempo, x = album_release_date, color = jack)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("#FFB6C1", "#808080")) +
  labs(color = "Has 'y' in jack?") +
  facet_wrap(~ artist_name, ncol = 3)









library(corrplot)

# Calculate the correlation matrix
cor_matrix <- cor(mydata)

# Create the correlation plot
corrplot(cor_matrix, method = "circle", type = "lower")
cor(mydata)



library(ggplot2)

# create a scatterplot with energy on the x-axis and valence on the y-axis
ggplot(data = mydata, aes(x = energy, y = valence)) + 
  
  # add points to the scatterplot and color them by artist_name
  geom_point(aes(color = artist_name)) +
  
  # add vertical and horizontal lines to separate the quadrants
  geom_vline(xintercept = mean(mydata$energy), color = "gray") +
  geom_hline(yintercept = mean(mydata$valence), color = "gray") +
  
  # add labels to each quadrant
  annotate("text", x = mean(mydata$energy), y = max(mydata$valence), 
           label = "High Energy, High Valence") +
  annotate("text", x = mean(mydata$energy), y = min(mydata$valence), 
           label = "High Energy, Low Valence") +
  annotate("text", x = min(mydata$energy), y = mean(mydata$valence), 
           label = "Low Energy, High Valence") +
  annotate("text", x = max(mydata$energy), y = mean(mydata$valence), 
           label = "Low Energy, Low Valence") +
  scale_x_continuous(limits = c(min(mydata$energy), max(mydata$energy))) +
  scale_y_continuous(limits = c(min(mydata$valence), max(mydata$valence)))




