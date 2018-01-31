library(leaflet.extras)
library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
#library(googleVis)
library(leaflet)
#library(ggmap)
library(DT)
library(shiny)
library(dygraphs)
#library(googleVis)
#source('help.R')
function(input, output,session){
  style <-theme(
    plot.background = element_rect(
      fill = '#282B30', colour = '#282B30'),
    panel.background = element_rect(
      fill = "#282B30", colour = '#686868'),
    panel.grid.major = element_line(colour = '#686868'),
    panel.grid.minor = element_line(colour = '#686868'),
    axis.title = element_text(color = '#989898', size = 15), 
    axis.text = element_text(color = '#989898', size = 10),
    plot.title = element_text(
      color = '#989898', size = 18,hjust = 0.5), 
    legend.background = element_rect(
      fill = '#282B30', colour = '#282B30'),
    legend.text = element_text(color = '#989898', size = 10),
    legend.title = element_text(color = "#989898",size = 12) )
  # mapdata<-reactive({
  #   data %>%
  #     filter((input$weather!='all' & weather==input$weather) | input$weather=='all') %>%
  #     filter(
  #       (input$cartype=='passenger vehicle' & (VEHICLE_TYPE_CODE_1=='PASSENGER VEHICLE'|VEHICLE_TYPE_CODE_2=='PASSENGER VEHICLE')) |
  #         input$cartype=='all'|
  #         (input$cartype=='SUV' &(VEHICLE_TYPE_CODE_1=='SPORT UTILITY / STATION WAGON' |VEHICLE_TYPE_CODE_2=='SPORT UTILITY / STATION WAGON'))|
  #         (input$cartype=='bicycle' &(VEHICLE_TYPE_CODE_1=='BICYCLE' |VEHICLE_TYPE_CODE_2=='BICYCLE'))|
  #         (input$cartype=='bus'&(VEHICLE_TYPE_CODE_1=='BUS' |VEHICLE_TYPE_CODE_2=='BUS'))|
  #         (input$cartype=='taxi'&(VEHICLE_TYPE_CODE_1=='TAXI' |VEHICLE_TYPE_CODE_2=='TAXI'))|
  #         (input$cartype=='motorcycle'&(VEHICLE_TYPE_CODE_1=='MOTORCYCLE' |VEHICLE_TYPE_CODE_2=='MOTORCYCLE'))|
  #         (input$cartype=='truck/van'&(VEHICLE_TYPE_CODE_1=='PICK-UP TRUCK' |VEHICLE_TYPE_CODE_2=='PICK-UP TRUCK'|
  #                                        VEHICLE_TYPE_CODE_1=='VAN' |VEHICLE_TYPE_CODE_2=='VAN'|VEHICLE_TYPE_CODE_1=='LIVERY VEHICLE' |VEHICLE_TYPE_CODE_2=='LIVERY VEHICLE'))
  #     )%>%
  #     filter(
  #       (input$factor=='all')|
  #         (input$factor=='alcolho'&(CONTRIBUTING_FACTOR_1=='Alcohol Involvement'|CONTRIBUTING_FACTOR_2=='Alcohol Involvement'))
  #     )%>%
  #     group_by(BoroCT2010)%>%
  #     summarize(n=n(),latitude=mean(LATITUDE),longitude=mean(LONGITUDE))%>%
  #     mutate(num=n/mean(n))
  # })
  # output$map2 <-renderLeaflet({
  #   leaflet()%>%
  #   addProviderTiles("CartoDB.Positron")
  #   %>% setView(lng = -73.99, lat = 40.75, zoom = 12)
  # })
  # observe({
  #   proxy<-leafletProxy('map2',data = mapdata()) %>%
  #     addCircles(lng = ~longitude, lat = ~latitude, weight = 0,
  #                radius = ~num*100,color='red'
  #     )
  # })
  output$map1 <-renderLeaflet({
    leaflet(
      #data filter
      data %>%
        filter((input$weather!='all' & weather==input$weather) | input$weather=='all') %>%
        filter(
          (input$cartype=='passenger vehicle' & (VEHICLE_TYPE_CODE_1=='PASSENGER VEHICLE'|VEHICLE_TYPE_CODE_2=='PASSENGER VEHICLE')) |
            input$cartype=='all'|
            (input$cartype=='SUV' &(VEHICLE_TYPE_CODE_1=='SPORT UTILITY / STATION WAGON' |VEHICLE_TYPE_CODE_2=='SPORT UTILITY / STATION WAGON'))|
            (input$cartype=='bicycle' &(VEHICLE_TYPE_CODE_1=='BICYCLE' |VEHICLE_TYPE_CODE_2=='BICYCLE'))|
            (input$cartype=='bus'&(VEHICLE_TYPE_CODE_1=='BUS' |VEHICLE_TYPE_CODE_2=='BUS'))|
            (input$cartype=='taxi'&(VEHICLE_TYPE_CODE_1=='TAXI' |VEHICLE_TYPE_CODE_2=='TAXI'))|
            (input$cartype=='motorcycle'&(VEHICLE_TYPE_CODE_1=='MOTORCYCLE' |VEHICLE_TYPE_CODE_2=='MOTORCYCLE'))|
            (input$cartype=='truck/van'&(VEHICLE_TYPE_CODE_1=='PICK-UP TRUCK' |VEHICLE_TYPE_CODE_2=='PICK-UP TRUCK'|
                                           VEHICLE_TYPE_CODE_1=='VAN' |VEHICLE_TYPE_CODE_2=='VAN'|VEHICLE_TYPE_CODE_1=='LIVERY VEHICLE' |VEHICLE_TYPE_CODE_2=='LIVERY VEHICLE'))
          )%>%
        filter(
          (input$factor=='all')|
            (input$factor=='alcolho'&(CONTRIBUTING_FACTOR_1=='Alcohol Involvement'|CONTRIBUTING_FACTOR_2=='Alcohol Involvement'))|
            (input$factor=='tired'&(CONTRIBUTING_FACTOR_1=='Fatigued/Drowsy'|CONTRIBUTING_FACTOR_2=='Fatigued/Drowsy'))|
            (input$factor=='inattention'&(CONTRIBUTING_FACTOR_1=='Driver Inattention/Distraction'|CONTRIBUTING_FACTOR_2=='Driver Inattention/Distraction'))|
            (input$factor=='follow too closely'&(CONTRIBUTING_FACTOR_1=='Following Too Closely'|CONTRIBUTING_FACTOR_1=='Following Too Closely'))
        )%>%
        group_by(BoroCT2010)%>%
        summarize(nn=n(),vmtradius=sum(vmt),latitude=mean(LATITUDE),longitude=mean(LONGITUDE))%>%
        mutate(num=nn/mean(nn),vmtr=vmtradius/mean(vmtradius))
    ) %>% setView(lng = -73.99, lat = 40.75, zoom = 12) %>%
      addProviderTiles("CartoDB.Positron") %>%
      
      addCircles(lng = ~longitude, lat = ~latitude, weight = 0,
                 radius = ~num*100,color='red',group = 'Normalized by number'
      )%>%
      addCircles(lng = ~longitude, lat = ~latitude, weight = 0,
                 radius = ~vmtr*100,color='red',group = 'Normalized by VMT*'
      )%>%
      addCircles(lng = ~longitude, lat = ~latitude, weight = 0,
                 radius = ~nn*2,color='red',group = 'Original data'
      )%>%
      addLayersControl(
        baseGroups = c('Normalized by number','Normalized by VMT*','Original data'),
        options = layersControlOptions(collapsed = TRUE)
      )
      
  })
  output$heatmap<-renderLeaflet({
    leaflet(
      #data filter
      data2 %>% 
        filter((input$weather2!='all' & weather==input$weather2) | input$weather2=='all') %>%
        filter(
          (input$cartype2=='passenger vehicle' & (VEHICLE_TYPE_CODE_1=='PASSENGER VEHICLE'|VEHICLE_TYPE_CODE_2=='PASSENGER VEHICLE')) |
            input$cartype2=='all'|
            (input$cartype2=='SUV' &(VEHICLE_TYPE_CODE_1=='SPORT UTILITY / STATION WAGON' |VEHICLE_TYPE_CODE_2=='SPORT UTILITY / STATION WAGON'))|
            (input$cartype2=='bicycle' &(VEHICLE_TYPE_CODE_1=='BICYCLE' |VEHICLE_TYPE_CODE_2=='BICYCLE'))|
            (input$cartype2=='bus'&(VEHICLE_TYPE_CODE_1=='BUS' |VEHICLE_TYPE_CODE_2=='BUS'))|
            (input$cartype2=='taxi'&(VEHICLE_TYPE_CODE_1=='TAXI' |VEHICLE_TYPE_CODE_2=='TAXI'))|
            (input$cartype2=='motorcycle'&(VEHICLE_TYPE_CODE_1=='MOTORCYCLE' |VEHICLE_TYPE_CODE_2=='MOTORCYCLE'))|
            (input$cartype2=='truck/van'&(VEHICLE_TYPE_CODE_1=='PICK-UP TRUCK' |VEHICLE_TYPE_CODE_2=='PICK-UP TRUCK'|
                                           VEHICLE_TYPE_CODE_1=='VAN' |VEHICLE_TYPE_CODE_2=='VAN'|VEHICLE_TYPE_CODE_1=='LIVERY VEHICLE' |VEHICLE_TYPE_CODE_2=='LIVERY VEHICLE'))
        )%>%
        filter(
          (input$factor2=='all')|
            (input$factor2=='alcolho'&(CONTRIBUTING_FACTOR_1=='Alcohol Involvement'|CONTRIBUTING_FACTOR_2=='Alcohol Involvement'))|
            (input$factor2=='tired'&(CONTRIBUTING_FACTOR_1=='Fatigued/Drowsy'|CONTRIBUTING_FACTOR_2=='Fatigued/Drowsy'))|
            (input$factor2=='inattention'&(CONTRIBUTING_FACTOR_1=='Driver Inattention/Distraction'|CONTRIBUTING_FACTOR_2=='Driver Inattention/Distraction'))|
            (input$factor2=='follow too closely'&(CONTRIBUTING_FACTOR_1=='Following Too Closely'|CONTRIBUTING_FACTOR_1=='Following Too Closely'))
        )%>%
        mutate(light=sqrt(sqrt((15205/length(DATE)))))
        
    ) %>% setView(lng = -73.99, lat = 40.75, zoom = 12) %>%
      addProviderTiles("CartoDB.DarkMatter") %>%
      removeWebGLHeatmap(layerId = 'a') %>%
      addWebGLHeatmap(layerId='a',lng=~LONGITUDE,lat=~LATITUDE,size=~mean(light)*190)
  })
  
  output$plot1<- renderDygraph({
    dygraph(
      data %>% 
        filter((input$weather3!='all' & weather==input$weather3) | input$weather3=='all') %>%
        filter(
          (input$cartype3=='passenger vehicle' & (VEHICLE_TYPE_CODE_1=='PASSENGER VEHICLE'|VEHICLE_TYPE_CODE_2=='PASSENGER VEHICLE')) |
            input$cartype3=='all'|
            (input$cartype3=='SUV' &(VEHICLE_TYPE_CODE_1=='SPORT UTILITY / STATION WAGON' |VEHICLE_TYPE_CODE_2=='SPORT UTILITY / STATION WAGON'))|
            (input$cartype3=='bicycle' &(VEHICLE_TYPE_CODE_1=='BICYCLE' |VEHICLE_TYPE_CODE_2=='BICYCLE'))|
            (input$cartype3=='bus'&(VEHICLE_TYPE_CODE_1=='BUS' |VEHICLE_TYPE_CODE_2=='BUS'))|
            (input$cartype3=='taxi'&(VEHICLE_TYPE_CODE_1=='TAXI' |VEHICLE_TYPE_CODE_2=='TAXI'))|
            (input$cartype3=='motorcycle'&(VEHICLE_TYPE_CODE_1=='MOTORCYCLE' |VEHICLE_TYPE_CODE_2=='MOTORCYCLE'))|
            (input$cartype3=='truck/van'&(VEHICLE_TYPE_CODE_1=='PICK-UP TRUCK' |VEHICLE_TYPE_CODE_2=='PICK-UP TRUCK'|
                                            VEHICLE_TYPE_CODE_1=='VAN' |VEHICLE_TYPE_CODE_2=='VAN'|VEHICLE_TYPE_CODE_1=='LIVERY VEHICLE' |VEHICLE_TYPE_CODE_2=='LIVERY VEHICLE'))
        )%>%
        filter(
          (input$factor3=='all')|
            (input$factor3=='alcolho'&(CONTRIBUTING_FACTOR_1=='Alcohol Involvement'|CONTRIBUTING_FACTOR_2=='Alcohol Involvement'))|
            (input$factor3=='tired'&(CONTRIBUTING_FACTOR_1=='Fatigued/Drowsy'|CONTRIBUTING_FACTOR_2=='Fatigued/Drowsy'))|
            (input$factor3=='inattention'&(CONTRIBUTING_FACTOR_1=='Driver Inattention/Distraction'|CONTRIBUTING_FACTOR_2=='Driver Inattention/Distraction'))|
            (input$factor3=='follow too closely'&(CONTRIBUTING_FACTOR_1=='Following Too Closely'|CONTRIBUTING_FACTOR_1=='Following Too Closely'))
        )%>%
        group_by(HOUR) %>%
        summarise(n=n()),#data part end
      main = 'Hourly number of car crash'
    )%>%
      dySeries('n',label='number of crashes')
  })
###weather###
graph1<-reactive({
  validate(
    need(input$weathercheckbox != "", "Please select at least one factor")
  )
  if (input$weathercheckbox=='all'){
    weatherdata}
  else{
    weatherdata %>% filter(weather %in% input$weathercheckbox) 
  }
  })

output$graph1<-renderPlot({
  ggplot(graph1(), aes(x=HOUR,color=weather, fill=weather))+
    
    geom_area(alpha=0.55,stat='bindot')+
    style+
    labs(x = "Hours", y = "Crash Count",
         title = "Area Map of Crash Count by Weather")
})
###factor###
graph2<-reactive({
  validate(
    need(input$factorcheckbox != "", "Please select at least one factor")
  )
  if (input$factorcheckbox=='all'){
    data}
  else{
    data %>% filter(CONTRIBUTING_FACTOR_1 %in% input$factorcheckbox) 
  }
})
output$graph2<-renderPlot({
  ggplot(graph2(), aes(x=HOUR,color=CONTRIBUTING_FACTOR_1, fill=CONTRIBUTING_FACTOR_1))+ 
    geom_area(alpha=0.55,stat='bindot')+
    guides(fill=guide_legend(title = 'crash causes'),color=guide_legend(title = 'crash causes'))+
    style+
    labs(x = "Hours", y = "Crash Count",
         title = "Area Map of Crash Count by Crash Causes")
})
###type###
graph3<-reactive({
  validate(
    need(input$typecheckbox != "", "Please select at least one factor")
  )

    data %>% filter(VEHICLE_TYPE_CODE_1 %in% input$typecheckbox) 

})
output$graph3<-renderPlot({
  ggplot(graph3(), aes(x=HOUR,color=VEHICLE_TYPE_CODE_1, fill=VEHICLE_TYPE_CODE_1))+ 
    geom_area(alpha=0.55,stat='bindot')+
    guides(fill=guide_legend(title = 'vehicle type'),color=guide_legend(title = 'vehicle type'))+
    style+
    labs(x = "Hours", y = "Crash Count",
         title = "Area Map of Crash Count by Vehicle Type")
})

}
