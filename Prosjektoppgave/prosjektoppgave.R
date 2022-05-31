getwd()
library(tidyverse)
library(janitor)


app <- read.csv(
  choose.files(),
  header = T,
  encoding = "utf-8"
)
cCrime <- read.csv(
  choose.files(),
  header = T,
  encoding = "utf-8"
)
cDemo <- read.csv(
  choose.files(),
  header = T,
  encoding = "utf-8"
)
cEmp <- read.csv(
  choose.files(),
  header = T,
  encoding = "utf-8"
)
wSales <- read.csv(
  choose.files(),
  header = T,
  encoding = "utf-8"
)
wWeather <- read.csv(
  choose.files(),
  header = T,
  encoding = "utf-8"
)

## x %>% f() er det samme som f(x)  


#app <- cCrime <-cDemo<-cEmp by County Name
appCrimeDemoEmp <- app %>%
  dplyr::left_join(
    cCrime,
    by = c("Store_County"="ï..County_Name")
  ) %>% dplyr::left_join(
    cDemo,
    by = c("Store_County"="County_Name")
  ) %>% dplyr::left_join(
    cEmp,
    by = c("Store_County"="ï..County_Name")
  )

#wSales <- (app <- cCrime <-cDemo<-cEmp by County Name) by store_num
salesCountyData <-  wSales %>%
  dplyr::left_join(
    appCrimeDemoEmp,
    by = c("Store_num"="Store_Num")
  )

# regner med Weather_Date er antall dager siden 1-1-1960
weatherDate <- wWeather %>% dplyr::mutate(date = Weather_Date)




#(wSales <- (app <- cCrime <-cDemo<-cEmp by County Name) by store_num ) <- wWeather by Date & stor_num 
fullyJoined <- salesCountyData %>% dplyr::left_join(
  weatherDate,
  by= c("Date"="date", "Store_Weather_Station"="Weather_Station")  
)

write.csv(fullyJoined,"fulyJoined.csv", fileEncoding = "utf-8")

#Calculate total profit per store
profit <- with(fullyJoined, sum(Profit[Store_num >'2']))
profit


profit2 <- with(fullyJoined, sum(Profit[Store_num =='3']))
profit2



#2 Salgs rapport butikk nr 2----------------------------------------------------
proff_store2 <- with(fullyJoined, sum(Profit[Store_num =='2']))
proff_store2

high_store_profit <- 
  salesCountyData %>% 
  filter(Store_num == "2") %>% 
  
  
  
  
  
  
  
  
  
  
  




#plot for weekly profit all store
#plot total profit
#plotpro <-
#  ggplot(data=fullyJoined, aes(x=Date, y=Profit, group=1)) +
#  geom_line()
#  
#
#plotpro
#plot for weather  


#does crime matter for sales
max(salesCountyData$Sold)
