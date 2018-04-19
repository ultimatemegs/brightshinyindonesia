# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
# Author: Megan Barnes mdbarnes@hawaii.edu

library(shiny)
library(leaflet)
library(sf)
library(raster)

#site data
fp <- "../shinymap/data/2018_04_10_GPS_Indo_WWF_NF_DD.csv"
site.data <- read.csv(fp)
names(site.data)[5:6]<- c("Lat", "Lon")
site.data.sf <- st_as_sf(site.data, coords = c("Lon", "Lat"), crs = 4326)
wgs84_sf <- st_crs("+proj=longlat +datum=WGS84")  # define WGS as sf code from WGS84

# seascape data 
indo_land_f <- "../shinymap/data/Indonesia/Indonesia.shp"
Indo_land_sf <-  st_read(indo_land_f)
sbs_sscape_f <- "../shinymap/data/SBS boundary/Sunda_Banda_Dissolve.shp"
sbs_SeaScape <- st_read(sbs_sscape_f)
indoExtent=extent(site.data.sf)
miniIndo <- st_intersection(Indo_land_sf, st_set_crs(st_as_sf(as(indoExtent, "SpatialPolygons")), st_crs(Indo_land_sf)))

# MPA data 
mpa.fp <- "../shinymap/data/Marine Protected Areas_SBS_atlas_April 17 2018/national_marine_mpa_indonesia.shp"
mpas.indo <- st_read(mpa.fp)
mpas.sbs <- st_intersection(mpas.indo, st_set_crs(st_as_sf(as(indoExtent, "SpatialPolygons")), st_crs(mpas.indo)))

# Define UI for application that draws a histogram
ui <- tabPanel("Map", leafletOutput("sbsmap"))

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$sbsmap <- renderLeaflet({   # All the leaflet map stuff goes here
    getColor <- function(site.data) {
      sapply(site.data$category, function(category) {
        if(category %in% "Inside MPA") {
          "darkblue"
        } else if(category %in% "Outside MPA") {
          "blue"
        } else {
          "red"
        } })
    }
    
    icons <- awesomeIcons(
      icon = 'ios-close',
      iconColor = 'black', # default white, its the X part
      library = 'ion',
      markerColor = getColor(site.data)
    )
    
    leaflet() %>%  	
      setView(lng = 125.379842, lat = -6, zoom = 6) %>%
      addTiles() %>%
      addAwesomeMarkers(site.data, lng=site.data$Lon, lat=site.data$Lat, 
                        popup=site.data$Site.name, 
                        icon=icons) %>%
      addPolygons(data = sbs_SeaScape,
                  col="blue", fillColor = "gray", 
                  fillOpacity = 0.3, weight = 1) %>%
      addPolygons(data=mpas.sbs, # can make all indo if needed.
                  popup=mpas.sbs$NAMAMPA, 
                  col="dark green", fillColor = "green", 
                  fillOpacity = 0.5, weight = 1)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

