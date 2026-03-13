# The Effects of Supply on Medical Labor Markets: Evidence from Dental School Closures in Finland

**Authors**: Mikko Herzig, [Konsta Lavaste](https://github.com/lavaste) & Allan Seuri

**Description**: This repository includes scripts for the research paper, which studies the effects of dental school closures in Finland. Most of the analysis is performed with confidential data and within Statistics Finland's remote access system Fiona and, hence, the scripts are not stored in this public repository. Instead, this repository includes scripts that create those graphs and maps which are based on open source data. Essentially this means information on institutional details.

## Repository structure

**Main file**: The figures are produced running quarto file `master_report.qmd` from the main folder.

**Scripts**: Master report calls for R scripts which are stored in `scripts` folder.

## Output

The quarto file produces:

- Markdown report (`master_report.md`) with all the figures.
- Figures as standalone pdfs in folder called `output`. For version control's sake, the output folder has subfolders named after the run date and username.

Raw and processed data are saved in `data` folder in which the subfolders are also named after the run date and username.

### 1) Map of Finland with dental school locations and commuting zones

**Script**: `scripts/01_map.R`

**Based on**: Spatial data from [Statistics Finland](https://stat.fi/en/services/statistical-data-services/geographic-data) and coordinates of cities from [OpenStreetMap](https://www.openstreetmap.org/).

### 2) Graph visualising the timeline of dental school closures and re-openings

**Script**: `scripts/02_timeline.R`

**Based on**: Closure and re-opening years from open sources

 - Kuopio: [government decree 488/1994](https://www.finlex.fi/fi/lainsaadanto/saadoskokoelma/1994/488), [law amendment 379/1994](https://www.finlex.fi/fi/lainsaadanto/saadoskokoelma/1994/379), [government proposal 323/1993](https://www.finlex.fi/fi/hallituksen-esitykset/1993/323)
 - Turku: [government decree 488/1994](https://www.finlex.fi/fi/lainsaadanto/saadoskokoelma/1994/488)

### 3) Graph depicting the evolution of dental student intake by dental schools over time

**Script**: `scripts/03_student_intake.R`

**Based on**: Dental school student intake statistics from the [Finnish Dental Association](https://www.hammaslaakariliitto.fi/sites/default/files/2025-03/Hammasl%C3%A4%C3%A4k%C3%A4rikoulutukseen%20haeneet%2C%20hyv%C3%A4ksytyt%20ja%20laillistetut%2C%20p%C3%A4ivitetty%204.3.2025.pdf) ([archived](https://web.archive.org/web/20260310073907/https://www.hammaslaakariliitto.fi/sites/default/files/2025-03/Hammasl%C3%A4%C3%A4k%C3%A4rikoulutukseen%20haeneet%2C%20hyv%C3%A4ksytyt%20ja%20laillistetut%2C%20p%C3%A4ivitetty%204.3.2025.pdf)).

### 4) Graph depicting dentist jobseekers and dentist vacancies over time

**Script**: `scripts/04_jobseekers_vacancies.R`

**Based on**: Unemployed jobseekers and vacancies by occupation from [Statistics Finland](https://pxdata.stat.fi/PxWeb/pxweb/en/StatFin/StatFin__tyonv/statfin_tyonv_pxt_12ti.px/)

## Replication

If you want to reproduce *exactly* the same graphs, you

1. Clone the repository
2. Install renv: `install.packages("renv")`
3. Restore the packages: `renv::restore()`
4. Run the master script from `master_report.qmd`
