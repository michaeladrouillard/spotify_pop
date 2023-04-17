
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

write_csv(data_reduced,"inputs/data/data_reduced.csv")

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


#so this is comparing the basic model and the downsampled one
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

#first u pass in ur wf set, then u pass which function,
#then u pass in things u need for the tuning. like resamples,
# values for penalty (grid=16), pass in metrics
#accuracy and roc_auc are basic metrics
# add logloss, which looks at model as a whole, measures how wrong u r.
# helps measure that u do a better job. i.e. .6 and .9 would
#still be in positive class, but it tells you how wrong you are
#sensitivity, specifity: measure how well u do on one class versus the other
# (important for unbalanced dataset)
#passing params. knows from exp that default penalty is really broad -10, 0.
#make it much much narrower


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

#x axis is workflow rank, so which workflow are we on
#ok so we have good accuracy and good specificity. but low
#low specificity and low log loss
#dont quite understand workflow rank?
#theres no right metric to evaluate model. you have to understand
# it holistically and look at a bunch of different metrics
#sanity check with rohan

rank_results(tune_rs, rank_metric = "sensitivity")
rank_results(tune_rs, rank_metric = "mn_log_loss")
rank_results(tune_rs, rank_metric = "accuracy")
rank_results(tune_rs, rank_metric = "specificity")

#the only one where downsampling is ranked higher is specificity...
#wouldn't it make more sense to go with the basic one then?

downsample_rs <-
  tune_rs %>%
  extract_workflow_set_result("downsampling_glmnet")

#tuning result for recipe that included downsampling + glmnet model
plotdownsample <- autoplot(downsample_rs) + ggtitle("Downsampled Data")


basic_rs <-
  tune_rs %>%
  extract_workflow_set_result("basic_glmnet")

plotbasic <- autoplot(basic_rs) + ggtitle("Original Data")

library(gridExtra)
grid.arrange(plotdownsample, plotbasic, ncol=2)
#on the right is a lot of regularization, so just throw a bunch of predictors out

#we want specificity because we specifically care about the variables..




#this gives me this penalty. this is the biggest penalty
#where u get log loss that is about the same performance has the best value

#should i change this to specificity?


best_penalty <- 
  downsample_rs %>%
  select_by_one_std_err(-penalty, metric = "mn_log_loss")

best_penalty


# last fit is a convenient helper function that fits one time to the training data
#and evaluates one time on the testing data
final_fit <-  
  wf_set %>% 
  extract_workflow("downsampling_glmnet") %>%
  finalize_workflow(best_penalty) %>%
  last_fit(jack_split)

final_fit

collect_metrics(final_fit)


jackmatrix <- collect_predictions(final_fit) %>%
  conf_mat(jack, .pred_class)

jackmatrix

jackmatrix_df <- as.data.frame(jackmatrix$table)
write.table(jackmatrix_df, file = "path/to/folder/jackmatrix.txt", sep = "\t")


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
