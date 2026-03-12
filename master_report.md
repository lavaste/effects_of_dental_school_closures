# The Effects of Supply on Medical Labor Markets
Mikko Herzig (University of Turku), Konsta Lavaste (Finnish Institute
for Health and Welfare), Allan Seuri (University of Tampere)

Version: 2026-03-12

## Preliminaries

Let’s begin by loading the setup and custom functions into memory.

``` r
# Load here package for relative file paths
  library(here)

# Run setup script
  source(here("scripts", "00_setup.R"))

# Load functions
  source(here("scripts", "00_functions.R"))
```

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

    Query completed in: 4.1 seconds

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

## Dentist unemployment and vacancies

In this section, we draw a graph which shows how the dentist
unemployment and the number of dentist vacancies has evolved over time.

``` r
# Which year we set as the first and the last year of the graph
  unemployment_year_begin <- 1990
  unemployment_year_end <- 2020

# Run the script
  source(here("scripts", "04_unemployment.R"))
```

## Dental care use and expenditures

To be added.

------------------------------------------------------------------------

# Package bibliography

``` r
cite_packages(output = "table", out.dir = ".", cite.tidyverse = TRUE)
```

        Package Version                                       Citation

1 base 4.5.2 R Core Team (2025b) 2 Cairo 1.7.0 Urbanek and Horner (2025)
3 data.table 1.17.8 Barrett et al. (2025) 4 extrafont 0.20 Chang (2025)
5 foreign 0.8.90 R Core Team (2025a) 6 geofi 1.1.0 Kainu et al. (2025) 7
ggnewscale 0.5.2 Campitelli (2025) 8 ggrepel 0.9.7 Slowikowski (2026) 9
ggspatial 1.1.10 Dunnington (2025) 10 ggthemes 5.2.0 Arnold (2025) 11
grid 4.5.2 R Core Team (2025c) 12 here 1.0.2 Müller (2025) 13 janitor
2.2.1 Firke (2024) 14 pdftools 3.6.0 Ooms (2025) 15 pxweb 0.17.0
Magnusson et al. (2019) 16 raster 3.6.32 Hijmans (2025) 17 renv 1.1.8
Ushey and Wickham (2026) 18 rmarkdown 2.30 Xie, Allaire, and Grolemund
(2018); Xie, Dervieux, and Riederer (2020); Allaire et al. (2025) 19
scales 1.4.0 Wickham, Pedersen, and Seidel (2025) 20 sf 1.0.24 E.
Pebesma (2018); E. Pebesma and Bivand (2023) 21 sotkanet 0.10.1 Lahti et
al. (2024) 22 sp 2.2.0 E. J. Pebesma and Bivand (2005); Bivand, Pebesma,
and Gomez-Rubio (2013) 23 tidygeocoder 1.0.6 Cambon et al. (2021) 24
tidyverse 2.0.0 Wickham et al. (2019)

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-rmarkdown2025" class="csl-entry">

Allaire, JJ, Yihui Xie, Christophe Dervieux, Jonathan McPherson, Javier
Luraschi, Kevin Ushey, Aron Atkins, et al. 2025.
*<span class="nocase">rmarkdown</span>: Dynamic Documents for r*.
<https://github.com/rstudio/rmarkdown>.

</div>

<div id="ref-ggthemes" class="csl-entry">

Arnold, Jeffrey B. 2025. *<span class="nocase">ggthemes</span>: Extra
Themes, Scales and Geoms for “<span class="nocase">ggplot2</span>”*.
<https://doi.org/10.32614/CRAN.package.ggthemes>.

</div>

<div id="ref-datatable" class="csl-entry">

Barrett, Tyson, Matt Dowle, Arun Srinivasan, Jan Gorecki, Michael
Chirico, Toby Hocking, Benjamin Schwendinger, and Ivan Krylov. 2025.
*<span class="nocase">data.table</span>: Extension of
“<span class="nocase">data.frame</span>”*.
<https://doi.org/10.32614/CRAN.package.data.table>.

