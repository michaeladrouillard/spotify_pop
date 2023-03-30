#### Preamble ####
# Purpose: Models the Jack Antonoffification of Pop Music
# Author: Michaela Drouillard
# Data: 17 March 2023
# Contact: michaela.drouillard@mail.utoronto.ca
# License: MIT

#Going to make a smaller df that only had the columns we want to capture correlations

library(ggplot2)
library(tidyverse)
df <- read_csv("inputs/data/df.csv")

jack_model <-
  glm(jack ~ danceability + energy + loudness + speechiness + key + acousticness + instrumentalness + liveness + valence,
      data = df,
      family = "binomial"
  )



library(rstanarm)


model <- stan_glm(jack ~ danceability + energy + loudness + speechiness + key + 
                    acousticness + instrumentalness + liveness + valence,
                  data = df,
                  family = binomial(),
                  prior_intercept = normal(0,10),
                  prior = normal(0,2.5),
                  chains = 4, iter = 2000)

summary(model)


#danceability has strongest relationship
library(ggplot2)
library(pROC)

probabilities <- predict(model, type = "response")
# Create probabilities column in the original data frame
df$probabilities <- probabilities

### plot an ROC curve?



# Create confusion matrix
library(caret)
predictions <- ifelse(probabilities >= 0.5, "Yes", "No")
df$predictions <- predictions
df$predictions <- factor(predictions, levels = c("Yes", "No"))
df$jack <- factor(df$jack, levels = c(1, 0), labels = c("Yes", "No"))
confusion_matrix <- confusionMatrix(df$predictions, df$jack)


# Print confusion matrix
confusion_matrix
confusion_matrix$byClass



##FK forgot to split the data lol

library(caret)

# Set seed for reproducibility
set.seed(123)

# Split data into training and testing sets
train_index <- createDataPartition(df$jack, p = 0.7, list = FALSE)
train_data <- df[train_index, ]
test_data <- df[-train_index, ]


library(rstanarm)

# Fit the model using only the training data
model <- stan_glm(jack ~ danceability + energy + loudness + speechiness + key + 
                    acousticness + instrumentalness + liveness + valence,
                  data = train_data,
                  family = binomial(),
                  prior_intercept = normal(0,10),
                  prior = normal(0,2.5),
                  chains = 4, iter = 2000)

# Make predictions on the testing data
probabilities <- predict(model, newdata = test_data, type = "response")
predictions <- ifelse(probabilities >= 0.5, "Yes", "No")

# Add the predictions to the testing data
test_data$predictions <- predictions
test_data$jack <- factor(test_data$jack, levels = c(1, 0), labels = c("Yes", "No"))

# Create a confusion matrix
confusion_matrix2 <- table(test_data$predictions, test_data$jack)
confusion_matrix2 <- as.matrix(confusion_matrix2)

# Print the confusion matrix
confusion_matrix2
precision <- confusion_matrix[2, 2] / sum(confusion_matrix[, 2])
recall <- confusion_matrix[2, 2] / sum(confusion_matrix[2, ])
f1_score <- 2 * precision * recall / (precision + recall)
precision
recall
f1_score

#... do these features just not tell us anything about the song?


