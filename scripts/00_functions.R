

# ----------------------------------------------------------
# CUSTOM GGPLOT THEME
# ----------------------------------------------------------

timanttinen_teema <- function(base_size = 18, legend_orientation = "vertical", legend_rows = 1, legend_columns = 4) {
  
  list(
    
  #Base it on theme_minimal
    theme_minimal(base_size = base_size) +
      theme(
        
        # Text size in general
          text = element_text(size = base_size),
          
        # x axis: labels on a 45 degree angle and right-top-aligned + no title
          axis.text.x = element_text(size = base_size, angle = 45, vjust = 1, hjust = 1),
          axis.title.x = element_blank(),
        
        # y axis: title centered
          axis.text.y = element_text(size = base_size),
          axis.title.y = element_text(size = base_size, hjust = 0.5),
        
        # No graph titles
          plot.title = element_blank(),
          plot.subtitle = element_blank(),
        
        # Legend settings
          legend.position = "bottom",
          legend.box = legend_orientation,
          legend.direction = legend_orientation,
          legend.box.just = "left",
          legend.text = element_text(size = base_size, margin = margin(t =0,
                                                                       b = 0,
                                                                       l = 2,
                                                                       r = 2
                                                                       )
                                     ),
          legend.box.margin = margin(t = 0,
                                     b = 0,
                                     l = 0,
                                     r = 0
                                     ),
          legend.margin = margin(t = 0,
                                 b = 0,
                                 l = 0,
                                 r = 0
                                 ),
          legend.key.size = unit(10, "pt"),
          legend.spacing = unit(1, "pt"),
          legend.title = element_blank(),

        # Grid: no minor grid lines
          panel.grid.minor = element_blank(),
        
        # Define plot margins
          plot.margin = margin(t = 10,
                               b = 10,
                               l = 10,
                               r = 10
                               )
        
      ),
      
      # Legend row number
        guides(color = guide_legend(nrow = legend_rows,
                                    ncol =legend_columns))
  )

}