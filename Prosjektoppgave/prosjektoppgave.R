
getwd()
install.packages("hrbrthemes")
install.packages("extrafont")
library(tidyverse)
library(janitor)
library(lubridate) ## for date time manipulation
library(scales) ## Formatting numbers and values
library(hrbrthemes)# For changing ggplot theme
library(extrafont) # More font options
library(ggplot2) 
#---------- importerer datasett (fra kilde)---------
#file.choose() for mac -> choose.files() for windows
app <- read.csv(
  file.choose(),
  header = T,
  encoding = "utf-8"
)
cCrime <- read.csv(
  file.choose(),
  header = T,
  encoding = "utf-8"
)
cDemo <- read.csv(
  file.choose(),
  header = T,
  encoding = "utf-8"
)
cEmp <- read.csv(
  file.choose(),
  header = T,
  encoding = "utf-8"
)
wSales <- read.csv(
  file.choose(),
  header = T,
  encoding = "utf-8"
)
wWeather <- read.csv(
  file.choose(),
  header = T,
  encoding = "utf-8"
)

## x %>% f() er det samme som f(x)  


#app <- cCrime <-cDemo<-cEmp by County Name
appCrimeDemoEmp <- app %>%
  dplyr::left_join(
    cCrime,
    by = c("Store_County"="County_Name")
  ) %>% dplyr::left_join(
    cDemo,
    by = c("Store_County"="County_Name")
  ) %>% dplyr::left_join(
    cEmp,
    by = c("Store_County"="County_Name")
  )

#wSales <- (app <- cCrime <-cDemo<-cEmp by County Name) by store_num
salesCountyData <-  wSales %>%
  dplyr::left_join(
    appCrimeDemoEmp,
    by = c("Store_num"="Store_Num")
  )

#### regner med Weather_Date er antall dager siden 1-1-1960(version 1 av data)
#endrer navn p? date for ? joine med SCD...
weatherDate <- wWeather %>% dplyr::mutate(date = Weather_Date)




#(wSales <- (app <- cCrime <-cDemo<-cEmp by County Name) by store_num ) <- wWeather by Date & stor_num 
fullyJoined <- salesCountyData %>% dplyr::left_join(
  weatherDate,
  by= c("Date"="date", "Store_Weather_Station"="Weather_Station")  
)

write.csv(fullyJoined,"fulyJoined.csv", fileEncoding = "utf-8")

#Sjekker profitt og total profitt for hele bedriften.
profit <- with(fullyJoined, sum(Profit[Store_num >'2']))
profit
profit2 <- with(fullyJoined, sum(Profit[Store_num =='3']))
profit2


##oppgave 2
#2 Salgs rapport butikk nr 2----------------------------------------------------
proff_store2 <- with(fullyJoined, sum(Profit[Store_num =='2']))
proff_store2


store_num_2 <- 
  salesCountyData %>% 
  filter(Store_num == "2") %>% 
  select("County_Unemployed", "Sales", "Description", "Day","Date","Profit")

#total sales per day()
sales_by_day <- store_num_2 %>%
  group_by(Day) %>%
  summarise(Total_Sales=sum(Sales)) %>% 
  ungroup

##Visualizing summary data -> 
#Her kan vi uke rangert etter høyeste ommsetning
sales_by_day %>% 
  ggplot(aes(reorder(Day,Total_Sales),Total_Sales,fill=Day))+
  geom_col(show.legend = FALSE,color="black")+
  geom_text(aes(label=comma(Total_Sales)),size=3,hjust=1,color="black")+
  #scale_y_comma()+
  #scale_fill_brewer(palette = "Paired")+
  coord_flip()+
  theme_classic()+
  labs(title = "Total Sales breakdown by week(day variable)",x="Week",y= "Total sales")

#filtering for profit  
profit_by_day <- store_num_2 %>% 
  group_by(Day) %>%
  summarise(Total_profit=sum(Profit)) %>% 
  ungroup
#plotting for profit each day
ggplot(data=profit_by_day, aes(x=Day, y=Total_profit, group=1)) +
  geom_line()+
  scale_x_continuous(n.breaks = 16)+
  labs(title = "Total weekly profit", x = "Week", y = "Total profit") +
  geom_point()

# -----se hvilken varer som selger best over en uke---------

#--------lånt kode fra k-------
S2 <- fullyJoined %>% 
  filter(Store_num == "2", Year == "2012")

OS <- fullyJoined %>% 
  filter(Store_num !="2", Year == "2012")

S2agg <- 
  aggregate(cbind(Profit, Sold, Margin) ~ Week, S2, sum)

