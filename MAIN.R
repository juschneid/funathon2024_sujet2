#Import de nos fonctions
source("R/create_data_list.R")
source("R/clean_dataframe.R")
source("R/import_data.R")
source("R/figures.R")

#Import des packages
library(tidyverse)
library(readr)
#library(sf) non util car mis en ::
library(plotly)

MONTHS_LIST = 1:12

# Load data ----------------------------------
urls <- create_data_list("./sources.yml")


pax_apt_all<- import_airport_data(unlist(urls$airports))
pax_cie_all<- import_compagnies_data(unlist(urls$compagnies))
pax_lsn_all<- import_liaisons_data(unlist(urls$liaisons))

airport_location <- sf::st_read(unlist(urls$geojson$airport))

liste_aeroports <- unique(pax_apt_all$apt)
default_airport <- liste_aeroports[1]

figure_plotly <- plot_airport_line(pax_apt_all, default_airport)

