## PROJECT: Trustpilot Q4 2022 Causal Impact Analysis
## TITLE: Download Data
## AUTHOR(S): Henry Johnston-Ellis
## DATE: Wed Nov 16 14:48:48 2022

## NOTES:

## SET CREDENTIALS --------------------

## LOAD LIBRARIES ---------------------

library(tidyverse)
library(googleAnalyticsR)

## GETTING VIEW ID --------------------

## Get list of accounts
my_accounts <- ga_account_list()

## LOAD DATA --------------------------

## Set ViewID for trustpilot business
trustpilot_business_id <- 98879677

## Business conversions (demo request) for DE, IT, FR, SE, CH and AT
business_demo_requests <- google_analytics(
  trustpilot_business_id, 
  date_range = c("2021-01-01", "2022-11-15"),
  metrics = c("goal10Completions"),
  dimensions = c("date", "countryIsoCode"),
  filter_clause_ga4(list(dim_filter("ga:countryIsoCode", "EXACT", "DE"),
                         dim_filter("ga:countryIsoCode", "EXACT", "IT"),
                         dim_filter("ga:countryIsoCode", "EXACT", "FR"),
                         dim_filter("ga:countryIsoCode", "EXACT", "SE"),
                         dim_filter("ga:countryIsoCode", "EXACT", "CH"),
                         dim_filter("ga:countryIsoCode", "EXACT", "AT")),
                    operator = "OR"),
  anti_sample = TRUE
)

## Business conversions (free signup) for DE, IT, FR, SE, CH and AT
business_free_signups <- google_analytics(
  trustpilot_business_id, 
  date_range = c("2021-01-01", "2022-11-15"),
  metrics = c("goal6Completions"),
  dimensions = c("date", "countryIsoCode"),
  filter_clause_ga4(list(dim_filter("ga:countryIsoCode", "EXACT", "DE"),
                         dim_filter("ga:countryIsoCode", "EXACT", "IT"),
                         dim_filter("ga:countryIsoCode", "EXACT", "FR"),
                         dim_filter("ga:countryIsoCode", "EXACT", "SE"),
                         dim_filter("ga:countryIsoCode", "EXACT", "CH"),
                         dim_filter("ga:countryIsoCode", "EXACT", "AT")),
                    operator = "OR"),
  anti_sample = TRUE
)

## Business users for DE, IT, FR, SE, CH and AT

business_users <- google_analytics(
  trustpilot_business_id, 
  date_range = c("2021-01-01", "2022-11-15"),
  metrics = c("users"),
  dimensions = c("date", "countryIsoCode"),
  filter_clause_ga4(list(dim_filter("ga:countryIsoCode", "EXACT", "DE"),
                         dim_filter("ga:countryIsoCode", "EXACT", "IT"),
                         dim_filter("ga:countryIsoCode", "EXACT", "FR"),
                         dim_filter("ga:countryIsoCode", "EXACT", "SE"),
                         dim_filter("ga:countryIsoCode", "EXACT", "CH"),
                         dim_filter("ga:countryIsoCode", "EXACT", "AT")),
                    operator = "OR"),
  anti_sample = TRUE
)

## SAVE DATA --------------------------

business_demo_requests %>%
  write_csv("03.Data/raw/business_demo_requests_2021_2022.csv")

business_free_signups %>%
  write_csv("03.Data/raw/business_free_signups_2021_2022.csv")

business_users %>%
  write_csv(here("03.Data/raw/business_users_2021_2022.csv"))
