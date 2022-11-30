## PROJECT: Trustpilot Q4 2022 Causal Impact Analysis
## TITLE: Testing Facebook GeoLift
## AUTHOR(S): Henry Johnston-Ellis
## DATE: Thu Nov 24 10:01:38 2022

## NOTES:

## SET CREDENTIALS --------------------

## LOAD LIBRARIES ---------------------

library(tidyverse)
library(here)
library(GeoLift)

## LOAD DATA --------------------------

business_conversions_long <-
  read_csv(here("03.Data/raw/business_conversions_2021_2022")) %>%
  filter(date <= as.Date("2022-11-13"))

## READ DATA --------------------------

business_conversions_geo_data <- GeoDataRead(
  data = business_conversions_long,
  date_id = "date",
  location_id = "countryIsoCode",
  Y_id = "goal10Completions",
  format = "yyyy-mm-dd",
  summary = TRUE
)

## USE GeoPlot() FUNCTION -------------

GeoPlot(business_conversions_geo_data,
        Y_id = "Y",
        time_id = "time",
        location_id = "location")

## SELECT MARKETS ---------------------

GeoTest <- GeoLift(data = business_conversions_geo_data,
                   locations = c("it"),
                   treatment_start_time = lubridate::yday("2021-12-31") +
                     lubridate::yday(campaign_start_date),
                   treatment_end_time = lubridate::yday("2021-12-31") +
                     lubridate::yday(campaign_end_date))