</div>

<div id="ref-sp2013" class="csl-entry">

Bivand, Roger S., Edzer Pebesma, and Virgilio Gomez-Rubio. 2013.
*Applied Spatial Data Analysis with R, Second Edition*. Springer, NY.
<https://asdar-book.org/>.

</div>

<div id="ref-tidygeocoder" class="csl-entry">

Cambon, Jesse, Diego Hernangómez, Christopher Belanger, and Daniel
Possenriede. 2021. “<span class="nocase">tidygeocoder</span>: An r
Package for Geocoding.” *Journal of Open Source Software* 6 (65): 3544.
<https://doi.org/10.21105/joss.03544>.

</div>

<div id="ref-ggnewscale" class="csl-entry">

Campitelli, Elio. 2025. *<span class="nocase">ggnewscale</span>:
Multiple Fill and Colour Scales in
“<span class="nocase">ggplot2</span>”*.
<https://doi.org/10.32614/CRAN.package.ggnewscale>.

</div>

<div id="ref-extrafont" class="csl-entry">

Chang, Winston. 2025. *<span class="nocase">extrafont</span>: Tools for
Using Fonts*. <https://doi.org/10.32614/CRAN.package.extrafont>.

</div>

<div id="ref-ggspatial" class="csl-entry">

Dunnington, Dewey. 2025. *<span class="nocase">ggspatial</span>: Spatial
Data Framework for Ggplot2*.
<https://doi.org/10.32614/CRAN.package.ggspatial>.

</div>

<div id="ref-janitor" class="csl-entry">

Firke, Sam. 2024. *<span class="nocase">janitor</span>: Simple Tools for
Examining and Cleaning Dirty Data*.
<https://doi.org/10.32614/CRAN.package.janitor>.

</div>

<div id="ref-raster" class="csl-entry">

Hijmans, Robert J. 2025. *<span class="nocase">raster</span>: Geographic
Data Analysis and Modeling*.
<https://doi.org/10.32614/CRAN.package.raster>.

</div>

<div id="ref-geofi" class="csl-entry">

Kainu, Markus, Joona Lehtomaki, Juuso Parkkinen, Jani Miettinen, Pyry
Kantanen, Sampo Vesanen, and Leo Lahti. 2025.
*<span class="nocase">geofi: Access Finnish Geospatial Data</span>*
(version 1.1.0). <https://doi.org/10.32614/CRAN.package.geofi>.

</div>

<div id="ref-sotkanet" class="csl-entry">

Lahti, Leo, Einari Happonen, Joona Lehtomäki, Juuso Parkkinen, Joona
Lehtomaki, Vesa Saaristo, Pyry Kantanen, and Aleksi Lahtinen. 2024.
“<span class="nocase">sotkanet</span>: Sotkanet Open Data Access and
Analysis.” <https://github.com/rOpenGov/sotkanet>.

</div>

<div id="ref-pxweb" class="csl-entry">

Magnusson, Mans, Markus Kainu, Janne Huovari, and Leo Lahti. 2019.
“<span class="nocase">pxweb</span>: R Tools for PX-WEB API.”

</div>

<div id="ref-here" class="csl-entry">

Müller, Kirill. 2025. *<span class="nocase">here</span>: A Simpler Way
to Find Your Files*. <https://doi.org/10.32614/CRAN.package.here>.

</div>

<div id="ref-pdftools" class="csl-entry">

Ooms, Jeroen. 2025. *<span class="nocase">pdftools</span>: Text
Extraction, Rendering and Converting of PDF Documents*.
<https://doi.org/10.32614/CRAN.package.pdftools>.

</div>

<div id="ref-sf2018" class="csl-entry">

