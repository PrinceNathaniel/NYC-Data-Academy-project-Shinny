library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(googleVis)
library(leaflet)
library(ggmap)
nyct2010<-read.csv('nyct2010.csv')
data<-read.csv('data2.csv')
data2<-read.csv('data2.csv')
data$DATE<-strftime( as.Date(data$DATE,'%m/%d/%y'),"%Y-%m-%d")
raw_data<-data %>% group_by(BoroCT2010)
raw_data<-data %>% group_by(BoroCT2010) %>%
  summarize(n=n(),latitude=mean(LATITUDE),longitude=mean(LONGITUDE))
rain_data<-data %>% filter(rain_1>=1) %>% group_by(BoroCT2010) %>%
  summarize(n=n(),latitude=mean(LATITUDE),longitude=mean(LONGITUDE))
snow_data<-data %>% filter(snow_1>=1) %>% group_by(BoroCT2010) %>%
  summarize(n=n(),latitude=mean(LATITUDE),longitude=mean(LONGITUDE)) %>%
  mutate(num=n/sum(n))
weather_data<-data %>% group_by(BoroCT2010) %>% 
  summarise(snow=sum(snow_1,na.rm = TRUE),n=n(),
            latitude=mean(LATITUDE),longitude=mean(LONGITUDE))


