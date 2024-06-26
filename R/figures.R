
plot_airport_line <- function(df,selected_airport){
  trafic_aeroports <- df %>% 
    mutate(trafic=apt_pax_dep + apt_pax_tr + apt_pax_arr,
           date=as.Date(paste("1",mois,an,sep="-"),format="%d-%m-%Y"))%>%  
    filter(apt_nom %in% selected_airport) 

  figure_plotly <- trafic_aeroports %>% 
    plot_ly(
      x=~date, y=~trafic, 
      text=~apt_nom,
      color=I('orange'),
      name="",
      type='scatter',
      mode='lines+markers',
      hovertemplate = paste("<i>Aéroport:</i> %{text}<br>Trafic: %{y}")) %>% 
    layout(xaxis=list(title="Mois de l'année"), yaxis=list(title="Nombre de passagers"))
  
  return(figure_plotly)
}


map_leaflet_airport  <- function(df, airports_location, month, year){
  
palette <- c("green", "orange", "darkred")

trafic_aeroports <- df %>% 
  filter(an==year & mois==month) %>% 
  mutate(trafic=apt_pax_dep + apt_pax_tr + apt_pax_arr) %>% 
  left_join(airport_location %>% 
              select(Nom, Code.IATA, Code.OACI,geometry), by=c("apt"="Code.OACI")) %>%
  filter(is.na(Code.IATA)==F) %>% 
  mutate(volume=ntile(trafic,3)) %>% 
  mutate(color=palette[volume]) %>% 
  st_as_sf(sf_column_name = 'geometry')

sf::st_crs(trafic_aeroports)

icons <- awesomeIcons(
  icon = 'plane',
  iconColor = 'black',
  library = 'fa',
  markerColor = trafic_aeroports$color
)

carte_interactive <- leaflet(trafic_aeroports) %>% 
  addTiles() %>% 
  addAwesomeMarkers(
    icon=icons[],
    popup=~paste0(Nom, " : ",trafic," voyageurs"))

return(carte_interactive)
}

