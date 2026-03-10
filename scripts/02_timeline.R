

############################################



#----------------------------------------------------------
# ADD CLOSURE AND RE-OPENING INFO TO THE DATA FRAME LISTING DENTAL SCHOOLS
#----------------------------------------------------------


# Map the closures and re-openings
  intake_closed_map <- c("Turku" = closure_intake, "Kuopio" = closure_intake, "Helsinki" = timeline_year_end, "Oulu" = timeline_year_end)
  output_closed_map <- c("Turku" = closure_output, "Kuopio" = closure_output, "Helsinki" = timeline_year_end, "Oulu" = timeline_year_end)
  intake_reopened_map <- c("Turku" = opening_intake_turku, "Kuopio" = opening_intake_kuopio)
  output_reopened_map <- c("Turku" = opening_output_turku, "Kuopio" = opening_output_kuopio)

# Create the data frame
  timeline <- school_df %>%
    # Drop the country column
      dplyr::select(-country) %>%
    # Add years as columns
      mutate(
        # When the student intake stopped
          intake_closed = intake_closed_map[schools],
        # When the graduate output stopped
          output_closed = output_closed_map[schools],
        # When the student intake reopened
          intake_reopened = intake_reopened_map[schools],
        # when the graduate output continued
          output_reopened = output_reopened_map[schools]
      )



############################################



#----------------------------------------------------------
# DRAW THE TIMELINE GRAPH
#----------------------------------------------------------



#Draw the graph
  timeline_graph <- ggplot(timeline) +
    # Bar for how long schools admitted new student from 1990 onwards
      geom_segment(aes(timeline_year_begin,
                       school,
                       xend = intake_closed,
                       yend = school,
                       color="New students admitted"
                       ),
                   linewidth = 14
                   ) +
    # How long was intake halted in Turku and Kuopio
      geom_segment(aes(intake_closed,
                       school,
                       xend = intake_reopened,
                       yend = school,
                       color="No admissions"
                       ),
                   linewidth = 14
                   ) +
    # Draw rest of the bars from the reopenings until the end of the timeline
      geom_segment(aes(intake_reopened,
                       school,
                       xend = timeline_year_end,
                       yend = school,
                       color="New students admitted"
                       ),
                   linewidth = 14
                   ) +
    # Bar for how long schools supplied new graduates from 1990 onwards
      geom_segment(aes(timeline_year_begin,
                       school,
                       xend = output_closed,
                       yend = school,
                       color = "New graduates"),
                   linewidth = 3,
                   linetype = "solid"
                   ) +
    # Draw the rest of the bars from the reopenings  until the end of the timeline
      geom_segment(aes(output_reopened, school, xend = timeline_year_end, yend=school, color="New graduates"),
                   linewidth=3,
                   linetype="solid"
                   ) +
    # Add title
      labs(x = NULL,
           y = NULL,
           title = "Dental schools:") +
    # Minimal theme
      theme_minimal() +
    # x axis ticks
      scale_x_continuous(breaks = seq(timeline_year_begin, timeline_year_end, by = 1),
                         limits = c(timeline_year_begin, timeline_year_end),
                          expand = c(0, 0)) +
    # Reverse the y axis
      scale_y_discrete(limits = rev) +
    # Custom theme modifications
      theme(text = element_text(family = font),                                   # Font
            axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 16),    # Centre and tilt x axis labels
            axis.text.y = element_text(size = 16),                                  # Set y axis font size
            axis.text = element_text(color = "black"),                                # Axis text color as black
            legend.position = "bottom",                                             # 
            legend.spacing.y = unit(.1, 'cm'),
            legend.margin = margin(t = 0, unit='cm'),
            legend.text=element_text(size = 16, margin = margin(t = 10, b = 10)),
            legend.key.size = unit(.5, "cm"),
            legend.key.height = unit(.5, "cm"),
            legend.key.width = unit(2, "cm"),
            plot.title = element_text(hjust = -0.1, size = 16),
            legend.direction = "horizontal",
            plot.margin = grid::unit(c(5,5,5,5), "mm"),
            panel.grid.major.y = element_blank(),
            panel.grid.minor.y = element_blank()
            ) +
    # Custom colours
      guides(colour = guide_legend(reverse = TRUE, nrow = 1, byrow = TRUE)) +
      scale_color_manual(values = c("#474f58","#8fd175","#d18975"),name = NULL)

# Print the graph
  print(timeline_graph)
  
# Save the graph
  ggsave(here("output", tag, "timeline.pdf"), timeline_graph, width = 300, height = 120, units = "mm", device="pdf", dpi=300)

# Remove temporary frames
  rm(school_df, list = ls()[startsWith(ls(), "timeline") | endsWith(ls(), "_map")])
  gc()


############################################


