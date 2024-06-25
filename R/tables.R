create_table_airports <- function(stats_aeroports){
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
  tab_header(title=md("**Nombre de passagers par aéroport**"),
             subtitle=md(paste0("*Classement au 1/",month,"/",year,"*")))%>% 
  tab_source_note("Source: DGAC, via data.gouv.fr") %>% 
  tab_options(table.font.names = "Marianne") %>% 
  opt_interactive()
  
  return(table_aeroports)
}

