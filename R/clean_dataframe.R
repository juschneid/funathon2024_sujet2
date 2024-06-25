clean_dataframe <- function(df){
  df <- df %>% 
    mutate(an=str_sub(ANMOIS,1,4),
           mois=str_remove(str_sub(ANMOIS,5,6),"^0+"))
  colnames(df)<-tolower(colnames(df))
  return(df)
}



