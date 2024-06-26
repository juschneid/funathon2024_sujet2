summary_stat_airport <- function(data, year, month){
  stats_aeroports <- data %>%
    filter(mois %in% month, an %in% year) %>% 
    group_by(apt, apt_nom) %>%
    summarise(
      paxdep = round(sum(apt_pax_dep, na.rm = T),3),
      paxarr = round(sum(apt_pax_arr, na.rm = T),3),
      paxtra = round(sum(apt_pax_tr, na.rm = T),3)) %>% 
    mutate(paxtot= paxdep+paxarr+paxtra) %>%
    arrange(desc(paxtot)) %>% 
    mutate(cleanname=paste0(str_to_title(apt_nom)," (",apt,")"))
  
  return(stats_aeroports)
}
