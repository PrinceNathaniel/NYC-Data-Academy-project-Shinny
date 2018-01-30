library(DT)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(dygraphs)
navbarPage(title='Manhatton Crash Data',
           id='nav',
           theme=shinytheme('yeti'),
      ###map###
           tabPanel('Hot map',
                    div(class='outer',
                        tags$head(includeCSS('styles.css')),
          leafletOutput(outputId = 'map1',width = '100%',height = '100%'),
          
          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                        top = 80, left = "auto", right = 20, bottom = "auto",
                        width = 320, height = "auto",
                        h2("Mahatton Crash"),
                        selectizeInput("weather",
                                       "Weather",
                                       c('all','sunny','rain','snow')),
                        selectizeInput(inputId="cartype",
                                       "Type of Vehicle",
                                       c('all','passenger vehicle','SUV','bicycle','bus','taxi','motorcycle','truck/van')),
                        selectizeInput(inputId="factor",
                                       "Cause of the crash",
                                       c('all','inattention','follow too closely','tired','alcolho')),
                        checkboxInput(inputId='abs','absolute value'))
          
                        )),
      ###heatmap###
      tabPanel('Heat map',
               div(class='outer',
                   tags$head(includeCSS('styles.css')),
                   leafletOutput(outputId = 'heatmap',width = '100%',height = '100%'),
                   
                   absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                                 top = 80, left = "auto", right = 20, bottom = "auto",
                                 width = 320, height = "auto",
                                 h2("Mahatton Crash"),
                                 selectizeInput("weather2",
                                                "Weather",
                                                c('all','snow','sunny','rain')),
                                 selectizeInput(inputId="cartype2",
                                                "Type of Vehicle",
                                                c('all','passenger vehicle','SUV','bicycle','bus','taxi','motorcycle','truck/van')),
                                 selectizeInput(inputId="factor2",
                                                "Cause of the crash",
                                                c('all','inattention','follow too closely','tired','alcolho')),
                                 checkboxInput(inputId='abs2','absolute value'))
                   
               )),
          ###hist###
      tabPanel('hourly data',
               fluidRow(
                box( dygraphOutput('plot1')),
                box(
                  selectizeInput("weather3",
                                 "Weather",
                                 c('all','snow','sunny','rain')),
                  selectizeInput(inputId="cartype3",
                                 "Type of Vehicle",
                                 c('all','passenger vehicle','SUV','bicycle','bus','taxi','motorcycle','truck/van')),
                  selectizeInput(inputId="factor3",
                                 "Cause of the crash",
                                 c('all','inattention','follow too closely','tired','alcolho'))
                )
                      
               ))
           )

# header <- dashboardHeader(
#   title = "NYC crash data",
#   dropdownMenu(
#   menuItem("Map", tabName = "map", icon = icon("area-chart")))
# )
# 
# body<- dashboardBody(
#   fluidRow(
#     box(leafletOutput('map1')),
#     box(dygraphOutput('plot1')),
#     box(
#       selectizeInput("weather",
#                     "Weather",
#                     c('all','sunny','rain','snow')),
#       selectizeInput("cartype",
#                      "Type of Vehicle",
#                      c('all','passenger vehicle','SUV','bicycle','bus','taxi','motorcycle','truck/van')),
#       selectizeInput("factor",
#                      "Cause of the crash",
#                      c('all','alcolho')),
#       checkboxInput('abs','absolute value')
#         )#map1 control panel
#     
# ))#bodyend
# 
# dashboardSidebar<-dashboardSidebar(
# 
#   )
# 
# 
# dashboardPage(
#   header,
#   dashboardSidebar(disable=TRUE),
#   body
# )