OSagg <- 
  aggregate(cbind(Profit, Sold, Margin) ~ Week, OS, sum) %>% 
  mutate(Profit = Profit/9,
         Sold = Sold/9,
         Margin = Margin/9)

ggplot() + 
  geom_line(data =  S11agg, aes(x = Week, y = Profit), color = "red") +
  geom_line(data = OSagg, aes(x = Week, y = Profit), color = "blue") +
  labs(title = "Butikk nr. 11 sin ukentlig fortjenestes for 2012 
       sammenliknet med de andre butikkene", 
       x = "Uke", y = "Profitt") +
  scale_x_continuous(breaks = seq(1, 52, 4)) +
  scale_y_continuous(breaks = seq(1000, 8000, 1000))+
  annotate("text", x= 43, y =7500, #lager "tekst-bokser" med "annotate" og bestemmer dere plasseringer, og deretter skriver inn teksten den skal inneholde
           label = "↓ Mean weekly profit in other stores",
           col = "black", #velger farge og størrelse på tekst
           size = 4) +
  annotate("text", x= 41, y =2500, 
           label = "    ↑  Weekly profit River City Strip Mall",
           col = "black",
           size = 4)+
  theme_get()




s11u23 <- BigData %>%
  filter(Store_num == "11", Week == "23")

s11u23 %>% 
  ggplot(aes(x = Description, y = Sold)) +
  geom_bar(size = 0.3, color = 'red', position = 'dodge', stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, size = 3)) +
  theme(axis.text.y = element_text(angle = 90, size = 8)) +
  labs( x = 'varer', y = 'antall varer solgt', title = 'jau')

s11u23 %>% 
  ggplot(aes(x = Description, y = Week)) +
  geom_point(size = s11u23$Sold/100, color = 'red') +
  theme(axis.text.x = element_text(angle = 90, size = 3)) +
  theme(axis.text.y = element_text(angle = 90, size = 8)) +
  labs( x = 'varer', y = 'antall varer solgt', title = 'jau')

ggplot() +
  geom_jitter(data=s11u23, aes(x='', y='', size = s11u23$Sold, col = s11u23$Sold, label = s11u23$Description))

ggplot(s11u23, aes(x= '', y= '', colour=s11u23$Sold, label=s11u23$Sold))+
  geom_point() +geom_text(hjust=0, vjust=0)+
  geom_jitter()


ggplot() + 
  geom_line(data =  S11agg, aes(x = Week, y = Profit), color = "red") +
  geom_line(data = OSagg, aes(x = Week, y = Profit), color = "blue") +
  labs(title = "Butikk nr. 11 sin ukentlig fortjenestes for 2012 
       sammenliknet med de andre butikkene", 
       x = "Uke", y = "Profitt") +
  scale_x_continuous(breaks = seq(1, 52, 4)) +
  scale_y_continuous(breaks = seq(1000, 8000, 1000))+
  annotate("text", x= 43, y =7500, #lager "tekst-bokser" med "annotate" og bestemmer dere plasseringer, og deretter skriver inn teksten den skal inneholde
           label = "↓ Mean weekly profit in other stores",
           col = "black", #velger farge og størrelse på tekst
           size = 4) +
  annotate("text", x= 41, y =2500, 
           label = "    ↑  Weekly profit River City Strip Mall",
           col = "black",
           size = 4)+
  theme_get()




P1 <- 
  ggplot() +
  geom_line(data =  S11agg, aes(x = Week, y = Sold), color = "red") +
  geom_line(data = OSagg, aes(x = Week, y = Sold), color = "blue") +
  scale_x_continuous(breaks = seq(13, 52, 5)) +
  theme_bw()




P2 <- 
  ggplot() +
  geom_line(data =  st2ag, aes(x = Week, y = Cost), color = "red") +
  geom_line(data = otherag, aes(x = Week, y = Cost), color = "blue") +
  scale_x_continuous(breaks = seq(13, 52, 8)) +
  theme_bw()




plot_grid(P1, P2, labels = c("Ukentlig salg", "Ukentlige kostnader"), label_size = 10)


#-------Oppgave 3----------
#filtering for profit.


Sales_pr_store <- wSales %>%
  filter(Month == "4") %>% 
  group_by(Store_num) %>%
  summarise(Total_Sales=sum(Sales)) %>% 
  ungroup



sammenligning <- Sales_pr_store %>% 
  #group_by(Store_num) %>% 
  summarise(mean(Total_Sales)) %>% 
  #ungroup()
  
  
  
  
  
  
  
  
  
  














