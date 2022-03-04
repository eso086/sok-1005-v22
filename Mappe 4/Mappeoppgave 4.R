rm(list=ls())
install.packages("rlist")
library(rvest)
library(tidyverse)
library(rlist)
# Henter data sett
url <- "https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1005-1&week=1-20&View=list&module[]=SOK-1006-1&module[]=SOK-1016-1#week-9"

webpage <- read_html(url)


#skraper tabell
table <- html_nodes(webpage, 'table')
table <- html_table(table, fill=TRUE) 

table[[1]]
df <- list.stack(table)
df

colnames(df) <- df[1,]
df

df <- df %>% 
  filter(!Dato=="Dato") %>% 
  separate(Dato, into = c("Dag", "Dato"), sep = "(?<=[A-Za-z])(?=[0-9])")
  


df <- df[-length(df$Dag),]


df$Dato <- as.Date(df$Dato, format="%d.%m.%Y")


df$Uke <- strftime(df$Dato, format = "%V")
df %>% 
  select(Dag,Dato,Uke,Tid,Rom,Emnekode)

df


