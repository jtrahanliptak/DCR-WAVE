##############################################################################################################################
#     Title: precip_map.R
#     Type: Secondary Module for DCR Shiny App
#     Description: Site Map for Precipitation stations
#     Written by: Dan Crocker, Summer 2018
##############################################################################################################################

# Notes: 
#   1. req() will delay the rendering of a widget or other reactive object until a certain logical expression is TRUE or not NULL
#
# To-Do List:
#   1. Make the Metero/Hydro Filters work
#   2. Plotting Features - Show Limits, Finish and Clean up Coloring options (flagged data, met filters)

##############################################################################################################################
# User Interface
##############################################################################################################################

PRECIP_MAP_UI <- function(id) {
  
  ns <- NS(id) # see General Note 1
  
  tagList(
    leafletOutput(ns("map"), height = 350 )
  ) # end taglist
} # end UI function


##############################################################################################################################
# Server Function
##############################################################################################################################
# SITE LIST IS REACTIVE

PRECIP_MAP <- function(input, output, session, df_site) {
  
  # Reactive Site Dataframe for Map Coloring, Creating a Selected Column with "Yes" or "No" values
  
  # df_site_react <- reactive({
  #   df_temp <- df_site %>% filter(!is.na(LocationPrecip))
  #   if(!is.null(Site_List)){   # SHOULD THIS BE Site_List() ?
  #     df_temp$Selected <- ifelse(df_temp$LocationLabel %in% Site_List(), "yes", "no")
  #   } else {
  #     df_temp$Selected <- "no"
  #   }
  #   df_temp
  # })
  
  # Map Color Scheme - Coloring the Selected Site Markers a different color than the unselected 
  # does this need to be reactive? if not, probably still needs to be a function?
  colorpal <- reactive({
    colorFactor(c("navy", "red"), domain = c("yes", "no"))
  })
  
  # Base Leaflet Map - See General Note 3
  
  output$map <- renderLeaflet({
    
    leaflet(data = df_site %>% filter(LocationPrecip != "")) %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)) %>%
      addCircleMarkers(lng = ~LocationLong, lat = ~LocationLat,
                       label= ~LocationLabel,
                       popup = ~paste("ID =", LocationLabel, "<br/>", 
                                      "Station # =", LocationPrecip, "<br/>",
                                      "Description =", LocationDescription, "<br/>",
                                      "Lat = ", LocationLat, "<br/>", 
                                      "Long = ", LocationLong, "<br/>",
                                      "Elev = ", LocationElevFt, "ft"),
                       radius = 5,
                       weight = 3,
                       opacity = 1,
                       fillOpacity = 0,
                       color = "red")
    
  })
  
  
  # Map Proxy - UPdate Color of Circle Markers as Site selection changes
  
  # observe({
  #   
  #   pal <- colorpal()
  #   
  #   leafletProxy("map", data = df_site_react()) %>%
  #     clearMarkers() %>%
  #     addCircleMarkers(lng = ~LocationLong, lat = ~LocationLat,
  #                      label=~LocationLabel,
  #                      popup = ~paste("ID =", Site, "<br/>", 
  #                                     "Description =", LocationDescription, "<br/>",
  #                                     "Lat = ", LocationLat, "<br/>", 
  #                                     "Long = ", LocationLong, "<br/>",
  #                                     "Elev = ", LocationElevFt, "ft"),
  #                      radius = 5,
  #                      weight = 3,
  #                      opacity = 1,
  #                      fillOpacity = 0,
  #                      color = ~pal(Selected))
  #   
  # })
  
} # end Server Function

