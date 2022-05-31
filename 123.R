library(tidyverse)
library(httr)
library(rjstat)
library(gdata)
library(janitor)
library(lubridate)

options(encoding= "UTF-8")
# A
# Url fra tabellen på ssb
url <- "https://www.ssb.no/statbank/sq/10064586"
url1 <- "https://www.ssb.no/statbank/sq/10064781"
url2 <- "https://www.ssb.no/statbank/sq/10066351"
url3 <- "https://data.ssb.no/api/v0/no/table/05327/"

# JSON-spørring fra API
data <- '
{"query":
[{"code":"Makrost","selection":{"filter":"item","values": ["koh.nrpriv","koo.nroff","bif.nr83_6","makrok.nrianv","eks.nrtot","imp.nrtot","bnpb.nr23_9","bnpb.nr23_9fn","bnpb.nr23oljsj"]}},{"code":"ContentsCode","selection":{"filter":"item","values":["Priser","Faste","PriserSesJust"]}},{"code":"Tid","selection":{"filter":"top","values":["8"]}}],
"response":{"format":"json-stat2"}}
'


data1 <- '{
  "query": [{"code": "Konsumgrp", "selection": {"filter": "item","values": ["JAE_TOTAL" ] } },{"code": "ContentsCode","selection": {"filter": "item","values": [ "KPIJustIndMnd"] } },{ "code": "Tid", "selection": { "filter": "item", "values": [
 "2012M01", "2012M02", "2012M03", "2012M04","2012M05", "2012M06", "2012M07","2012M08","2012M09", "2012M10", "2012M11","2012M12","2013M01",  "2013M02", "2013M03", "2013M04", "2013M05", "2013M06", "2013M07", "2013M08","2013M09", "2013M10","2013M11", "2013M12", "2014M01", "2014M02", "2014M03", "2014M04", "2014M05","2014M06", "2014M07", "2014M08", "2014M09", "2014M10", "2014M11", "2014M12", "2015M01", "2015M02", "2015M03", "2015M04","2015M05", "2015M06", "2015M07","2015M08", "2015M09", "2015M10", "2015M11", "2015M12", "2016M01", "2016M02",
 "2016M03", "2016M04", "2016M05","2016M06","2016M07", "2016M08", "2016M09", "2016M10", "2016M11", "2016M12", "2017M01", "2017M02", "2017M03","2017M04", "2017M05", "2017M06", "2017M07", "2017M08", "2017M09", "2017M10", "2017M11", "2017M12", "2018M01",
 "2018M02", "2018M03", "2018M04", "2018M05", "2018M06", "2018M07", "2018M08", "2018M09", "2018M10", "2018M11","2018M12", "2019M01", "2019M02", "2019M03","2019M04", "2019M05", "2019M06", "2019M07", "2019M08", "2019M09", "2019M10", "2019M11", "2019M12", "2020M01", "2020M02", "2020M03","2020M04",
 "2020M05", "2020M06", "2020M07","2020M08", "2020M09", "2020M10", "2020M11", "2020M12", "2021M01", "2021M02", "2021M03","2021M04",
"2021M05", "2021M06", "2021M07","2021M08", "2021M09", "2021M10", "2021M11",  "2021M12", "2022M01", "2022M02" ]  }  }], "response": { "format": "json-stat2"}}'

# Vet ikke hva dette gjør ?
d.tmp <- POST(url , body = data, encode = "json", verbose())

d.tmp2 <- POST(url1 , body = data, encode = "json", verbose())

d.tmp3 <- POST(url3 , body = data1, encode = "json", verbose())

d.tmp3

# Henter ut innholdet fra d.tmp (koden over) som tekst, og der ifra bearbeides som en JSON-fil (FROMJSONSTAT)
sbtabell <- fromJSONstat(content(d.tmp, "text"))

totaltabell <- fromJSONstat(content(d.tmp2, "text"))

energi <- fromJSONstat(content(d.tmp3, "text"))

