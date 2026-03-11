# The Effects of Supply on Medical Labor Markets: Evidence from Dental
School Closures in Finland
Mikko Herzig (University of Turku), Konsta Lavaste (Finnish Institute
for Health and Welfare), Allan Seuri (University of Tampere)

Version: 2026-03-11

## Preliminaries

First, let’s load the setup and functions into memory.

``` r
# Load here package for relative file paths
  library(here)

# Run setup script
  source(here("scripts", "00_setup.R"))

# Load functions
  source(here("scripts", "00_functions.R"))
```

Second, let’s check which version of R we are using.

R version: 4.5.2

## Map

In this section we create map of Finland which includes:

1.  locations of dental schools
2.  commuting zones

``` r
# Which year's commuting zones we want to use (2013 is the earliest available)
  commutingzones_year <- 2013

# Run the script
  source(here("scripts", "01_map.R"))
```

    Requesting response from: http://geo.stat.fi/geoserver/wfs?service=WFS&version=1.0.0&request=getFeature&typename=tilastointialueet%3Akunta1000k_2013

    Warning: Coercing CRS to epsg:3067 (ETRS89 / TM35FIN)

    Data is licensed under: Attribution 4.0 International (CC BY 4.0)

    Passing 4 addresses to the Nominatim single address geocoder

    Query completed in: 4.2 seconds

![](master_report_files/figure-commonmark/map-1.png)

## Timeline

In this section, we draw a graph which depicts the timeline of the
closures and re-openings.

``` r
# Which year we set as the first and the last year of the timeline
  timeline_year_begin <- 1990
  timeline_year_end <- 2020

# Run the script
  source(here("scripts", "02_timeline.R"))
```

![](master_report_files/figure-commonmark/timeline-1.png)

## Student intake

In this section, we draw a graph which shows how the dental student
intake has evolved over the years by school.

``` r
# Which year we set as the first and the last year of the timeline
  intake_year_begin <- 1990
  intake_year_end <- 2020

# Run the script
  source(here("scripts", "03_student_intake.R"))
```

![](master_report_files/figure-commonmark/intake-1.png)
