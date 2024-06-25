#a lancer dans le terminal renv::restore() pour avoir tous les packages d'instaléls avec la bonne version

#PART1 : Import des données ---
##Exo 1: import des url ----
data <- yaml::read_yaml("correction/sources.yml")
data
#a été créé dans R/create_data_list.R
##quel interet de faire une fonction ???

source("R/create_data_list.R")

urls <- create_data_list("sources.yml")


##Exo 2: import des bases ----

#données aeroports
library(readr)

install.packages("tidyverse")
library(tidyverse)
#faire  renv::snapshot() pour mettre à jour le renv.lock et que tidyverse soit automatiquement dans le renv()

#old way sans fonction
airports <- readr::read_csv2(unlist(urls$airports),
                             col_types=cols(ANMOIS=col_character(),
                                            APT=col_character(),
                                            APT_NOM=col_character(),
                                            APT_ZON=col_character(),
                                            .default=col_double()))  %>%
    mutate(an=str_sub(ANMOIS,1,4),
           mois=str_remove(str_sub(ANMOIS,5,6),"^0+"))
colnames(airports)<-tolower(colnames(airports))


source("R/clean_dataframe.R")#tout y es 

#données compagnies

compagnies <- readr::read_csv2(unlist(urls$compagnies),
                             col_types=cols(ANMOIS=col_character(),
                                            CIE=col_character(),
                                            CIE_NOM=col_character(),
                                            CIE_NAT=col_character(),
                                            CIE_PAYS=col_character(),
                                            .default=col_double()))  %>%
    mutate(an=str_sub(ANMOIS,1,4),
           mois=str_remove(str_sub(ANMOIS,5,6),"^0+"))
colnames(compagnies )<-tolower(colnames(compagnies ))

#données liaison 

liaisons <- readr::read_csv2(unlist(urls$liaisons),
                               col_types=cols(ANMOIS=col_character(),
                                              LSN=col_character(),
                                              LSN_DEP_NOM=col_character(),
                                              LSN_ARR_NOM=col_character(),
                                              LSN_SCT=col_character(),
                                              LSN_FSC=col_character(),
                                              .default=col_double()))  %>%
  mutate(an=str_sub(ANMOIS,1,4),
         mois=str_remove(str_sub(ANMOIS,5,6),"^0+"))
colnames(liaisons)<-tolower(colnames(liaisons))


#pour avoir les bons noms : 
pax_apt_all <- airports
pax_cie_all <- compagnies
pax_lsn_all <- liaisons


#données spatiales

airport_location <- sf::st_read(unlist(urls$geojson$airport))
sf::st_crs(airport_location)
#vérifier Geodetic CRS:  WGS 84

library(leaflet)

leaflet(airport_location) %>% 
  addTiles() %>% 
  addMarkers(popup=~Nom)

liste_aeroports <- unique(pax_apt_all$apt)
default_airport <- liste_aeroports[1]


#PART2 : Exploration de données ----

##Exo3 : graphique de frequentatoin des aéroports ----

trafic_aeroports <- pax_apt_all %>% 
  mutate(trafic=apt_pax_dep + apt_pax_tr + apt_pax_arr,
         date=as.Date(paste("1",mois,an,sep="-"),format="%d-%m-%Y"))%>%  
  filter(apt==default_airport) 

ggplot(trafic_aeroports)+
  geom_line(aes(x=date, y=trafic))

nom_aer <- trafic_aeroports %>%  distinct(apt_nom) %>% as.character()

graph_plotly <- trafic_aeroports %>% 
  plot_ly(
    x=~date, y=~trafic, 
    name="trafic",
    type='scatter',
    mode='lines+markers',
    hovertemplate = paste("<i>Aéroport:</i> ",nom_aer,"<br>Trafic: %{y}") ) #paste("<i>Aéroport:</i> %{text}<br>Trafic: %{y}") )
graph_plotly

#sous forme de fonction
plot_airport_line <- function(df,airport){
  
  default_airport<-liste_aeroports[liste_aeroports==airport]
  trafic_aeroports <- df %>% 
    mutate(trafic=apt_pax_dep + apt_pax_tr + apt_pax_arr,
           date=as.Date(paste("1",mois,an,sep="-"),format="%d-%m-%Y"))%>%  
    filter(apt==default_airport) 
  
  nom_aer <- trafic_aeroports %>%  distinct(apt_nom) %>% as.character()
  
  graph_plotly <- trafic_aeroports %>% 
    plot_ly(
      x=~date, y=~trafic, 
      name="trafic",
      type='scatter',
      mode='lines+markers',
      hovertemplate = paste("<i>Aéroport:</i> ",nom_aer,"<br>Trafic: %{y}") ) #paste("<i>Aéroport:</i> %{text}<br>Trafic: %{y}") )
  graph_plotly
  }
plot_airport_line(pax_apt_all,"LFBA")


##Exo4 : tableau HTML-----
YEARS_LIST  <- as.character(2018:2022)
MONTHS_LIST <- 1:12


summary_stat_airport <- function(df,year,month){
  stats_aeroports <- df %>% 
    filter(an==year & mois==month) %>% 
    mutate(total= apt_pax_dep + apt_pax_tr + apt_pax_arr,
           aeroport=paste0(apt_nom," (",apt,")")) %>% 
    arrange(desc(total)) %>% 
    select(aeroport,apt_pax_dep,apt_pax_tr, apt_pax_arr,total)
  return(stats_aeroports)
}

tab <-  summary_stat_airport(pax_apt_all,"2022","7")

#dans correction, font des group  by et somme si jamais il y a a plusieeurs anénes /mois

library(gt)
stats_aeroports %>% 
  ungroup() %>% 
  select(cleanname, paxdep,paxarr, paxtra) %>% 
  gt() %>% 
  fmt_number(columns=c(paxdep,paxarr, paxtra), suffixing=T) %>% 
  fmt_markdown(columns=cleanname) %>% 
  cols_label(cleanname="Aéroports",
             paxdep='Départs',
             paxarr='Arrivées',
             paxtra="Transits") %>% 
  tab_header(title=md("*Nombre de passagers par aéroport*"),
             subtitle=md(paste0("Classement au 1/",month,"/",year)))%>% 
  tab_source_note("Source: DGAC, via data.gouv.fr") %>% 
  tab_options(table.font.names = "Marianne") %>% 
    # tab_style(style=cell_text(weight='bold'), locations =list(cells_column_labels(), cells_stubhead()) ) %>% 
  opt_interactive()


## Exo5: carte
library(sf)
library(leaflet)

palette <- c("#91AE4F","#484D7A","#E18B63") #ne fonctionne pas..... LEAFLET DEMISSION

palette <- c("darkgreen", "darkblue", "darkred")
trafic_aeroports <- pax_apt_all %>% 
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

leaflet(trafic_aeroports) %>% 
  addTiles() %>% 
  addAwesomeMarkers(
    icon=icons[],
    popup=~paste0(Nom, " : ",trafic," voyageurs"))




