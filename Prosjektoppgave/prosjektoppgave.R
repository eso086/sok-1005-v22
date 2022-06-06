
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
cDemo
cCrime



#app <- cCrime <-cDemo<-cEmp by County Name
appCrimeDemoEmp <- app %>%
  dplyr::left_join(
    cCrime,
    by = c("Store_County"="ï..County_Name")#Navn må muligens endres dersom det kjøres på en annen maskin, Encoding feil.
  ) %>% dplyr::left_join(
    cDemo,
    by = c("Store_County"="County_Name")#Navn må muligens endres dersom det kjøres på en annen maskin, Encoding feil.
  ) %>% dplyr::left_join(
    cEmp,
    by = c("Store_County"="ï..County_Name")#Navn må muligens endres dersom det kjøres på en annen maskin, Encoding feil.
                                           
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
#Her kan vi uke rangert etter hÃ¸yeste ommsetning
sales_by_day %>% 
  ggplot(aes(reorder(Day,Total_Sales),Total_Sales,fill=Day))+
  geom_col(show.legend = FALSE,color="black")+
  geom_text(aes(label=comma(Total_Sales)),size=3,hjust=1,color="black")+
  coord_flip()+
  theme_classic()+
  labs(title = "Total Sales breakdown by week(day variable)",x="Week",y= "Total sales")

#filtering for profit  
profit_by_day <- store_num_2 %>% 
  group_by(Day) %>%
  summarise(Total_profit=sum(Profit)) %>% 
  ungroup
#plotting profit each week
ggplot(data=profit_by_day, aes(x=Day, y=Total_profit, group=1)) +
  geom_line()+
  scale_x_continuous(n.breaks = 16)+
  labs(title = "Total weekly profit", x = "Week", y = "Total profit") +
  geom_point()

# -----se hvilken varer som selger best over en uke---------

# best sellers 1 week 1 store
wSales
store_1week <- wSales %>% 
  filter(Store_num == "2", Month == "10") %>% 
  select("Description", "Price","Sold","Sales","Profit","Date","Month","Day")

new_sum <- store_1week %>% 
  filter(Day == "7") %>% 
  group_by(Day) %>% 
  summarise(Total_sales = sum(Sales)) %>% 
  ungroup()
new_sum
#Det totale salget for butikk nummer 2 i uke nummer 7 er 13954 dollar.

#finne Største bidragsytere til salget.




  


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
  
  
  
  
  
  
  
  
  
  














