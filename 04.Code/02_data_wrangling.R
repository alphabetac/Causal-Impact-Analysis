## PROJECT: Trustpilot Q4 2022 Causal Impact Analysis
## TITLE: Download Data
## AUTHOR(S): Henry Johnston-Ellis
## DATE: Wed Nov 16 14:48:48 2022

## NOTES:

## SET CREDENTIALS --------------------

## LOAD LIBRARIES ---------------------

library(here)
library(tidyverse)

## LOAD DATA --------------------------

business_conversions <- read_csv("03.Data/raw/business_conversions_2021_2022")
business_users <- read_csv(here("03.Data/raw/business_users_2021_2022.csv"))

## TIDY DATA --------------------------

business_conversions <- business_conversions %>%
  pivot_wider(id_cols = date,
              names_from = countryIsoCode,
              values_from = goal10Completions)

business_users <- business_users %>%
  pivot_wider(id_cols = date,
              names_from = countryIsoCode,
              values_from = users)

## SAVE DATA --------------------------

business_conversions %>%
  write_csv("03.Data/interim/business_conversions_2021_2022")

business_users %>%
  write_csv(here("03.Data/interim/business_users_2021_2022.csv"))
