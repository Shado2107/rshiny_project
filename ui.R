
library(shiny)
library(shinydashboard)
library(plotly)



marche_options <- c("No Selection", "Renovation", "Voiture","Scooter","Mobilier / Ameublement")
famille_options <- c("No Selection", "Union libre", "Marie","Veuf","Divorce","Celibataire")
professions_options <- c("No Selection", "Ouvrier non qualifie", "Ouvrier qualifie","Retraite","Cadre moyen","Cadre sup")


ui <- dashboardPage(skin = "purple", 
                dashboardHeader(title = "Credit analysis", titleWidth = 250),
                dashboardSidebar( width = 300,
                                  sidebarMenu(style = "position: fixed; width:250px;",
                                              fileInput("myFile",
                                                        "Upload Excel Data:",
                                                        multiple = FALSE,
                                                        accept = c(".xls", ".xslx",".csv")),
                                              
                                              checkboxInput("header", "Header", TRUE),
                                              
                                              radioButtons("sep", "Separator",
                                                           choices = c(Comma = ",",
                                                                       Semicolon = ";",
                                                                       Tab = "\t"),
                                                           selected = ","),
                                              
                                              radioButtons("quote", "Quote",
                                                           choices = c(None = "",
                                                                       "Double Qot." = '"',
                                                                       "Single Qot." = "'"),
                                                           selected = '"'),
                                              
                                              radioButtons("endettement", "Select type endetement:", choices = 
                                                             c("End_1", "End_2", "End_3","End_4")),
          
                                             
                                              selectInput("marche", 
                                                          label = "Marche :",
                                                          choices = c(marche_options), 
                                                          selected = "No Selection")
                                  )
                                  
                ),
                
  dashboardBody(
    fluidRow(
      
      #histogram is being added here
      box(width = 6, plotlyOutput("hist1")),
    
      box(width = 6, plotOutput("plot1")),
      
      #donut chart is being added here
      box(width = 6, plotlyOutput("donut1")),
      
      #donut chart is being added here
      box(width = 6, plotlyOutput("donut2")),
      
      box(width = 12, dataTableOutput("Summary")),
      
      box(width = 12, DT::dataTableOutput("contents"))
      
    ),
   
  )
  )
  
