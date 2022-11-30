## PROJECT: Trustpilot Q4 2022 Causal Impact Analysis
## TITLE: Causal Impact Analysis (Free Signups)
## AUTHOR(S): Henry Johnston-Ellis
## DATE: Thu Nov 17 15:30:26 2022

## NOTES:

## LOAD LIBRARIES ---------------------

library(tidyverse)
library(here)
library(CausalImpact)

## LOAD DATA --------------------------

business_free_signups <-
  read_csv(here("03.Data/interim/business_free_signups_2021_2022.csv")) %>%
  filter(date <= as.Date("2022-11-13"))

## CAUSAL IMPACT ANALYSIS -------------

## Set dates
time.points <- seq.Date(as.Date("2021-01-01"), by = 1, length.out = 682)

## Set campaign periods
pre.period <- as.Date(c("2021-01-01", "2022-10-01"))
post.period <- as.Date(c("2022-10-02", "2022-11-13"))

## Create zoo matrix
causal_analysis_data_full <-
  zoo(cbind(business_free_signups$IT,
            business_free_signups$AT,
            business_free_signups$CH,
            business_free_signups$DE,
            business_free_signups$FR,
            business_free_signups$SE),
      time.points)

causal_analysis_data_partial <-
  zoo(cbind(business_free_signups$IT,
            business_free_signups$DE,
            business_free_signups$FR),
      time.points)

## Run causal impact function
causal_impact_results_full <-
  CausalImpact(causal_analysis_data_full, pre.period, post.period)

causal_impact_results_partial <-
  CausalImpact(causal_analysis_data_partial, pre.period, post.period)

## VIEW RESULTS -----------------------

summary(causal_impact_results_full)

## SAVE RESULTS -----------------------

saveRDS(causal_impact_results_full,
        file = here("05.Output/models/causal_impact_model_free_signups_full.Rds"))
saveRDS(causal_impact_results_partial,
        file = here("05.Output/models/causal_impact_model_free_signups_partial.Rds"))