energi <- energi %>%
  separate(måned, into=c("year", "month"), sep="M") %>%
  mutate(dato = ymd(paste(year, month, "15")))

# Caller datasettet
sbtabell
totaltabell
energi

kpi <- rbind(sbtabell, totaltabell)

# SBtabell vil være en liste, ved bruk av versjon 1 av JSON

# Lager det til en tibble og et long-format
clean_names(kpi)
kpi <- as_tibble(kpi)


energi <- as_tibble(energi)

energi %>%
  select(konsumgruppe)

# Fjerner visse navn fra tabellen


# Lager variabler for å kunne lage et plot og lager et skille for kolonnene
kpi <- kpi %>%
  separate(måned, into=c("year", "month"), sep="M") %>%
  mutate(dato = ymd(paste(year, month, "15")))

# Gjør om formatet til et pivot_wider format
kpi <- kpi %>%
  pivot_wider(names_from = statistikkvariabel, values_from = value)

kpi


new_table <- kpi %>%
  subset(select=c("dato", "konsumgruppe", "Konsumprisindeks (2015=100)", "Konsumprisindeks (vekter)"))

#gir variablene nytt navn
new_table <- new_table %>%
  rename(indeks = 'Konsumprisindeks (2015=100)', vekter = 'Konsumprisindeks (vekter)')

#rydder i navnene
new_table <- new_table %>% clean_names()

#rebaserer vektene slik at de summerer seg til 1 på totalindeksen
new_table <- new_table %>%
  mutate(vekter = vekter/1000)


#lager ny tabell med kun konsumprisindeksen
kpi_table <- new_table %>%
  select(-vekter) %>%
  pivot_wider(names_from = konsumgruppe, values_from = indeks)

#lager plot
kpi_table %>%
  ggplot(aes(x=dato)) +
  geom_line(aes(y=`Elektrisitet, fyringsoljer og annet brensel`), color="purple") +
  geom_line(aes(y=Totalindeks), color="red") +
  labs(title = "Konsumprisindeks fra januar 2012 - desember 2021",
       x = "År",
       y = "KPI 2015 = 100") +
  theme_bw()



#lager ny tabell i wide format med kun vekter
vekter_table <- new_table %>%
  select(-indeks) %>%
  pivot_wider(names_from = konsumgruppe, values_from = vekter)


new_table <- new_table %>%
  mutate(bidrag = indeks*vekter)



# lage ein
kpi_table %>%
  ggplot(aes(x=dato)) +
  geom_line(aes(y= energi), color="purple") +
  geom_line(aes(y= Totalindeks), color="red") +
  labs(title = "Konsumprisindeks fra januar 2012 - desember 2021",
       x = "År",
       y = "KPI 2015 = 100") +
  theme_bw()

kpi_table %>% select(Totalindeks)

energi

energi <- energi %>%
  select(dato, konsumgruppe, value) %>% mutate(konsumgruppe="KPI-JAE")

kpi_table<-kpi_table %>%
  select(dato, Totalindeks) %>%
  pivot_longer(Totalindeks, names_to="konsumgruppe") %>%
  full_join(energi) %>% arrange(dato)



tinytex::tlmgr_install("pdfcrop")

#lager plot
new_table %>%
  ggplot(aes(x=dato)) +
  geom_line(aes(y='Elektrisitet, fyringsoljer og annet brensel'), color="purple") +
  geom_line(aes(y=bidrag), color="red") +
  labs(title = "Konsumprisindeks fra januar 2012 - desember 2021",
       x = "År",
       y = "KPI 2015 = 100") +
  theme_bw()



















kpi_table %>%
  ggplot(aes(x=dato)) +
  geom_line(y = aes(y = KPI-JAE), color = konsumgruppe))+
  geom_line(y = aes(y = Totalindeks), color = konsumgruppe))+
  labs(title = "Konsumprisindeks fra januar 2012 - desember 2021",
       x = "År",
       y = "KPI 2015 = 100") +
  theme_bw()





  