## PROJECT:
## TITLE:
## AUTHOR(S): Henry Johnston-Ellis
## DATE: Thu Nov 17 15:30:26 2022

## NOTES:

## SET CREDENTIALS --------------------

## LOAD LIBRARIES ---------------------

library(tidyverse)

## LOAD DATA --------------------------

## CAUSAL IMPACT ANALYSIS -------------

## CREATE WIDE DATASET
business_conversions_wide <- business_conversions %>%
  pivot_wider(id_cols = date,
              names_from = countryIsoCode,
              values_from = goal10Completions)

time.points <- seq.Date(as.Date("2021-01-01"), by = 1, length.out = 684)

data_2 <- zoo(cbind(business_conversions_wide[[6]],
                    business_conversions_wide[[4]],
                    business_conversions_wide[[5]],
                    business_conversions_wide[[7]]),
            time.points)

pre.period <- as.Date(c("2021-01-01", "2022-10-01"))
post.period <- as.Date(c("2022-10-02", "2022-11-15"))

impact_2 <- CausalImpact(data_2, pre.period, post.period)

impact$model$alpha