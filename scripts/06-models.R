#### Preamble ####
# Purpose: Logistic Regression
# Author: Michaela Drouillard
# Data: 17 March 2023
# Contact: michaela.drouillard@mail.utoronto.ca
# License: MIT

library(tidyr)
library(dplyr)
library(tidyverse)
library(lubridate)
library(tidymodels)
library(randomForest)

data <- read_csv(here::here("inputs/data/clean_df.csv"))



data_reduced <- 
  data |> 
  select(producer,danceability, energy, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence,
         tempo
  ) 

write_csv(data_reduced,"inputs/data/data_reduced.csv")


#### Predicting Antonoff ####
## glmnet requires all variables to be numeric, so i'm excluding the producer column

# 1. Create a new binary column
data_reduced$is_antonoff <- ifelse(data_reduced$producer == "antonoff", 1, 0)
set.seed(853)

data_reduced$is_antonoff <- as.factor(data_reduced$is_antonoff)

# 2. Update variable names and strata
antonoff_split <- 
  data_reduced |>
  initial_split(strata = is_antonoff)

antonoff_train <- training(antonoff_split)
antonoff_test <- testing(antonoff_split)

set.seed(853)
antonoff_folds <- vfold_cv(antonoff_train, strata = is_antonoff)
antonoff_folds

# 3. Update the recipe
is_antonoff <- 
  recipe(is_antonoff ~ ., data = antonoff_train) %>%
  step_rm(producer)


# we can `prep()` just to check that it works:
prep(is_antonoff)

glmnet_spec <- 
  logistic_reg(penalty = tune(), mixture = 1) |>
  set_engine("glmnet")

# install.packages("themis")
library(themis)

# Comparing the basic model and the downsampled one
wf_set <-
  workflow_set(
    list(basic = is_antonoff,
         downsampling = is_antonoff |> step_downsample(is_antonoff)),
    list(glmnet = glmnet_spec)
  )

wf_set

narrower_penalty <- penalty(range = c(-3, 0))

# install.packages("doParallel")
doParallel::registerDoParallel()

set.seed(853)

tune_rs <- 
  workflow_map(
    wf_set,
    "tune_grid",
    resamples = antonoff_folds,
    grid = 15,
    metrics = metric_set(accuracy, mn_log_loss, sensitivity, specificity),
    param_info = parameters(narrower_penalty)
  )

tune_rs

autoplot(tune_rs) + theme(legend.position = "none")

rank_results(tune_rs, rank_metric = "sensitivity")
rank_results(tune_rs, rank_metric = "mn_log_loss")
rank_results(tune_rs, rank_metric = "accuracy")
rank_results(tune_rs, rank_metric = "specificity")

downsample_rs <-
  tune_rs %>%
  extract_workflow_set_result("downsampling_glmnet")

# Tuning result for recipe that included downsampling + glmnet model
plotdownsample <- autoplot(downsample_rs) + ggtitle("Downsampled Data")

basic_rs <-
  tune_rs %>%
  extract_workflow_set_result("basic_glmnet")

plotbasic <- autoplot(basic_rs) + ggtitle("Original Data")

library(gridExtra)
grid.arrange(plotdownsample, plotbasic, ncol=2)

best_penalty <- 
  downsample_rs %>%
  select_by_one_std_err(-penalty, metric = "mn_log_loss")

best_penalty

# Last fit is a helper function that fits one time to the training data
# and evaluates one time on the testing data
final_fit <-  
  wf_set %>% 
  extract_workflow("downsampling_glmnet") %>%
  finalize_workflow(best_penalty) %>%
  last_fit(antonoff_split)

final_fit

collect_metrics(final_fit)

antonoffmatrix <- collect_predictions(final_fit) %>%
  conf_mat(is_antonoff, .pred_class)

antonoffmatrix

antonoffmatrix_df <- as.data.frame(antonoffmatrix$table)

# install.packages("vip")
library(vip)
antonoff_vip <-
  extract_fit_engine(final_fit) %>%
  vi()

antonoff_vip


## Predictors ##


antonoff_vip %>%
  group_by(Sign) %>%
  slice_max(Importance, n = 15) %>%
  ungroup() %>%
  ggplot(aes(Importance, fct_reorder(Variable, Importance), fill = Sign)) + 
  geom_col() +
  facet_wrap(vars(Sign), scales = "free_y") +
  labs(y = NULL) +
  theme(legend.position = "none")




### SECOND MODEL: Random Forest ###
# one hot encoding for each producer (is_antonoff 1,0, is_elwroth 1,0, etc)
# multi class classification
install.packages("ranger")
install.packages("caret") # For some helper functions
library(ranger)
library(caret)


data_reduced$producer <- as.factor(data_reduced$producer)

set.seed(853)
antonoff_split <- initial_split(data_reduced, strata = producer)
antonoff_train <- training(antonoff_split)
antonoff_test <- testing(antonoff_split)


rf_model <- ranger(producer ~ ., data = antonoff_train, importance = 'impurity')
#impurity == asking model to interpret variable importance based on gini impurity

rf_predictions <- predict(rf_model, data = antonoff_test)$predictions

confusionMatrix(rf_predictions, antonoff_test$producer)

## Variable Importance
var_importance <- importance(rf_model)
print(var_importance)
sorted_importance <- var_importance[order(-var_importance)]
print(sorted_importance)

## Variable importance for each producer

list_importance <- list()
unique_producers <- unique(data_reduced$producer)

for (producer in unique_producers) {
  data_temp <- data_reduced
  data_temp$producer_binary <- as.factor(ifelse(data_temp$producer == producer, 1, 0))
  
  rf_temp <- randomForest(producer_binary ~ . - producer, data = data_temp, ntree = 100)
  
  importance_temp <- rf_temp$importance
  print(colnames(importance_temp))  # To see available columns
  
  
  list_importance[[producer]] <- importance_temp[,'MeanDecreaseGini']
}



df_importance <- bind_rows(list_importance, .id = "producer")

head(df_importance)



df_importance_long <- df_importance %>%
  gather(variable, importance, -producer)

ggplot(df_importance_long, aes(x = reorder(variable, importance), y = importance)) +
  geom_bar(stat = "identity") +
  facet_wrap(~producer, scales = "free") + 
  coord_flip() +
  labs(title = "Variable Importance by Producer", 
       x = "Variable", 
       y = "Mean Decrease Gini") +
  theme_minimal()



