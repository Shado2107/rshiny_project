server <- function(input, output) {
  output$file2 <- renderTable({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    readxl::read_excel(inFile$datapath)
  })
}