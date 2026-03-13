
#----------------------------------------------------------
# DOWNLOAD THE JOBSEEKER AND VACANCY DATA
#----------------------------------------------------------


# Define API URL
  url <- "https://pxdata.stat.fi/PxWeb/API/v1/en/StatFin/statfin_tyonv_pxt_12ti.px/"

# Define the query
  query <- list("Tiedot" = c("*"),
              "Alue" = c("SSS"),                  # SSS = Whole country
              "Ammattiryhmä" = c("2261"),         # 2261 = Denstist
              "Kuukausi" = c("*")
               )

# Download the data
  jobseekers_vacancies <- pxweb_get(url = url,
                       query = query)
  
# Transform to data.table
  jobseekers_vacancies <- as_tibble(as.data.frame(jobseekers_vacancies,
                                  column.name.type = "text",
                                  variable.value.type = "text")
                    )

# Clean up
  jobseekers_vacancies <- jobseekers_vacancies %>%
    # Rename
      rename(jobseekers = `Unemployed jobseekers on calculation date (number)`) %>%
      rename(vacancies = `Vacancies on end-of-month calculation date (number)`) %>%
      rename(month = `Month`) %>%
    # Better disply format for month
      mutate(month = as.Date(paste0(sub("M", "-", month), "-01"), format = "%Y-%m-%d"),
             jobseekers = as.numeric(jobseekers),
             vacancies = as.numeric(vacancies)
             ) %>%
    # Drop columns
      dplyr::select(month, jobseekers, vacancies) %>%
    # Focus on the time period we have specified
      filter(month <= as.Date(paste0(jobseekers_year_end, "-12-01")) & month >= as.Date(paste0(jobseekers_year_begin, "-01-01")))



# ----------------------------------------------------------
# DRAW THE GRAPH
# ----------------------------------------------------------


# Draw the graph
  jobseekers_vacancies_graph <- ggplot(data = jobseekers_vacancies, aes(x = month)) +
      # Jobseekers
        geom_line(aes(y = jobseekers, color = "Jobseekers"), linewidth = 1) +
        #geom_point(aes(y = jobseekers, color = "Jobseekers"), size = 3, shape = 15) +
      # Vacancies
        geom_line(aes(y = vacancies, color = "Vacancies"), linewidth = 1) +
        #geom_point(aes(y = vacancies, color = "Vacancies"), size = 3, shape = 16) +
      # Visual settings
        timanttinen_teema(base_size = 18,
                          legend_orientation = "horizontal",
                          legend_rows = 1,
                          legend_columns = 4) +
        scale_color_manual(values = c("Jobseekers" = "black", "Vacancies" = "gray70")) +
      # Legend
          theme(text = element_text(family = font),                                   # Font
            legend.spacing.y = unit(.1, 'cm'),
            legend.text=element_text(size = 18, margin = margin(t = 10, b = 10)),
            legend.key.size = unit(.5, "cm"),
            legend.key.height = unit(.5, "cm"),
            legend.key.width = unit(1.5, "cm"),
            ) +
      # Font
        theme(text = element_text(family = font)) +
      # Axes
        scale_y_continuous(limits = c(0, 350),
                           breaks = seq(0, 350, by = 50),
                           labels = scales::comma
                           ) +
        scale_x_date(date_breaks = "1 year",
                     date_labels = "%Y/%m",
                     limits = as.Date(c(paste0(jobseekers_year_begin, "-01-01"), paste0(jobseekers_year_end, "-12-01"))),
                     expand = c(0, 0)
                     ) +
        labs(y = "Number")

# Print the graph
  print(jobseekers_vacancies_graph)
  
# Save the graph
  ggsave(here("output", tag, "jobseekers_vacancies_graph.pdf"), jobseekers_vacancies_graph, width = 190, height = 130, units = "mm", device="pdf", dpi=300)

# Drop temporary columns
  rm(list = ls()[startsWith(ls(), "jobseekers")], url, query)
  gc()

