create_table_airports <- function(stats_aeroports, year, month){
  mois<- format(as.Date(paste0(year,"-",month,"-01"), format="%Y-%m-%d"), "%b",local="fr" ) #calcul automatique
  table_aeroports <- stats_aeroports %>% 
    ungroup() %>% 
    select(cleanname, everything()) %>% 
    select(-paxtot) %>% 
    gt() %>% 
    cols_hide(columns = starts_with("apt")) %>% 
    fmt_number(columns= starts_with("pax"), suffixing=T) %>% 
    fmt_markdown(columns=cleanname) %>% 
    cols_label(cleanname=md("**Aéroports**"),
               paxdep=md('Départs'),
               paxarr=md('Arrivées'),
               paxtra=md("Transits")) %>% 
  tab_header(title=md(paste0("**Nombre de passagers par aéroport - ",mois," ",year,"**")))%>% 
  tab_options(table.font.names = "Marianne") %>% 
  opt_interactive()
  
  return(table_aeroports)
}

