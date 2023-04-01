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


library(caret)
library(rstanarm)

# Set seed for reproducibility
set.seed(123)

# Split data into training and testing sets
train_index <- createDataPartition(df$jack, p = 0.7, list = FALSE)
train_data <- df[train_index, ]
test_data <- df[-train_index, ]

#balance the classes by undersampling
train_data_balanced <- train_data |>
  group_by(jack) |>
  sample_n(size = min(table(jack))) |>
  ungroup()



model <- stan_glm(jack ~ danceability + energy + loudness + speechiness + key + 
                    acousticness + instrumentalness + liveness + valence,
                  data = train_data_balanced,
                  family = binomial(),
                  prior_intercept = normal(0,10),
                  prior = normal(0,2.5),
                  chains = 4, iter = 2000)

# Make predictions on the testing data
#probabilities <- predict(model, newdata = test_data, type = "response")
#predictions <- ifelse(probabilities >= 0.5, "Yes", "No")

# Add the predictions to the testing data
test_data$predictions <- ifelse(predict(model, newdata = test_data, type = "response") > 0.5, "Yes", "No")


# convert factors to the same set of levels
test_data$jack <- ifelse(test_data$jack == 1, "Yes", "No")
test_data$jack <- factor(test_data$jack, levels = c("Yes", "No"))
test_data$predictions <- factor(test_data$predictions, levels = c("Yes", "No"))


confusion_matrix <- confusionMatrix(test_data$predictions, test_data$jack)
print(confusion_matrix)

confusion_matrix$byClass



confusion_matrix2
precision <- confusion_matrix[2, 2] / sum(confusion_matrix[, 2])
recall <- confusion_matrix[2, 2] / sum(confusion_matrix[2, ])
f1_score <- 2 * precision * recall / (precision + recall)
precision
recall
f1_score

#... do these features just not tell us anything about the song?


