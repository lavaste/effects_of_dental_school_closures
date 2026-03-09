
  

############################################




#----------------------------------------------------------
# COMMUTING ZONES
#----------------------------------------------------------
    
    

#Get data on commuting zones in 2019
  municipalities <- get_municipalities(year=2019, scale=1000)

#Drop Åland
  municipalities <- subset(municipalities, maakunta_code!=21)

#Drop columns
  municipalities <- select(municipalities, gml_id, kunta,nimi, tyossakayntial_code, tyossakayntial_name_fi, geom)
  
#Indicator for areas outside commuting zones areas (ID=99)
  municipalities$not_commuterarea <- ifelse(municipalities$tyossakayntial_code==99, 1, 0)
  
#Indicator for Kuopio (20) and Turku (8)
  municipalities$kuopioturku <- ifelse(municipalities$tyossakayntial_code==20 | municipalities$tyossakayntial_code==8, 1, 0)
    

    
    

    
############################################



#----------------------------------------------------------
# DENTAL SCHOOLS
#----------------------------------------------------------
    
  
#List
    schools <- c("Turku", "Oulu", "Helsinki", "Kuopio")
    
#Data frame
    schools <- data.frame(schools, stringsAsFactors=FALSE)
    
#Geocoding
    schools <- tidygeocoder::geocode(schools, address=schools, method="osm")
    
#Koordinaattimuunnos: WGS84 --> ETRS-TM35FIN
    schools2 <- schools %>% 
      mutate(N = lat, E = long)
    coordinates(schools2) <- ~ E + N
    proj4string(schools2) <- CRS("+proj=longlat")
    schools2 <- spTransform(schools2, CRS("+init=epsg:3067"))
    schools2 <- schools2 %>%
      as.data.frame() %>%
      rename(easting=coords.x1, northing=coords.x2)

#Numeric labels (1-4) to the map
    schools2$label <- ""
    schools2$label <- ifelse(schools2$schools=="Helsinki",1,schools2$label)
    schools2$label <- ifelse(schools2$schools=="Turku",2,schools2$label)
    schools2$label <- ifelse(schools2$schools=="Oulu",3,schools2$label)
    schools2$label <- ifelse(schools2$schools=="Kuopio",4,schools2$label)
    
#Labels to the legend
    schools2$label2 <- ""
    schools2$label2 <- ifelse(schools2$schools=="Helsinki","1. Helsinki",schools2$label2)
    schools2$label2 <- ifelse(schools2$schools=="Turku","2. Turku",schools2$label2)
    schools2$label2 <- ifelse(schools2$schools=="Oulu","3. Oulu",schools2$label2)
    schools2$label2 <- ifelse(schools2$schools=="Kuopio","4. Kuopio",schools2$label2)
    
#Closing years
    schools2$closed <- NA
    schools2$closed <- ifelse(schools2$schools=="Turku",1994,schools2$closed)
    schools2$closed <- ifelse(schools2$schools=="Kuopio",1994,schools2$closed)
    
#Reopening years
    schools2$reopened <- NA
    schools2$reopened <- ifelse(schools2$schools=="Turku",2004,schools2$reopened)
    schools2$reopened <- ifelse(schools2$schools=="Kuopio",2010,schools2$reopened)
    schools2$reopened <- ifelse(schools2$schools=="Helsinki",1990,schools2$reopened)
    schools2$reopened <- ifelse(schools2$schools=="Oulu",1990,schools2$reopened)
    
#Last graduates
    schools2$grad_last <- NA
    schools2$grad_last <- ifelse(schools2$schools=="Turku",1999,schools2$grad_last)
    schools2$grad_last <- ifelse(schools2$schools=="Kuopio",1999,schools2$grad_last)
    
#First graduates after reopenings
    schools2$grad_new <- NA
    schools2$grad_new <- ifelse(schools2$schools=="Turku",2009,schools2$grad_new)
    schools2$grad_new <- ifelse(schools2$schools=="Kuopio",2015,schools2$grad_new)
    schools2$grad_new <- ifelse(schools2$schools=="Helsinki",1990,schools2$grad_new)
    schools2$grad_new <- ifelse(schools2$schools=="Oulu",1990,schools2$grad_new)
    
    
    
        
############################################
    
    
     
#----------------------------------------------------------
# DRAW
#----------------------------------------------------------
    
    
#Find maximum and minimum points
  country <- st_as_sf(st_union(municipalities))
  temp <- t(sapply(1:length(country), function(i) as.vector(extent(country[i,]))))
  colnames(temp) <- c('xmin','xmax','ymin','ymax')
  temp <- as.data.frame(temp)
  xmin <- min(temp$xmin, na.rm=TRUE)
  xmax <- max(temp$xmax, na.rm=TRUE)
  ymin <- min(temp$ymin, na.rm=TRUE)
  ymax <- max(temp$ymax, na.rm=TRUE)
  rm(temp)

#Map
    ggplot(data=municipalities) + 
      geom_sf(fill=c("grey88","transparent"),color="transparent",size=0,linewidth=0, data=. %>% group_by(not_commuterarea) %>% summarise()) +
      geom_sf(fill=c("transparent","#d18975"),color="transparent",size=0,linewidth=0, data=. %>% group_by(kuopioturku) %>% summarise()) +
      geom_sf(fill="transparent",color="black",size=.5,linewidth=.5, data=. %>% group_by(tyossakayntial_code) %>% summarise()) +
      geom_point(data=schools2, aes(y=northing, x=easting), size=8, fill="white", color="black", stroke=1.5, shape=21) +
      geom_text(data=schools2, aes(y=northing, x=easting, label=label), size=5, color="black") +
      #annotation_scale(location = "br", width_hint = 0.2, line_width=1, plot_unit="m", style="bar", unit_category="metric") #EI TOIMI!!
      #scalebar(data=schools2, dist=100, dist_unit="km", st.size=6.5, height=0.02, transform=FALSE, model="WGSN84", border.size=1, anchor=c(x=770000, y=6645000)) #EI TOIMI!!
    theme_map() +
      theme(
        axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.background=element_blank(),
        plot.tag.position=c(0,1),
        plot.margin=margin(0,0,0,0)
      ) +
      annotate("text", x=680000, y=7550000, label="Dental schools", size=6, hjust=0, fontface=2) +
      annotate("text", x=680000, y=7370000, label="1. Helsinki\n2. Turku\n3. Oulu\n4. Kuopio", size=6, hjust=0) +
      coord_sf(xlim=c(xmin-100000, xmax+400000),
               ylim=c(ymin-10000,ymax+10000),
               expand=FALSE)
    ggsave("alueet.pdf", width = 15, height = 15, units = "cm", device="pdf", dpi=600)



      
      
      
############################################
 
      
      
  
