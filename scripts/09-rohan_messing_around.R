
# Preamble
library(tidyverse)
library(lubridate)

data <- read_csv(here::here("inputs/data/df.csv"))

data <- 
  data |> 
  mutate(jack = as_factor(jack)) |> 
  filter(album_release_date_precision == "day") |>
  mutate(album_release_date = ymd(album_release_date))


# Make ecdf of the variables, coloured by whether Jack
data_reduced <- 
  data |> 
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



?across
#### Try a model ####
# Code from: https://juliasilge.com/blog/project-feederwatch/

library(tidymodels)

set.seed(853)

jack_split <- 
  data_reduced |>
  initial_split(strata = jack)

jack_train <- training(jack_split)
jack_test <- testing(jack_split)

set.seed(853)
jack_folds <- vfold_cv(jack_train, strata = jack)
jack_folds

is_jack <- 
  recipe(jack ~ ., data = jack_train)
# Oh god, she inputs the mean

## we can `prep()` just to check that it works:
prep(is_jack)

glmnet_spec <- 
  logistic_reg(penalty = tune(), mixture = 1) |>
  set_engine("glmnet")

# install.packages("themis")
library(themis)

wf_set <-
  workflow_set(
    list(basic = is_jack,
         downsampling = is_jack |> step_downsample(jack)),
    list(glmnet = glmnet_spec)
  )

wf_set

narrower_penalty <- penalty(range = c(-3, 0))

# install.packages("doParallel")
doParallel::registerDoParallel()
#install.packages("glmnet")

set.seed(853)

tune_rs <- 
  workflow_map(
    wf_set,
    "tune_grid",
    resamples = jack_folds,
    grid = 15,
    metrics = metric_set(accuracy, mn_log_loss, sensitivity, specificity),
    param_info = parameters(narrower_penalty)
  )

tune_rs

autoplot(tune_rs) + theme(legend.position = "none")

rank_results(tune_rs, rank_metric = "sensitivity")

downsample_rs <-
  tune_rs %>%
  extract_workflow_set_result("downsampling_glmnet")

autoplot(downsample_rs)

best_penalty <- 
  downsample_rs %>%
  select_by_one_std_err(-penalty, metric = "mn_log_loss")

best_penalty

final_fit <-  
  wf_set %>% 
  extract_workflow("downsampling_glmnet") %>%
  finalize_workflow(best_penalty) %>%
  last_fit(jack_split)

final_fit

collect_metrics(final_fit)

collect_predictions(final_fit) %>%
  conf_mat(jack, .pred_class)

# install.packages("vip")
library(vip)
jack_vip <-
  extract_fit_engine(final_fit) %>%
  vi()

jack_vip

jack_vip %>%
  group_by(Sign) %>%
  slice_max(Importance, n = 15) %>%
  ungroup() %>%
  ggplot(aes(Importance, fct_reorder(Variable, Importance), fill = Sign)) + 
  geom_col() +
  facet_wrap(vars(Sign), scales = "free_y") +
  labs(y = NULL) +
  theme(legend.position = "none")
