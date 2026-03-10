


#----------------------------------------------------------
# SCRAPE THE STUDENT INTAKE DATA FROM THE PDF
#----------------------------------------------------------


# Define the URL
  student_intake_url <- paste0(
    "https://www.hammaslaakariliitto.fi/sites/default/files/2025-03/Hammasl%C3%A4%C3%A4k%C3%A4rikoulutukseen%20haeneet%2C%20hyv%C3%A4ksytyt%20ja%20laillistetut%2C%20p%C3%A4ivitetty%204.3.2025.pdf"
  )
  
# Download the whole file for reference
  download.file(student_intake_url, destfile = here("data", tag, "raw", "student_intake.pdf"), mode = "wb", quiet = TRUE)
  
# Download the text
  raw_text   <- pdf_text(student_intake_url)
  
# Separate into lines
  raw_text  <- unlist(strsplit(raw_text, "\n"))
  
# Remove whitespace
  raw_text  <- str_trim(raw_text)

# Keep only lines that start with a 4-digit year (1990–2099)
  raw_text <- raw_text[grepl("^(19|20)\\d{2}\\b", raw_text)]

  
# ----------------------------------------------------------
# CREATE A FUNCTION TO PARSE ROWS
#
#  Verified university presence by x-position mapping in the PDF:
#    1990–1993 : Helsinki, Itä-Suomi, Oulu, Turku  (4 unis, no yht printed)
#    1994–2003 : Helsinki, Oulu                     (2 unis; Itä-Suomi & Turku = NA)
#    2004–2009 : Helsinki, Oulu, Turku              (3 unis; Itä-Suomi = NA)
#    2010+     : Helsinki, Itä-Suomi, Oulu, Turku  (4 unis)
#
#  Token counts per row (excl. year):
#    1990–1993 : 8 or 10  (4+4 unis, yht sometimes missing from source)
#    1994–2003 : 4–6      (2+2 unis + optional yht cols)
#    2004–2009 : 7–9      (3+3 unis + optional yht cols)
#    2010+     : 10–12    (4+4 unis + yht cols)
#
#  Strategy: use year ranges to determine which universities are present,
#  then slice tokens into the correct named slots.
# ----------------------------------------------------------
  
# Create a function  
  parse_row <- function(line) {
    
    # Define objects
      tokens <- as.integer(unlist(str_split(str_trim(line), "\\s+")))
      vuosi  <- tokens[1]
      vals   <- tokens[-1]
      n      <- length(vals)
  
    # Determine how many university columns are present per group
      if (vuosi <= 1993) {
        uni_names <- c("helsinki", "ita_suomi", "oulu", "turku")
        hak_n <- 4; hyv_n <- 4
      } else if (vuosi <= 2003) {
        uni_names <- c("helsinki", "oulu")          # Itä-Suomi & Turku absent
        hak_n <- 2; hyv_n <- 2
      } else if (vuosi <= 2009) {
        uni_names <- c("helsinki", "oulu", "turku") # Itä-Suomi absent
        hak_n <- 3; hyv_n <- 3
      } else {
        uni_names <- c("helsinki", "ita_suomi", "oulu", "turku")
        hak_n <- 4; hyv_n <- 4
      }
  
    # Slice tokens: [hak unis | hak_yht | hyv unis | hyv_yht | lail...]
      hak_unis <- vals[seq_len(hak_n)]
      hak_yht  <- vals[hak_n + 1]
      hyv_unis <- vals[seq(hak_n + 2, hak_n + 1 + hyv_n)]
      hyv_yht  <- vals[hak_n + 2 + hyv_n]
  
    # Place uni values into named slots; absent universities become NA
      all_unis <- c("helsinki", "ita_suomi", "oulu", "turku")
      hak_vals <- setNames(as.list(rep(NA_integer_, 4)), paste0("hak_", all_unis))
      hyv_vals <- setNames(as.list(rep(NA_integer_, 4)), paste0("hyv_", all_unis))
      for (i in seq_along(uni_names)) {
        hak_vals[[paste0("hak_", uni_names[i])]] <- hak_unis[i]
        hyv_vals[[paste0("hyv_", uni_names[i])]] <- hyv_unis[i]
      }
  
    # Construct the table
      data.table(
        year         = vuosi,
        applied_helsinki  = hak_vals$hak_helsinki,
        applied_kuopio = hak_vals$hak_ita_suomi,
        applied_oulu      = hak_vals$hak_oulu,
        applied_turku     = hak_vals$hak_turku,
        applied_total       = hak_yht,
        accepted_helsinki  = hyv_vals$hyv_helsinki,
        accepted_kuopio = hyv_vals$hyv_ita_suomi,
        accepted_oulu      = hyv_vals$hyv_oulu,
        accepted_turku     = hyv_vals$hyv_turku,
        accepted_total       = hyv_yht
      )

  }


# ----------------------------------------------------------
# BUILD AND SAVE THE TABLE
# ----------------------------------------------------------
  

# Create the table by using the parse_row function to the raw text
  student_intake <- rbindlist(lapply(raw_text, parse_row))
  
# Save
  save(student_intake, file = here("data", tag, "raw", "student_intake.RData"))

  
  
# ----------------------------------------------------------
# CLEAN UP THE DATA
# ----------------------------------------------------------

  
# Replace all NAs with zeros
  student_intake[is.na(student_intake)] <- 0
  
# Restrict the data as determined
  student_intake <- student_intake %>%
    subset(year >= intake_year_begin & year <= intake_year_end)

  
# ----------------------------------------------------------
# DRAW THE GRAPH
# ----------------------------------------------------------


# Draw the graph
  student_intake_graph <- ggplot(data = student_intake, aes(x = year)) +
      # Helsinki
        geom_line(aes(y = accepted_helsinki, color = "Helsinki"), linewidth = 1) +
        geom_point(aes(y = accepted_helsinki, color = "Helsinki"), size = 3, shape = 15) +
      # Turku
        geom_line(aes(y = accepted_turku, color = "Turku"), linewidth = 1) +
        geom_point(aes(y = accepted_turku, color = "Turku"), size = 3, shape = 16) +
      # Oulu
        geom_line(aes(y = accepted_oulu, color = "Oulu"), linewidth = 1) +
        geom_point(aes(y = accepted_oulu, color = "Oulu"), size = 3, shape = 17) +
      # Kuopio
        geom_line(aes(y = accepted_kuopio, color = "Kuopio"), linewidth = 1) +
        geom_point(aes(y = accepted_kuopio, color = "Kuopio"), size = 3, shape = 18) +
      # Visual settings
        timanttinen_teema(base_size = 18,
                          legend_orientation = "horizontal",
                          legend_rows = 1,
                          legend_columns = 4) +
        scale_color_manual(values = colors,
                           breaks = schools) +
      # Font
        theme(text = element_text(family = font)) +
      # Axes
        scale_y_continuous(limits = c(0, 60),
                           breaks = seq(0, 60, by = 10),
                           labels=scales::comma
                           ) +
        scale_x_continuous(limits = c(intake_year_begin, intake_year_end),
                           labels = seq(intake_year_begin, intake_year_end, by = 2),
                           breaks = seq(intake_year_begin, intake_year_end, by = 2)
                           ) +
      # Titles
        labs(y = "Persons")

# Print the graph
  print(student_intake_graph)
  
# Save the graph
  ggsave(here("output", tag, "student_intake.pdf"), student_intake_graph, width = 190, height = 130, units = "mm", device="pdf", dpi=300)

# Drop temporary columns
  rm(list = ls()[startsWith(ls(), "student_intake")], raw_text, parse_row)
  gc()

