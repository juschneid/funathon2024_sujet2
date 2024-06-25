#Import de nos fonctions
source("R/create_data_list.R")
source("R/clean_dataframe.R")
source("R/import_data.R")

#Import des packages
library(tidyverse)
library(readr)
#library(sf) non util car mis en ::


MONTHS_LIST = 1:12

# Load data ----------------------------------
urls <- create_data_list("./sources.yml")


pax_apt_all<- import_airport_data(unlist(urls$airports))
pax_cie_all<- import_compagnies_data(unlist(urls$compagnies))
pax_lsn_all<- import_liaisons_data(unlist(urls$liaisons))

airport_location <- sf::st_read(unlist(urls$geojson$airport))