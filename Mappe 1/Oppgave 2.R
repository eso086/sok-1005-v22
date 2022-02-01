library(readr)
library(ggplot2)
library(tidyverse)
library(data.table)
library(zoo)
library(lubridate)
library(cowplot)

#Oppgave 2

# Laster inn datasett for alle de fire ulike for å lage fire plott som viser nedre troposfære, midtre troposfære, troposfæren og nedre stratosfære

Lower_Trop <- fread("https://www.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt", nrows = 517)
Lower_Trop1 <- Lower_Trop %>%
  select(Year, NoPol, Mo,) %>% 
  mutate(Date = paste(Year, Mo, sep = "-")) %>%
  mutate(Date = lubridate::ym(Date)) %>%
  mutate(average_temp = zoo::rollmean(NoPol, 13, 
                                      fill = NA, align = "center"))



Mid_Trop <- fread("https://www.nsstc.uah.edu/data/msu/v6.0/tmt/uahncdc_mt_6.0.txt", nrows = 517)
Mid_Trop1 <- Mid_Trop %>%
  select(Year, NoPol, Mo,) %>%  
  mutate(Date = paste(Year, Mo, sep = "-")) %>%
  mutate(Date = lubridate::ym(Date)) %>%
  mutate(average_temp = zoo::rollmean(NoPol, 13, 
                                      fill = NA, align = "center"))



Trop <- fread("https://www.nsstc.uah.edu/data/msu/v6.0/ttp/uahncdc_tp_6.0.txt", nrows = 517)
Trop1 <- Trop %>%
  select(Year, NoPol, Mo,) %>% 
  mutate(Date = paste(Year, Mo, sep = "-")) %>%
  mutate(Date = lubridate::ym(Date)) %>%
  mutate(average_temp = zoo::rollmean(NoPol, 13, 
                                      fill = NA, align = "center"))



Lower_Strat <- fread("https://www.nsstc.uah.edu/data/msu/v6.0/tls/uahncdc_ls_6.0.txt" , nrows = 517)
Lower_Strat1 <- Lower_Strat %>%
  select(Year, NoPol, Mo,) %>%  
  mutate(Date = paste(Year, Mo, sep = "-")) %>%
  mutate(Date = lubridate::ym(Date)) %>%
  mutate(average_temp = zoo::rollmean(NoPol, 13, 
                                      fill = NA, align = "center"))


# Plott til hver og en av datasettene:
# Plottene viser gjennomsnittstemperaturen, hvor vi har brukt zoo::rollmean - som regner ut et 13 måneders glidende gjennomsnitt.

p1 <- Lower_Trop1 %>%
  ggplot(aes(x = Date, y = NoPol)) +
  geom_line(aes(y = average_temp, group = 1), 
            colour = "red", size = 1)  +
  geom_line(col = "Blue") +
  geom_point(col = "Blue") +
  labs(title = "Nedre troposfære",
       x = " ",
       y = "Temperatur")
p2 <- Mid_Trop1 %>%
  ggplot(aes(x = Date, y = NoPol)) +
  geom_line(aes(y = average_temp, group = 1), 
            colour = "red", size = 1)  +
  geom_line(col = "blue") +
  geom_point(col = "blue") +
  labs(title = "Midt troposfære",
       x = " ",
       y = "Temperatur")
p3 <- Trop1 %>%
  ggplot(aes(x = Date, y = NoPol)) +
  geom_line(aes(y = average_temp, group = 1), 
            colour = "red", size = 1)  +
  geom_line(col = "Blue") +
  geom_point(col = "blue") +
  labs(title = "Troposfære",
       x = " ",
       y = "Temperatur")
p4 <- Lower_Strat1 %>%
  ggplot(aes(x = Date, y = NoPol)) +
  geom_line(aes(y = average_temp, group = 1), 
            colour = "red", size = 1)  +
  geom_line(col = "purple") +
  geom_point(col = "purple") +
  labs(title = "Nedre stratosfære",
       x = " ",
       y = "Temperatur")
plot_grid(p1, p2, p3, p4, ncol = 2, labels = "AUTO")