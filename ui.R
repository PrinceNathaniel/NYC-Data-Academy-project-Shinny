library(DT)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(dygraphs)
navbarPage(title='Manhatton Traffic Collision Insight',
           id='nav',
           theme=shinytheme('slate'),
      ###map###
           tabPanel('Hot map',
                    div(class='outer',
                        tags$head(includeCSS('styles.css')),
          leafletOutput(outputId = 'map1',width = '100%',height = '100%'),
          
          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                        top = 80, left = 20, right = 'auto', bottom = "auto",
                        width = 320, height = "auto",
                        h2(""),
                        selectizeInput("weather",
                                       "Weather",
                                       c('all','sunny','rain','snow')),
                        selectizeInput(inputId="cartype",
                                       "Type of Vehicle",
                                       c('all','passenger vehicle','SUV','bicycle','bus','taxi','motorcycle','truck/van')),
                        selectizeInput(inputId="factor",
                                       "Cause of the crash",
                                       c('all','inattention','follow too closely','tired','alcolho'))
                        ),
          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                        top = 'auto', left = 'auto', right = '10', bottom = "20",
                        width = 320, height = "400",
                        
                        h5('In my project, Manhattan is divied by 281 districts. The radius of each circle represents the number(or strength)
                        in corresponding area.'),
                        br(),
                        h6('* For some option combinations, the total number of crashes is small. "Normalized by number" means 
                           the radius represent the relative number of a certain combination of options.'),
                        
                        h6('** VMT(Vehicle Miles Traveled) is a index to represent traffic volume."Normalized by VMT" means the radius represent
                           the relative number of crash per traffic volume. A bigger circle here represent the collision rate is high. For more details about VMT, please see the Reference page.')
                        )
          
                        )),
      ###heatmap###
      tabPanel('Heat map',
               div(class='outer',
                   tags$head(includeCSS('styles.css')),
                   leafletOutput(outputId = 'heatmap',width = '100%',height = '100%'),
                   
                   absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                                 top = 80, left = 20, right = 'auto', bottom = "auto",
                                 width = 320, height = "auto",
                                 
                                 selectizeInput("weather2",
                                                "Weather",
                                                c('all','snow','sunny','rain')),
                                 selectizeInput(inputId="cartype2",
                                                "Type of Vehicle",
                                                c('all','passenger vehicle','SUV','bicycle','bus','taxi','motorcycle','truck/van')),
                                 selectizeInput(inputId="factor2",
                                                "Cause of the crash",
                                                c('all','inattention','follow too closely','tired','alcolho'))
                                 )
                   
               )),
          ###hist###
      tabPanel('Hourly data',
               ####factorpicture###
               fluidRow(
                 column(3,
                        br(),
                        checkboxGroupInput(inputId='factorcheckbox',label = h4("Select Crash Causes"),choices = factorlist)
                 ),
                 
                 column(9,
                        h3(''),
                        plotOutput(outputId = "graph2"))
               ),
               
               ####weatherpicture####
               fluidRow(
                 column(3,
                        br(),
                        checkboxGroupInput(
                          inputId='weathercheckbox',
                          label = h4("Select Weather When Crash Happens"),
                          choices = weatherlist,selected='all')
                        ),
               
                 column(9,
                        h3(''),
                        plotOutput(outputId = "graph1" ))
               ),
               ###vehicletype
               fluidRow(
                 column(3,
                        br(),
                        checkboxGroupInput(
                          inputId='typecheckbox',
                          label = h4("Select Crash Causes"),
                          choices = typelist,selected = 'PASSENGER VEHICLE')
                 ),
                 
                 column(9,
                        h3(''),
                        plotOutput(outputId = "graph3"))
               )
               
               # fluidRow(
               #  box( dygraphOutput('plot1')),
               #  box(
               #    selectizeInput("weather3",
               #                   "Weather",
               #                   c('all','snow','sunny','rain')),
               #    selectizeInput(inputId="cartype3",
               #                   "Type of Vehicle",
               #                   c('all','passenger vehicle','SUV','bicycle','bus','taxi','motorcycle','truck/van')),
               #    selectizeInput(inputId="factor3",
               #                   "Cause of the crash",
               #                   c('all','inattention','follow too closely','tired','alcolho'))
               #  )
               #        
               # )
               ),
      ###reference###
           tabPanel('Reference',
             fluidRow(
               column(3,
                      br(),
                      h4('NYPD Motor
Vehicle Collision data was obtained from NYC Open Data Portal. 
We analysis the 15205 crashes happened in Manhattan in 2016.',a('Link',href='https://opendata.cityofnewyork.us/).')),
                      br(),
                      h4('Weather Data was obtained from Kaggle. ',a('Link',href='www.kaggle.com/meinertsen/nyc-hourly-weather-data/data')),
                      br(),
                      h4('Vehicle Miles Traveled(VMT) data is defined as a measurement of miles traveled by vehicles within a specified region
for a specified time period.It is a traditional
index to represent traffic volume. The geographic information system (GIS) data of VMT was obtained
                         from NYSDOT.',a('Link',href='http://gis.ny.gov/gisdata/'),
                         'The merge of VMT data (in polyline shapefile form) and the crash data is contributed
                         by Di Yang, a PHD Candidate in Department of Civil & Urban Engineering, New York University.')
             ))
           )
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
