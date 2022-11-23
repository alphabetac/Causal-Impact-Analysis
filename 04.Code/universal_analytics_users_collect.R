## PROJECT:
## TITLE:
## AUTHOR(S): Henry Johnston-Ellis
## DATE: Thu Nov 17 15:28:44 2022

## NOTES:

## SET CREDENTIALS --------------------

## LOAD LIBRARIES ---------------------

library(tidyverse)
library(hjplottools)
library(plotly)

## LOAD DATA --------------------------

## Load users data from universal analytics

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

## PLOT DATA --------------------------

ggplotly(
  business_users %>%
    ggplot(aes(x = date, y = users)) +
    geom_smooth(aes(linetype = countryIsoCode)) +
    hj_theme()
)
