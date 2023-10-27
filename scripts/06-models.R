#### Preamble ####
# Purpose: Logistic Regression
# Author: Michaela Drouillard
# Data: 17 March 2023
# Contact: michaela.drouillard@mail.utoronto.ca
# License: MIT



library(tidyverse)
library(lubridate)

data <- read_csv(here::here("inputs/data/clean_df.csv"))

data <- 
  data |> 
  mutate(jack = as_factor(jack)) |> 
  filter(album_release_date_precision == "day") |>
  mutate(album_release_date = ymd(album_release_date))


data_reduced <- 
  data |> 
  select(producer, 
         danceability, energy, loudness, mode,
         speechiness, acousticness, instrumentalness, liveness, valence,
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







