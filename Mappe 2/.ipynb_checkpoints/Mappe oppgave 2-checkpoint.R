install.packages("jsonlite")
install.packages("ggrepel")
library(jsonlite)
library(tidyverse)
library(ggplot2)
library(ggrepel)


# Oppgave 1
df <- fromJSON("https://static01.nyt.com/newsgraphics/2021/12/20/us-coronavirus-deaths-2021/ff0adde21623e111d8ce103fedecf7ffc7906264/scatter.json")

download.file(url, "lokal_nyc_data.json")


plot <- df %>% 
  ggplot(aes(x= fully_vaccinated_pct_of_pop, y= deaths_per_100k, label = name )) +
  geom_point() +
  geom_label_repel(
    max.overlaps = Inf,
    size = 3.5,
    label.size = 0,
    label.padding = 0,
    label.r = 0,
  ) +
  labs(title= "Covid-19 dødsfall etter universal voksen vaksinedose sammenlignet med vaksinasjons rate", 
       x = "Andel fullvaksinert befolkning",
       y = "dødsfall per 100k") +
  theme_bw()

plot




#oppgave 2


lm( deaths_per_100k ~ fully_vaccinated_pct_of_pop, data = df)



plot + geom_smooth(method = lm)

