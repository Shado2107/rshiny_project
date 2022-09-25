library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(readxl)
library(FactoMineR)





#dataset = read.csv("credit.xlsx",header = TRUE, dec = ".", col.names = c("Marche", "Impaye","Endettement","Famille","Profession","Age"), row.names = NULL)


shinyServer(function(input, output, session){
  
  #uploading the excel file
  #dataset = reactive({
   # file <- input$myFile
    #req(file)
    #data <- read_excel(file$datapath)
    #data <- as.data.frame(data)
    # return(data)
  #})
  
  dataset <- reactiveValues(mydata=NULL)
  
  observeEvent(input$myFile,{
    ext <- tools::file_ext(input$myFile$name)
    
    if(ext == "xls" || ext == "xlsw"){
      dataset$mydata <- as.data.frame(readxl::read_excel(input$myFile$datapath)) 
    } else {
      tryCatch({
        dataset$mydata <- read.csv(input$myFile$datapath,
                                   header = input$header,
                                   sep = input$sep,
                                   quote = input$quote)
      }, 
      error = function(e){
        stop(safeError(e))
      })
    }
    dataset$mydata <- na.omit(dataset$mydata)
    dataset$mydata <- dataset$mydata[complete.cases(dataset$mydata),]
  })
  
 

  
  
  output$contents <- DT::renderDataTable({
    DT::datatable(dataset$mydata,
                  rownames = FALSE,
                  width = NULL,
                  height = 50,
                  editable = TRUE,
                  selection = list(mode = "single", selected = c(1), target = 'row'),
                  fillContainer = getOption("DT.fillContainer", TRUE),
                  options = list(
                    lengthMenu = list(c(10, 25, 50,-1), c('10', '25','50' ,'All')),
                    paging = TRUE,
                    lenthChange=TRUE,
                    searching = FALSE,
                    fixedColumns = FALSE,
                    autoWidth = FALSE,
                    ordering = FALSE
                  ),
                  class ='cell-border stripe compact white-space: nowrap',
                  )
      
  })
  
  output$Summary <- renderDataTable({
    summary(dataset$mydata)
  })
  
  
  
  output$donut1 <- renderPlotly({
    newdata2 <- dataset$mydata %>% 
      group_by(Profession) %>%
      summarise(count= n())
    
    return(plot_ly(newdata2, labels = ~Profession, values = ~ count, type = "pie", hole = 0.6,
                   marker = list(colors = c('#635f5f','#3486f9'),line = list(color = '#635f5f', width = 2)))%>%
             
             layout(title = "Profession",  showlegend = T,
                    xaxis = list(showgrid = FALSE, zeroline = FALSE, 
                                 showticklabels = FALSE),
                    yaxis = list(showgrid = FALSE, zeroline = FALSE, 
                                 showticklabels = FALSE)) %>%
             config(displayModeBar = F) %>% layout(xaxis=list(fixedrange=TRUE)) %>% 
             layout(yaxis=list(fixedrange=TRUE)))
  
  })
  
  
  output$donut2 <- renderPlotly({
    newdata3 <- dataset$mydata %>% 
      group_by(Marche) %>%
      summarise(count= n())
    
    return(plot_ly(newdata3, labels = ~Marche, values = ~ count, type = "pie", hole = 0.6,
                   marker = list(colors = c('#635f5f','#3486f9'),line = list(color = '#635f5f', width = 2)))%>%
             layout(title = "Marche",  showlegend = T,
                    xaxis = list(showgrid = FALSE, zeroline = FALSE, 
                                 showticklabels = FALSE),
                    yaxis = list(showgrid = FALSE, zeroline = FALSE, 
                                 showticklabels = FALSE)) %>%
             config(displayModeBar = F) %>% layout(xaxis=list(fixedrange=TRUE)) %>% 
             layout(yaxis=list(fixedrange=TRUE)))
    
  })
  

  output$plot1 <- renderPlot({
   
    
  })
  
  
  
  
  output$hist1 <- renderPlot({
    
    tab.credit=table(dataset$mydata$Impaye,dataset$mydata$Famille)
    tab.credit=as.data.frame(as.matrix(tab.credit))
    credit.afc=CA(tab.credit,graph = FALSE)
    val.prop <- credit.afc$eig
    
    
    barplot(val.prop[,2], names.arg = 1:nrow(val.prop),
            main = "%Variances expliquées par les axes principaux",
            xlab = "Composantes principales",
            ylab = "Pourcentage de variances",
            col ="steelblue")
    lines(x = 1:nrow(val.prop),y = val.prop[,2],type = "b", pch = 15 ,col = "yellow")
    
  })

})