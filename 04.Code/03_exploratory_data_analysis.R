## PROJECT: Trustpilot Q4 2022 Causal Impact Analysis
## TITLE: Exploratory Data Analysis
## AUTHOR(S): Henry Johnston-Ellis
## DATE: Thu Nov 17 15:28:44 2022

## NOTES:

## SET CREDENTIALS --------------------

## LOAD LIBRARIES ---------------------

library(here)
library(tidyverse)
library(hjplottools)
library(zoo)

## LOAD DATA --------------------------

business_demo_requests_long <-
  read_csv(here("03.Data/raw/business_demo_requests_2021_2022.csv"))

business_free_signups_long <-
  read_csv(here("03.Data/raw/business_free_signups_2021_2022.csv"))

business_users_long <-
  read_csv(here("03.Data/raw/business_users_2021_2022.csv"))

business_demo_requests <-
  read_csv(here("03.Data/interim/business_demo_requests_2021_2022.csv")) %>%
  filter(date <= as.Date("2022-11-13"))

business_free_signups <-
  read_csv(here("03.Data/interim/business_free_signups_2021_2022.csv")) %>%
  filter(date <= as.Date("2022-11-13"))

business_users_wide <-
  read_csv(here("03.Data/interim/business_users_2021_2022.csv"))

## SET CAMPAIGN DATES -----------------

campaign_start_date <- as.Date("2022-10-02")
campaign_end_date <- as.Date("2022-11-13")

## PLOT DATA --------------------------

## Distribution of conversions
business_demo_requests_long %>%
  ggplot(aes(x = goal10Completions, fill = countryIsoCode, colour = countryIsoCode)) +
  geom_histogram(aes(y = ..density..),
                 binwidth = 1) +
    geom_density(alpha = .2) +
  facet_wrap(~countryIsoCode)

## Time series
demo_requests_time_series <- business_demo_requests_long %>%
  filter(date <= as.Date("2022-10-01")) %>%
  ggplot(aes(x = date, y = goal10Completions)) +
  geom_smooth(aes(linetype = countryIsoCode,
                  colour = countryIsoCode),
              method = 'gam',
              se = F) +
  geom_vline(aes(xintercept = as.Date("2022-10-02"))) +
  labs(x = "\nDate\n",
       y = "Demo Requests\n",
       linetype = "Country (Iso Code)",
       colour = "Country (Iso Code)") +
  hj_theme()

free_signups_time_series <- business_free_signups_long %>%
  filter(date <= as.Date("2022-10-01")) %>%
  ggplot(aes(x = date, y = goal6Completions)) +
  geom_smooth(aes(linetype = countryIsoCode,
                  colour = countryIsoCode),
              method = 'gam',
              se = F) +
  geom_vline(aes(xintercept = as.Date("2022-10-02"))) +
  labs(x = "\nDate\n",
       y = "Free Sign-ups\n",
       linetype = "Country (Iso Code)",
       colour = "Country (Iso Code)") +
  hj_theme()

## Time series
business_conversions_long %>%
  filter(date <= campaign_end_date) %>%
  mutate(D = as.factor(ifelse(date >= campaign_start_date, 1, 0))) %>%
  ggplot(aes(x = date, y = goal10Completions, colour = D)) +
  geom_smooth(aes(linetype = countryIsoCode),
              method = 'lm',
              se = F) +
  hj_theme() +
  facet_wrap(~countryIsoCode)

## Time series of free signups
business_free_signups_long %>%
  filter(date <= campaign_end_date) %>%
  ggplot(aes(x = date, y = goal6Completions)) +
  geom_smooth(aes(linetype = countryIsoCode),
              method = 'gam',
              se = F) +
  hj_theme()

## CORRELATIONS -----------------------


## SAVE PLOTS -------------------------

png(file = here("05.Output/figures/demo_requests_time_series.png"),
    width = 1200)
demo_requests_time_series
dev.off()

png(file = here("05.Output/figures/free_signups_time_series.png"),
    width = 1200)
free_signups_time_series
dev.off()