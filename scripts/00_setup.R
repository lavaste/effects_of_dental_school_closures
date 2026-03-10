


#----------------------------------------------------------
# SETUP
#----------------------------------------------------------


# Fresh start
  rm(list=ls())
  gc()

#Packages
  # Retrieve spatial data from Statistics Finland
    library(geofi)
  # Retrieve other data from Statistics Finland
    library(pxweb)
  # Retrieve data from Finnish Institute for Health and Welfare
    library(sotkanet)
  # Data manipulation
    library(tidyverse)
    library(janitor)
    library(data.table)
  # Spatial data
    library(sp)
    library(sf)
    library(raster)
  # Geocoding
    library(tidygeocoder)
  # Export/import data
    library(readxl)
    library(haven)
    library(foreign)
    library(Cairo)
  # Graph visuals
    library(ggthemes)
    library(ggnewscale)
    library(ggrepel)
    library(ggspatial)
  # Fonts
    library(extrafont)
      #extrafont::font_install("fontcm")    # Install Computer Modern font
      extrafont::loadfonts(quiet = TRUE)
  # Data scraping
    library(pdftools)
    library(stringr)

# Set seed
  set.seed(12345)
  
# Retrieve date and username for folder naming
  tag <- paste0(format(Sys.Date(), "%Y-%m-%d"), "-", Sys.info()[["user"]])
  
# Create folders
  # Data
    dir.create(here("data", tag, "raw"), recursive = TRUE, showWarnings = FALSE)
    dir.create(here("data", tag, "final"), recursive = TRUE, showWarnings = FALSE)
  # Output
    dir.create(here("output", tag), recursive = TRUE, showWarnings = FALSE)
    
# Institutional info
  # List of all dental schools
    schools <- c("Helsinki", "Turku", "Oulu", "Kuopio")
  # Closure timing: end of student intake
    closure_intake <- 1994
  # Closure timing: no more new graduates
    closure_output <- 1998
  # Re-opening timing: Turku
    # Student intake begins
      opening_intake_turku <- 2004
    # First students graduate
      opening_output_turku <- 2009
  # Re-opening timing: Kuopio
    # Student intake begins
      opening_intake_kuopio <- 2010
    # First students graduate
      opening_output_kuopio <- 2015
  
# Set uniform font family
  font <- "CM Roman"
  
# Uniform color scheme
  colors <- c("Helsinki" = "black",
              "Turku" = "gray30",
              "Oulu" = "gray50",
              "Kuopio" = "gray70")

