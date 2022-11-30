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

business_demo_requests <- read_csv("03.Data/raw/business_demo_requests_2021_2022.csv")
business_free_signups <- read_csv("03.Data/raw/business_free_signups_2021_2022.csv")
business_users <- read_csv(here("03.Data/raw/business_users_2021_2022.csv"))

## TIDY DATA --------------------------

business_demo_requests <- business_demo_requests %>%
  pivot_wider(id_cols = date,
              names_from = countryIsoCode,
              values_from = goal10Completions)

business_free_signups <- business_free_signups %>%
  pivot_wider(id_cols = date,
              names_from = countryIsoCode,
              values_from = goal6Completions)

business_users <- business_users %>%
  pivot_wider(id_cols = date,
              names_from = countryIsoCode,
              values_from = users)

## SAVE DATA --------------------------

business_demo_requests %>%
  write_csv("03.Data/interim/business_demo_requests_2021_2022.csv")

business_free_signups %>%
  write_csv(here("03.Data/interim/business_free_signups_2021_2022.csv"))
