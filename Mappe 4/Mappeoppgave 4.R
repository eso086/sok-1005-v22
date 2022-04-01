# Laster ned nødvendige pakker:

library(purrr)
library(rvest)
library(tidyverse)
library(rlist)

browseURL("https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1005-1&week=1-20&View=list")

url <-"https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1005-1&week=1-20&View=list"

liste <- list("https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1005-1&week=1-20&View=list", 
              "https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1006-1&week=1-20&View=list",
              "https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1016-1&week=1-20&View=list")

# Lager funksjonen: timeplan

timeplan <- function(url1){
  page <- read_html(url1)
  table <- html_nodes(page, 'table')
  table <- html_table(table, fill=TRUE) 
  dframe <- list.stack(table)
  colnames(dframe) <- dframe[1,]
  dframe <- dframe %>% filter(!Dato=="Dato")
  dframe <- dframe %>% separate(Dato, 
                              into = c("Dag", "Dato"), 
                              sep = "(?<=[A-Za-z])(?=[0-9])")
  dframe <- dframe[-length(dframe$Dag),]
  dframe$Dato <- as.Date(dframe$Dato, format="%d.%m.%Y")
  dframe$Uke <- strftime(dframe$Dato, format = "%V")
  dframe <- dframe %>% select(Dag,Dato,Uke,Tid,Rom)
  return(dframe)
}
# Bruker map- funksjonen for å legge sammen liste og funksjonen

map(liste, timeplan)

# Legger inn timeplanen og listen inn i selve sluttproduktet: semesterplanen

semesterplan <- map(liste, timeplan)
semesterplan <- bind_rows(semesterplan)
semesterplan %>% 
  arrange(Dato)

#edit etter hjelp fra medstudenter

