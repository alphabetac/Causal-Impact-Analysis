## PROJECT:
## TITLE:
## AUTHOR(S): Henry Johnston-Ellis
## DATE: Wed Nov 16 14:48:48 2022

## NOTES:

## SET CREDENTIALS --------------------

## LOAD LIBRARIES ---------------------

library(tidyverse)
library(googleAnalyticsR)
library(CausalImpact)

## GETTING VIEW ID --------------------

## Get list of accounts
my_accounts <- ga_account_list()

## LOAD DATA --------------------------

## Set ViewID for trustpilot business
trustpilot_business_id <- 98879677

## Italy business sessions
italy_business_sessions <- google_analytics(
  trustpilot_business_id, 
  date_range = c("2022-10-01", "2022-11-15"),
  metrics = c("sessions"),
  dimensions = c("date"),
  filter_clause_ga4(list(dim_filter("ga:countryIsoCode", "EXACT", "IT"),
                         dim_filter("ga:medium", "EXACT", "consumer")),
                    operator = "AND"),
  anti_sample = TRUE
)

## Italy business conversions
italy_business_conversions <- google_analytics(
  trustpilot_business_id, 
  date_range = c("2021-01-01", "2022-11-15"),
  metrics = c("goal10Completions"),
  dimensions = c("date"),
  filter_clause_ga4(list(dim_filter("ga:countryIsoCode", "EXACT", "IT")),
                    operator = "AND"),
  anti_sample = TRUE
)

germany_business_conversions <- google_analytics(
  trustpilot_business_id, 
  date_range = c("2021-01-01", "2022-11-15"),
  metrics = c("goal10Completions"),
  dimensions = c("date"),
  filter_clause_ga4(list(dim_filter("ga:countryIsoCode", "EXACT", "DE")),
                    operator = "AND"),
  anti_sample = TRUE
)

business_conversions <- google_analytics(
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


## PLOT DATA --------------------------

business_conversions %>%
  filter(countryIsoCode == "IT") %>%
  ggplot(aes(x = date, y = goal10Completions)) +
  geom_smooth(aes(linetype = countryIsoCode)) +
  geom_line(aes(linetype = countryIsoCode)) +
  geom_vline(xintercept = as.Date("2022-10-02"))

business_conversions %>% 
  mutate(D = as.factor(ifelse(date >= as.Date("2022-10-02"), 1, 0))) %>% 
  ggplot(aes(x = date, y = goal10Completions, color = D)) +
  geom_smooth(method = "lm")

business_conversions %>% 
  mutate(D = as.factor(ifelse(date >= as.Date("2022-10-02"), 1, 0))) %$% 
  lm(goal10Completions ~ D * I(date - as.Date("2022-10-02"))) %>% 
  summary()

## CAUSAL IMPACT ANALYSIS -------------

## CREATE WIDE DATASET
business_conversions_wide <- business_conversions %>%
  pivot_wider(id_cols = date,
              names_from = countryIsoCode,
              values_from = goal10Completions)

time.points <- seq.Date(as.Date("2021-01-01"), by = 1, length.out = 684)

data <- zoo(cbind(business_conversions_wide[[5]],
                  business_conversions_wide[[1]],
                  business_conversions_wide[[2]],
                  business_conversions_wide[[3]],
                  business_conversions_wide[[4]],
                  business_conversions_wide[[6]]),
            time.points)

pre.period <- as.Date(c("2021-01-01", "2022-10-01"))
post.period <- as.Date(c("2022-10-02", "2022-11-15"))

impact <- CausalImpact(data, pre.period, post.period)

impact$model$alpha
