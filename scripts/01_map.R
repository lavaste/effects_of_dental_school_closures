
  

############################################




#----------------------------------------------------------
# FIND COMMUTING ZONES
#----------------------------------------------------------



# Prior to 2000
  if (commutingzones_year < 2000 ) {
    stop("Not possible. Commuting zones and municipality shapefiles available from year 2000 onwards.")
  }

# 2000-2012:
  if (commutingzones_year >= 2000 & commutingzones_year <= 2012 ) {

    # Define the URL for municipality-commuting zone key
      url <- paste0("https://api.stat.fi/classificationservice/open/api/classifications/v2/correspondenceTables/kunta_1_", commutingzones_year, "0101%23tyossakayntial_1_", commutingzones_year, "0101/maps?content=data&meta=min&lang=fi")

    # Download the key
      response <- GET(url)
      key <- fromJSON(content(response, as = "text", encoding = "UTF-8"), flatten = TRUE)

    # Clean up
      key <- key %>%
        # Extract municipality ID and commuting zone ID
          mutate(
            kunta = as.numeric(sub(".*/", "", sourceLocalId)),
            tyossakayntial_code = as.numeric(sub(".*/", "", targetLocalId))
          ) %>%
        # Drop other columns
          dplyr::select(kunta, tyossakayntial_code)

    # Import the spatial data
      year_suffix <- substr(commutingzones_year, 3, 4)
      municipalities <- suppressMessages(
                          st_read(here("data", "shapefiles", paste0("ku100_", commutingzones_year), paste0("ku100_", year_suffix, "_p.shp")),
                                  quiet = TRUE)
                          )
      # Check visually
        #ggplot(municipalities) + geom_sf()
        
    # Clean up
      municipalities <- municipalities %>%
      # Drop vars
        dplyr::select(CODE, geometry) %>%
      # Rename
        rename(kunta = CODE) %>%
        rename(geom = geometry)
      # Drop Åland
        aland_IDs <- c(478, 35, 318, 736, 76, 417, 62, 170, 941, 60, 43, 65, 438, 766, 771, 295)
        municipalities <- municipalities %>%
          filter(!kunta %in% aland_IDs)

    # Download map of 2013 (first year without sea areas)
      municipalities_2013 <- suppressMessages(get_municipalities(year = 2013,
                                                                 scale = 1000)
                                             )

    #Create union of all municipalities in 2013
      union_2013 <- st_union(municipalities_2013)

    # Harmonize the coordinate systems
      municipalities <- st_transform(municipalities, st_crs(union_2013))

    #Keep only the intersection of the 2013 and the desired year, i.e. remove sea areas
      municipalities_intersection <- st_intersection(municipalities, union_2013)
      #Check visually
        #ggplot(municipalities_intersection) + geom_sf()
      
    # Add the municipality-commuting zone key
      commuting_zones <- left_join(municipalities_intersection, key, by = "kunta")

    # Add indicators
      commuting_zones <- commuting_zones %>%
        # Indicator for areas outside commuting zones areas (ID=0)
          mutate(outside_commutingzones = ifelse(tyossakayntial_code==0, 1, 0)) %>%
        # Indicator for the municipalities where the closed schools located Kuopio (297) and Turku (853)
          mutate(temp = ifelse(kunta == 297 |          # Kuopio municipal ID = 297
                               kunta == 853,            # Turku municipal ID = 853
                               1,
                               0
                               )
          ) %>%
        # Indicator for all municipalities which were located in the same commuting zones as Turku and Kuopio
          group_by(tyossakayntial_code) %>%
          mutate(kuopioturku = max(temp)) %>%
          ungroup() %>%
        # Drop the temporary column
          dplyr::select(-temp)

    # Remove temporary tables
      rm(list = ls()[startsWith(ls(), "municipalities")], union_2013, url, key, response, aland_IDs, year_suffix)

  }

# 2013 or later
  if (commutingzones_year >= 2013 ) {

    # Download the data
        commuting_zones <- suppressMessages(get_municipalities(year = commutingzones_year,
                                                               scale = 1000)
                                            )

    # Save the raw data
      save(commuting_zones, file = here("data", tag, "raw", "commuting_zones.RData"))
    
    # Clean up
      commuting_zones <- commuting_zones %>%
        # Normalize geometry column name (called "geom" or "the_geom" depending on year)
          rename(any_of(c(geom = "the_geom"))) %>%
        # Drop Åland islands (ID = 21)
          subset(maakunta_code != 21) %>%
        # Drop columns
          dplyr::select(kunta, tyossakayntial_code, tyossakayntial_name_fi, geom)
        
    # Add indicators
      commuting_zones <- commuting_zones %>%
        # Indicator for areas outside commuting zones areas (ID=99)
          mutate(outside_commutingzones = ifelse(tyossakayntial_code==99, 1, 0)) %>%
        # Indicator for the municipalities where the closed schools located Kuopio (297) and Turku (853)
          mutate(temp = ifelse(kunta == 297 |          # Kuopio municipal ID = 297
                               kunta == 853,            # Turku municipal ID = 853
                               1,
                               0
                               )
          ) %>%
        # Indicator for all municipalities which were located in the same commuting zones as Turku and Kuopio
          group_by(tyossakayntial_code) %>%
          mutate(kuopioturku = max(temp)) %>%
          ungroup() %>%
        # Drop the temporary column
          dplyr::select(-temp)
  
  }
    

    
    

    
