library(readr)
library(ggplot2)
library(tidyverse)
library(data.table)
library(zoo)
library(lubridate)
library(cowplot)
#importing table

#Oppgave 1

# Bruker readlines til å lese inn datasettet og etterhvert lage det til et datasett er numeric - noe som vi kan lage et plott ut av.

ds <- readLines("https://www.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt")
ds

# Fjerner tolv linjer slutten av tabellen - unødvendige linjer med skrift.

ds1 <- head(ds, -12)

# Bruker read_table til å lage datasettet om til en tabell.

df1 <- read_table(ds1)

# Velger ut tre variablene Year, Mo og Globe siden det er de vi skal lage et plott av. Har en tabell nå som består av 517 observasjoner og 3 variabler.

df2 <- df1 %>% 
  select(Year, Mo, Globe)
exists("df1")

temp_globe_year <- df2 %>%
  select(Year, Globe, Mo) %>% 
  mutate(Date = paste(Year, Mo, sep = "-")) %>%
  mutate(Date = lubridate::ym(Date)) %>%
  mutate(average_temp = zoo::rollmean(Globe, 13, 
                                      fill = NA, align = "center"))

# Tekst til en tekstboks midt i første plott.

text_box_label = "UAH Satelite based\nTemperature of the\nGlobal Lower Atmosphere\n(Version 6.0)"

# Lager selve plottet som skal være tilnærmet lik det som var på nettsiden.

plot <-temp_globe_year %>% 
  ggplot(aes(x = Date)) +
  geom_hline(yintercept = 0) +   # add line at 0 
  # add points and line:
  geom_point(aes(y = Globe), colour = "blue4", shape = 21) + 
  geom_line(aes(y = Globe), colour = "blue4", alpha = 0.5) +
  # add average:
  geom_line(aes(y = average_temp, group = 1), 
            colour = "red", size = 1)  +
  scale_y_continuous(breaks = seq(from= -0.7,to=0.9, by = 0.1) , 
                     labels = scales::comma) +  
  scale_x_date(date_breaks = "year", date_labels = "%Y",
               expand = c(0,0.1)) + 
  labs(title = "Latest Global Average Tropospheric Temperatures",
       x = NULL,
       y = "Departure from '91-'20 Avg. (deg. C)") +
  theme_bw() +
  annotate(geom="text", x=as.Date("2004-01-01"), y=-0.5, 
           label="Running, centered\n13 month average", 
           colour = "red") + 
  geom_segment(x = as.Date("2004-01-01"), y=-0.45,
               xend = as.Date("2008-01-01"), yend=-0.2,
               arrow = arrow(angle = 20, type = "closed",
                             length = unit(0.15, "inches")),
               colour = "red", size = 1) +
  annotate(geom="text", 
           x=as.Date("1987-01-01"), 
           y = 0.5, hjust = 0.5,
           label = text_box_label,
           colour = "blue4" ) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        panel.grid.minor.y = element_blank())


plot


