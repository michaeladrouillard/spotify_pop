#### Preamble ####
# Purpose: Models the Jack Antonoffification of Pop Music
# Author: Michaela Drouillard
# Data: 17 March 2023
# Contact: michaela.drouillard@mail.utoronto.ca
# License: MIT

#Going to make a smaller df that only had the columns we want to capture correlations

library(ggplot2)
library(tidyverse)
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
# Load necessary packages
library(pROC)
library(ggroc)
library(ggplot2)

# Predict probability of Jack Antonoff producing the song for each observation
probabilities <- predict(model, type = "response")

df_prob <- cbind(df, probabilities)

# Create ROC curve
roc_curve <- roc(jack ~ probabilities, data = df_prob)

# Convert ROC curve to data frame
roc_df <- fortify(roc_curve)

# calculate auc 
auc <- auc(roc_curve)

# Plot ROC curve
ggplot(roc_curve, aes(x = 1 - specificity, y = sensitivity)) + 
  geom_line() + 
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") + 
  ggtitle(paste0("ROC Curve (AUC = ", round(auc, 2), ")")) + 
  xlab("False Positive Rate") + 
  ylab("True Positive Rate")

# Create confusion matrix
predictions <- ifelse(probabilities >= 0.5, 1, 0)
confusion_matrix <- table(predictions, jack)

# Print confusion matrix
confusion_matrix

# Calculate precision, recall, and F1-score
precision <- confusion_matrix[2,2] / sum(confusion_matrix[,2])
recall <- confusion_matrix[2,2] / sum(confusion_matrix[2,])
f1_score <- 2 * precision * recall / (precision + recall)

# Print precision, recall, and F1-score
cat("Precision:", round(precision, 2), "\n")
cat("Recall:", round(recall, 2), "\n")
cat("F1-score:", round(f1_score, 2))


