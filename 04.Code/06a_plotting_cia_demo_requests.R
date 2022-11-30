## PROJECT: Trustpilot Q4 2022 Causal Impact Analysis
## TITLE: Plotting Data
## AUTHOR(S): Henry Johnston-Ellis
## DATE: Wed Nov 30 09:56:07 2022

## NOTES:

## LOAD LIBRARIES ---------------------

library(tidyverse)
library(here)
library(zoo)
library(hjplottools)

## LOAD FONTS -------------------------

source(here("04.Code/99_font_specify.R"))

## LOAD DATA --------------------------

causal_impact_model_demo_requests_full <-
  readRDS(here("05.Output/models/cia_demo_requests_full.Rds"))

## CREATE PLOTTING DATA ---------------

## Create data frame from zoo series
causal_impact_1 <- as.data.frame(causal_impact_model_demo_requests_full$series)
causal_impact_1 <- cbind(time = time(causal_impact_model_demo_requests_full$series), causal_impact_1)

## Reshape data frame
tmp1 <- causal_impact_1 %>%
  dplyr::select(time, response, point.pred, point.pred.lower, point.pred.upper) %>%
  rename(mean = point.pred, lower = point.pred.lower, upper = point.pred.upper) %>%
  mutate(baseline = NA,
         metric = "Original")

tmp2 <- causal_impact_1 %>%
  dplyr::select(time, response, point.effect, point.effect.lower,
                point.effect.upper) %>%
  rename(mean = point.effect, lower = point.effect.lower, upper = point.effect.upper) %>%
  mutate(baseline = 0,
         metric = "Pointwise",
         response = NA)

tmp3 <- causal_impact_1 %>%
  dplyr::select(time, response, cum.effect, cum.effect.lower,
                cum.effect.upper) %>%
  rename(mean = cum.effect, lower = cum.effect.lower, upper = cum.effect.upper) %>%
  mutate(baseline = 0,
         metric = "Cumulative",
         response = NA)

data <- tmp1 %>%
  add_row(tmp2) %>%
  add_row(tmp3) %>%
  mutate(metric = as_factor(metric))

rownames(data) <- NULL

## CREATE PLOTTING FUNCTION -----------

plot_causal_impact <- function(data) {
  
  data %>%
    ggplot(aes(x = time)) +
    geom_ribbon(aes(ymin = lower, ymax = upper),
                fill = "grey", alpha = 0.4) +
    geom_vline(xintercept = as.Date("2022-10-02"),
               size = 0.8, linetype = "dashed") +
    geom_line(aes(y = baseline),
              colour = "darkgrey", size = 0.8, linetype = "solid", na.rm = T) +
    geom_line(aes(y = mean),
              size = 0.6, colour = "darkblue", linetype = "dashed", na.rm = T) +
    geom_line(aes(y = response), size = 0.6, na.rm = T) +
    scale_x_date(date_breaks = "3 month", date_labels = "%b %Y") +
    labs(x = "Date",
         y = "Demo Requests") +
    hj_theme()
  
}

## PLOT DATA --------------------------

## ALL PLOTS

full_model_all_panels_plot <-
  data %>%
  plot_causal_impact() +
  facet_grid(metric ~ ., scales = "free_y") +
  theme(text = element_text(size = 12, family = "Calibri"))

## ORIGINAL
full_model_original_plot <-
  data %>%
  filter(metric == "Original") %>%
  plot_causal_impact() +
  theme(text = element_text(size = 12, family = "Calibri"))

## POINTWISE
full_model_pointwise_plot <-
  data %>%
  filter(metric == "Pointwise") %>%
  plot_causal_impact() +
  theme(text = element_text(size = 12, family = "Calibri"))

## POINTWISE
full_model_cumulative_plot <-
  data %>%
  filter(metric == "Cumulative") %>%
  plot_causal_impact() +
  theme(text = element_text(size = 12, family = "Calibri"))

## SAVE PLOTS -------------------------

png(file = here("05.Output/figures/cia_demo_requests_full_all_panels.png"),
    width = 1200)
full_model_all_panels_plot
dev.off()

png(file = "05.Output/figures/cia_demo_requests_full_original.png",
    width = 1200)
full_model_original_plot
dev.off()

png(file = "05.Output/figures/cia_demo_requests_full_pointwise.png",
    width = 1200)
full_model_pointwise_plot
dev.off()

png(file = "05.Output/figures/cia_demo_requests_full_cumulative.png",
    width = 1200)
full_model_cumulative_plot
dev.off()
