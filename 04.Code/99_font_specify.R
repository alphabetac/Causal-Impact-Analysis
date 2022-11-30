## Install libraries
library(extrafont)
library(showtext)

## Load fonts
font_paths()
font_files()

## Add Agency font
font_add(family = "Garamond",
         regular = "Windows/Fonts/GARA.TTF",
         bold = "Windows/Fonts/GARABD.TTF")

## Add Calibri
font_add(family = "Calibri",
         regular = "Windows/Fonts/calibri.ttf",
         bold = "Windows/Fonts/calibrib.ttf")

## See families
font_families()

## Enable
showtext_auto()