Pebesma, Edzer. 2018. “<span class="nocase">Simple Features for R:
Standardized Support for Spatial Vector Data</span>.” *The R Journal* 10
(1): 439–46. <https://doi.org/10.32614/RJ-2018-009>.

</div>

<div id="ref-sp2005" class="csl-entry">

Pebesma, Edzer J., and Roger Bivand. 2005. “Classes and Methods for
Spatial Data in R.” *R News* 5 (2): 9–13.
<https://CRAN.R-project.org/doc/Rnews/>.

</div>

<div id="ref-sf2023" class="csl-entry">

Pebesma, Edzer, and Roger Bivand. 2023. *<span class="nocase">Spatial
Data Science: With applications in R</span>*. Chapman and Hall/CRC.
<https://doi.org/10.1201/9780429459016>.

</div>

<div id="ref-foreign" class="csl-entry">

R Core Team. 2025a. *<span class="nocase">foreign</span>: Read Data
Stored by “Minitab,” “S,” “SAS,” “SPSS,” “Stata,” “Systat,” “Weka,”
“<span class="nocase">dBase</span>,” ...*
<https://doi.org/10.32614/CRAN.package.foreign>.

</div>

<div id="ref-base" class="csl-entry">

———. 2025b. *R: A Language and Environment for Statistical Computing*.
Vienna, Austria: R Foundation for Statistical Computing.
<https://www.R-project.org/>.

</div>

<div id="ref-grid" class="csl-entry">

———. 2025c. *R: A Language and Environment for Statistical Computing*.
Vienna, Austria: R Foundation for Statistical Computing.
<https://www.R-project.org/>.

</div>

<div id="ref-ggrepel" class="csl-entry">

Slowikowski, Kamil. 2026. *<span class="nocase">ggrepel</span>:
Automatically Position Non-Overlapping Text Labels with
“<span class="nocase">ggplot2</span>”*.
<https://doi.org/10.32614/CRAN.package.ggrepel>.

</div>

<div id="ref-Cairo" class="csl-entry">

Urbanek, Simon, and Jeffrey Horner. 2025. *Cairo: R Graphics Device
Using Cairo Graphics Library for Creating High-Quality Bitmap (PNG,
JPEG, TIFF), Vector (PDF, SVG, PostScript) and Display (X11 and Win32)
Output*. <https://doi.org/10.32614/CRAN.package.Cairo>.

</div>

<div id="ref-renv" class="csl-entry">

Ushey, Kevin, and Hadley Wickham. 2026.
*<span class="nocase">renv</span>: Project Environments*.
<https://doi.org/10.32614/CRAN.package.renv>.

</div>

<div id="ref-tidyverse" class="csl-entry">

Wickham, Hadley, Mara Averick, Jennifer Bryan, Winston Chang, Lucy
D’Agostino McGowan, Romain François, Garrett Grolemund, et al. 2019.
“Welcome to the <span class="nocase">tidyverse</span>.” *Journal of Open
Source Software* 4 (43): 1686. <https://doi.org/10.21105/joss.01686>.

</div>

<div id="ref-scales" class="csl-entry">

Wickham, Hadley, Thomas Lin Pedersen, and Dana Seidel. 2025.
*<span class="nocase">scales</span>: Scale Functions for Visualization*.
<https://doi.org/10.32614/CRAN.package.scales>.

</div>

<div id="ref-rmarkdown2018" class="csl-entry">

Xie, Yihui, J. J. Allaire, and Garrett Grolemund. 2018. *R Markdown: The
Definitive Guide*. Boca Raton, Florida: Chapman; Hall/CRC.
<https://bookdown.org/yihui/rmarkdown>.

</div>

<div id="ref-rmarkdown2020" class="csl-entry">

Xie, Yihui, Christophe Dervieux, and Emily Riederer. 2020. *R Markdown
Cookbook*. Boca Raton, Florida: Chapman; Hall/CRC.
<https://bookdown.org/yihui/rmarkdown-cookbook>.

</div>

</div>
