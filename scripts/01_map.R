
  

############################################




#----------------------------------------------------------
# FIND COMMUTING ZONES
#----------------------------------------------------------
    
    

# Get data on commuting zones in 2019
  commuting_zones <- get_municipalities(year=commutingzones_year, scale=1000)
  
# Save the raw data
  save(commuting_zones, file = here("data", tag, "raw", "commuting_zones.RData"))

# Clean up
  commuting_zones <- commuting_zones %>%
    # Drop Åland islands (ID = 21)
      subset(maakunta_code != 21) %>%
    # Drop columns
      dplyr::select(kunta, tyossakayntial_code, tyossakayntial_name_fi, geom) %>%
    # Indicator for areas outside commuting zones areas (ID=99)
      mutate(outside_commutingzones = ifelse(tyossakayntial_code==99, 1, 0)) %>%
    # Indicator for the commuting zones where the closed schools located Kuopio (20) and Turku (8)
      mutate(kuopioturku = ifelse(tyossakayntial_code == 20 |  # Kuopio ID = 20
                                    tyossakayntial_code == 8,  # Turku ID = 8
                                  1,
                                  0
                                  )
      )
    

    
    

    
############################################



#----------------------------------------------------------
# FIND DENTAL SCHOOL COORDINATES
#----------------------------------------------------------
    
  
# Create a new data frame with dental school names
  coordinates <- schools %>%
    # From vector to data frame
      data.frame(school = ., stringsAsFactors = FALSE) %>%
    # Add country for better geocoding
      mutate(country = "Finland")
    
# Geocode
  coordinates <- tidygeocoder::geocode(coordinates,
                                       city=school,
                                       country = country,
                                       method = "osm")      # osm = Open street maps
  
# Save the raw data
  save(coordinates, file = here("data", tag, "raw", "coordinates.RData"))
    
# Transform coordinates from WGS84 to ETRS-TM35FIN
  coordinates <- coordinates %>% 
    st_as_sf(coords = c("long", "lat"), crs = 4326) %>%
    st_transform(crs = 3067) %>%
    mutate(easting = st_coordinates(.)[,1],
           northing = st_coordinates(.)[,2]) %>%
    st_drop_geometry()
  

  
  
    
    
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
    ggplot(data = commuting_zones) +
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

# Save    
  ggsave(here("output", tag, "map_dental_schools.pdf"), width = 130, height = 170, units = "mm", device="pdf", dpi=300)

# Drop temporary tables
  rm(commuting_zones, coordinates, xmin, xmax, ymin, ymax)

      
      
      
############################################
 
      
      
  
