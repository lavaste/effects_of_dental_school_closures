


#----------------------------------------------------------
# SETUP
#----------------------------------------------------------


# Fresh start
  rm(list=ls())
  gc()

#Packages
  # Quarto
    library(knitr)
  # File paths
    library(here)
  # Maps
    library(geofi)
  # Scale bar
    library(ggspatial)
  # Retrieve data from Statistics Finland
    library(pxweb)
  # Retreive data from Finnish Institute for Health and Welfare
    library(sotkanet)
  # Data manipulation
    library(tidyverse)
    library(janitor)
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
  # Themes
    library(ggthemes)
  # Fonts
    library(extrafont)
    library(fontcm)

# Retrieve date and username for folder naming
  tag <- paste0(format(Sys.Date(), "%Y-%m-%d"), "-", Sys.info()[["user"]])
  
# Create folders

  
  
  
  
  
  
  
  
  
  
  
  
