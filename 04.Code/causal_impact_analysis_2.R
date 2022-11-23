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

pre.period_2 <- as.Date(c("2021-01-01", "2022-05-15"))
post.period_2 <- as.Date(c("2022-05-16", "2022-11-15"))

impact_2 <- CausalImpact(data, pre.period_2, post.period_2)
