install.packages("xml2")
library(tidyverse)
library(xml2)
library(rvest)
library(janitor)


#Oppgave 1


#Henter html kode
HTML <- read_html("https://www.motor.no/aktuelt/motors-store-vintertest-av-rekkevidde-pa-elbiler/217132/bil")

#Henter tabeller
tables <- HTML %>% html_table(fill = TRUE)

#Henter tabell som sammenligner wtpl og egentlig rekkevidde
df <- tables[[1]]
df <- df[-1,]



#lager df og tar bort ufullstendig målinger/na verdier
df <- as.data.frame(df)
df <- df[-c(19, 26), ]


#gir kollonner nytt navn. 
colnames(df) <- c("Modell", "WLTP", "Stopp", "Avvik")
df <- df %>% 
  mutate(WLTP = as.numeric(gsub("km.*", "", WLTP)))
df <- df %>% 
  mutate(Stopp = as.numeric(gsub("km.*", "", Stopp)))


#Plot oppgave 1

plot <- df %>% ggplot(aes(x = WLTP, y = Stopp)) +
  geom_point() +
  labs(title= "Kjørelengde på elbil", 
       x= "WLTP", 
       y= "Stopp") +
  theme_gray() +
  scale_y_continuous(limits = c(100, 600)) +
  scale_x_continuous(limits = c(100, 600)) +
  geom_abline(col = "red",
              size = 1)

plot

# oppgave 2
lm(Stopp ~ WLTP, data=df)

df %>% ggplot(aes(x=WLTP, y= Stopp)) +
  geom_point() +
  geom_smooth(method=lm)  +
  labs(title= "Rekkevidde på EL-bil", 
       x= "WLTP", 
       y= "Stopp") +
  theme_gray()

