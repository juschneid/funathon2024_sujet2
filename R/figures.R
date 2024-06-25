
plot_airport_line <- function(df,selected_airport){
  trafic_aeroports <- df %>% 
    mutate(trafic=apt_pax_dep + apt_pax_tr + apt_pax_arr,
           date=as.Date(paste("1",mois,an,sep="-"),format="%d-%m-%Y"))%>%  
    filter(apt %in% selected_airport) 

  figure_plotly <- trafic_aeroports %>% 
    plot_ly(
      x=~date, y=~trafic, 
      text=~apt_nom,
      name="trafic",
      type='scatter',
      mode='lines+markers',
      hovertemplate = paste("<i>Aéroport:</i> %{text}<br>Trafic: %{y}") ) #paste("<i>Aéroport:</i> %{text}<br>Trafic: %{y}") )
  
  return(figure_plotly)
}
