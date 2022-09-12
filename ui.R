
library(shiny)
library(shinydashboard)


ui = dashboardPage( skin= "red",
                    dashboardHeader(title ="Super cool header"),
                    dashboardSidebar(
                      sidebarMenu(
                        #upload file option
                        fileInput("myFile","Upload Excel Data:", accept = ".xlsx"),
                        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                        menuItem("widgets", tabName = "widgets", icon = icon("th"))
                      )
                    ),
                    dashboardBody(
                      fluidRow(
                        # A static valueBox
                        valueBox(10 * 2, "New Orders", icon = icon("credit-card")),
                        
                        # A static valueBox
                        valueBox(10 * 2, "New Orders", icon = icon("credit-card")),
                        
                        # A static valueBox
                        valueBox(10 * 2, "New Orders", icon = icon("credit-card")),
                       
                      )
                      
                    )
  
)

