
getwd()
install.packages("hrbrthemes")
install.packages("extrafont")
install.packages("ggthemes")
install.packages("treemapify")
library(tidyverse)
library(janitor)
library(lubridate) ## for date time manipulation
library(scales) ## Formatting numbers and values
library(hrbrthemes)# For changing ggplot theme
library(extrafont) # More font options
library(ggplot2) 
library(ggthemes)
library(treemapify)


#-------- importing datasett---------
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

## x %>% f() is the same as f(x)  
cDemo
cCrime



#app <- cCrime <-cDemo<-cEmp by County Name
appCrimeDemoEmp <- app %>%
  dplyr::left_join(
    cCrime,
    by = c("Store_County"="ï..County_Name")#Encoding issues different on mac and windows, hence the ï..
  ) %>% dplyr::left_join(
    cDemo,
    by = c("Store_County"="County_Name")#Encoding issues different on mac and windows, hence the ï..
    by = c("Store_County"="ï..County_Name")#Encoding issues different on mac and windows, hence the ï..
                                           
  )

#wSales <- (app <- cCrime <-cDemo<-cEmp by County Name) by store_num
salesCountyData <-  wSales %>%
  dplyr::left_join(
    appCrimeDemoEmp,
    by = c("Store_num"="Store_Num")
  )


#changing name join with weaterdate
weatherDate <- wWeather %>% dplyr::mutate(date = Weather_Date)




#(wSales <- (app <- cCrime <-cDemo<-cEmp by County Name) by store_num ) <- wWeather by Date & stor_num 
fullyJoined <- salesCountyData %>% dplyr::left_join(
  weatherDate,
  by= c("Date"="date", "Store_Weather_Station"="Weather_Station")  
)

write.csv(fullyJoined,"fulyJoined.csv", fileEncoding = "utf-8")



#check total profit for all stores and store number 2.
profit <- with(fullyJoined, sum(Profit[Store_num >'2']))
profit
profit2 <- with(fullyJoined, sum(Profit[Store_num =='2']))
profit2


##oppgave 2
#2 -----Salgs rapport butikk nr 2-------------------

# show total profit for store number 2
proff_store2 <- with(fullyJoined, sum(Profit[Store_num =='2']))
proff_store2


store_num_2 <- 
  salesCountyData %>% 
  filter(Store_num == "2") %>% 
  select("County_Unemployed", "Sales", "Description", "Day","Date","Profit")

#total sales per week (day variable)
sales_by_day <- store_num_2 %>%
  group_by(Day) %>%
  summarise(Total_Sales=sum(Sales)) %>% 
  ungroup

##Visualizing summary data -> 
#Ranging Top turnover weeks
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

# total weekly turnover

# best sellers 1 weekly  store num 2
wSales
store_1week <- wSales %>% 
  filter(Store_num == "2", Month == "10") %>% 
  select("Description", "Price","Sold","Sales","Profit","Date","Month","Day")

#Total turnover week 7
new_sum <- store_1week %>% 
  filter(Day == "7") %>% 
  group_by(Day) %>% 
  summarise(Total_sales = sum(Sales)) %>% 
  ungroup()
new_sum
#total rev. for store number two in week number 7 is 13954 dollar



# Filtering Power City Freestand

store2 <- fullyJoined %>%
  filter(Store_num =="2")

#Filtering week 1 and
w1_store2 <- store2[c(1:174),]

w2_store2 <- store2[c(174:373),]

#Week 1 items most sold
Most_salesw1 <- w1_store2 %>%
  group_by(INV_NUMBER, Description, Price, Sold, Cost, Profit, Sales) %>%
  summarise(Sales) %>%
  arrange(desc(Sales)) %>%
  ungroup()

Most_salesw1


#Week 1 items most profit
Most_profitw1 <- w1_store2 %>%
  group_by(INV_NUMBER, Description, Price, Sold, Cost, Profit, Sales) %>%
  summarise(Profit) %>%
  arrange(desc(Profit)) %>%
  ungroup()

Most_profitw1


#Week 2 items most sales
Most_salesw2 <- w2_store2 %>%
  group_by(INV_NUMBER, Description, Price, Sold, Cost, Profit, Sales) %>%
  summarise(Sales) %>%
  arrange(desc(Sales)) %>%
  ungroup()
Most_salesw2


#Week 2 items most profit
Most_salesw2 <- w2_store2 %>%
  group_by(INV_NUMBER, Description, Price, Sold, Cost, Profit, Sales) %>%
  summarise(Profit) %>%
  arrange(desc(Profit)) %>%
  ungroup()
Most_salesw2



#Week 1 least profit
Least_profitw1 <- w1_store2 %>%
  group_by(INV_NUMBER, Description, Price, Sold, Cost, Profit, Sales) %>%
  summarise(Profit) %>%
  arrange(Profit) %>%
  ungroup()
Least_profitw1


##Week 2 least profit
Least_profitw2 <- w2_store2 %>%
  group_by(INV_NUMBER, Description, Price, Sold, Cost, Profit, Sales) %>%
  summarise(Profit) %>%
  arrange(Profit) %>%
  ungroup()
Least_profitw2

#setting up price groups.

per_item <- w1_store2 %>%
  group_by(Price_per_item = ifelse(Price <= 1.0, "<1$",
                                   ifelse(Price > 1 & Price <= 2, "1$",
                                          ifelse(Price > 2 & Price <= 3, "2$",
                                                 ifelse(Price > 3 & Price <= 4, "3$",
                                                        ifelse(Price > 4 & Price <= 5, "4$",
                                                               ifelse(Price > 5 & Price <= 6, "5$",
                                                                      ifelse(Price > 6 & Price <= 7, "6$",
                                                                             ifelse(Price > 7 & Price <= 8.0,
                                                                                    "7$", ">8$"))))))))) %>%
  summarise(Sold, Price, Sales, Profit)


#plot

figure_1 <-
  per_item %>%
  ggplot(aes(x=Price_per_item, y = Sold))+
  geom_bar(stat= "identity", fill = "blue") +
  geom_text(aes(label=Profit), vjust= 100, size=3)+
  labs(title = " Sales per pricegroup", x = "Pricegroup sold $", y =
         "Total Sales per pricegoup")+
  theme_bw()
figure_1



  


#-------Oppgave 3----------

df_4 <- fullyJoined %>% 
  filter(Month == 10, Year == 2012, Price >= 0, Cost >= 0, Sold >= 0)# Filtering for needed data

inntekt_summary <- df_4%>%
  group_by(Store_County) %>% 
  summarise( Total_revenue = sum(Sales)) %>% #
  summarise( percent_revenue = Total_revenue/sum(Total_revenue), 
             Total_revenue = Total_revenue, Country = Store_County) #Choosing data 
inntekt_summary <- inntekt_summary %>% 
  mutate(labels = paste(Country, paste(round(percent_revenue,2)*100,'%') , sep =' '))
#plotting the strongest county
inntekt_summary %>%
  ggplot(aes(area = Total_revenue, fill = Country, label = labels)) +
  geom_treemap() +
  geom_treemap_text(fontface = "bold", colour = "white", place = "centre", grow = TRUE) + 
  #Changing estetics
  theme(legend.position = "none") +
  labs(title = 'comparing county sales data') + 
  labs(subtitle = 'Shows the most dominant county Power County') +
  theme(plot.title = element_text(size = 20, face = "bold"), 
        plot.subtitle = element_text(size = 12))


  
  
  










  
  
  
  
  
  
  
  
  
  