############################################



#----------------------------------------------------------
# FIND DENTAL SCHOOL COORDINATES
#----------------------------------------------------------
    
  
# Create a new data frame with dental school names
  school_df <- schools %>%
    # From vector to data frame
      data.frame(school = ., stringsAsFactors = FALSE) %>%
    # Add country for better geocoding
      mutate(country = "Finland")
    
# Geocode
  coordinates <- suppressMessages(tidygeocoder::geocode(school_df,
                                       city=school,
                                       country = country,
                                       method = "osm")      # osm = Open street maps
                                 )
  
# Save the raw data
  save(coordinates, file = here("data", tag, "raw", "coordinates.RData"))
    
# Transform coordinates from WGS84 to ETRS-TM35FIN
  coordinates <- suppressWarnings(
    coordinates %>% 
    st_as_sf(coords = c("long", "lat"), crs = 4326) %>%
    st_transform(crs = 3067) %>%
    mutate(easting = st_coordinates(.)[,1],
           northing = st_coordinates(.)[,2]) %>%
    st_drop_geometry()
  )
  

  
  
    
    
############################################



#----------------------------------------------------------
# ADD NUMERIC LABELS
#----------------------------------------------------------
    
    
#Numeric labels (1-4) for the map
  coordinates$label <- match(coordinates$school, schools)


    
    
        
############################################
    
    
     
#----------------------------------------------------------
# DRAW THE MAP
#----------------------------------------------------------
    
    
# Find maximum and minimum points so that the boundaries and legend location are neatly set
  # Find the extreme values of the bounding box
    bbox <- st_bbox(st_union(commuting_zones))
  # Save the values as individual objects
    xmin <- bbox["xmin"]
    xmax <- bbox["xmax"]
    ymin <- bbox["ymin"]
    ymax <- bbox["ymax"]
  # Drop the temporary table
    rm(bbox)

# Draw
    map <- ggplot(data = commuting_zones) +
      # Draw the less-affected commuting zones with grey
        geom_sf(fill = c("grey88", "transparent"),
                color = "transparent",
                size = 0,
                linewidth = 0,
                data=. %>% group_by(outside_commutingzones) %>% summarise()
                ) +
      # Add the most affected commuting zones with red
        geom_sf(fill = c("transparent", "#d18975"),
                color = "transparent",
                size = 0,
                linewidth = 0,
                data=. %>% group_by(kuopioturku) %>% summarise()
                ) +
      # Add commuting zone borders
        geom_sf(fill = "transparent",
                color = "black",
                size = .5,
                linewidth = .5,
                data=. %>% group_by(tyossakayntial_code) %>% summarise()
        ) +
      # Draw circles to dental school locations
        geom_point(data = coordinates,
                   aes(y = northing, x = easting),
                   size = 8,
                   fill = "white",
                   color = "black",
                   stroke = 1.5,
                   shape = 21
                   ) +
      # Add number to each location
        geom_text(data = coordinates,
                  aes(y = northing, x = easting, label = label),
                  size = 5,
                  color = "black",
                  family = font
                  ) +
      # Imporove looks by using map theme
        theme_map() +
      # Some manual modifications to the theme
        theme(
          text = element_text(family = font),
          axis.line = element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          plot.background = element_blank(),
          plot.tag.position = c(0, 1),
          plot.margin = margin(0, 0, 0, 0)
        ) +
      # Now create a legend title manually
        annotate("text",
                 x = xmax - 60000,
                 y = ymax - 200000,
                 label = "Dental schools",
                 size = 5,
                 hjust = 0,
                 fontface = 2,
                 family = font
                 ) +
      # Create rest of the legend manually
        annotate("text",
                 x = xmax - 60000,
                 y = ymax - 350000,
                 label = "1. Helsinki\n2. Turku\n3. Oulu\n4. Kuopio",
                 size = 5,
                 hjust = 0,
                 family = font
                 ) +
      # Define boundaries for the map
        coord_sf(xlim = c(xmin - 100000, xmax + 260000),
                 ylim = c(ymin - 10000, ymax + 10000),
                 expand = FALSE
                 ) +
      # Add scalebar
        annotation_scale(location = "br",           # Bottom-right
                         width_hint = 0.3,
                         height = unit(0.4, "cm"),
                         line_width = 1,
                         plot_unit = "m",
                         style = "bar",
                         unit_category = "metric",
                         text_cex = 1.2,
                         text_family = font
                         )

# Print the map
  print(map)
    
# Save    
  ggsave(here("output", tag, paste0("map_dental_schools_", commutingzones_year, ".pdf")), map, width = 130, height = 170, units = "mm", device="pdf", dpi=300)

# Drop temporary tables
  rm(commuting_zones, commutingzones_year, coordinates, xmin, xmax, ymin, ymax, map)
  gc()



############################################
 



