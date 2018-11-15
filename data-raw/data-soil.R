# random ------------------------------------------------------------------

# Some soil data from Barro Colorado Island.
# Source: Graham Zemunik (via https://goo.gl/2EwLQJ).

library(tidyverse)

example_soil <- read_csv(
  here::here("data-raw/from_Graham_Zemunik/example soil.csv")
)

# Randomize
soil_random <- example_soil
var <- example_soil$M3Al
soil_random$M3Al <- sample(var, length(var))
# Expect FALSE
identical(soil_random, example_soil)

soil_random <- set_names(soil_random, tolower)
# Subset
soil_random <- sample_n(soil_random, 100)
soil_random <- arrange(soil_random, gx, gy)
use_data(soil_random, overwrite = TRUE)



# fake --------------------------------------------------------------------

soil_fake <- tibble(
  gx = sample.int(1000, 30),
  gy = sample.int(500, 30),
  mg = sample(seq(0.43, 0.74, 0.01), 30, replace = TRUE),
  c = sample(seq(0.45, 2.47, 0.1), 30, replace = TRUE),
  p = sample(seq(5.1, 7.15, 0.1), 30, replace = TRUE),
) %>%
  arrange(gx, gy)
use_data(soil_fake, overwrite = TRUE)
