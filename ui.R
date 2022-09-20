ui <- fluidPage(titlePanel("PRODUITS AUCHAN LES PLUS VENDUS"),
                sidebarLayout(sidebarPanel(
                  fileInput('file1', 'Choisir un fichier excel',
                            accept = c(".xlsx"))
                ),
                mainPanel(tableOutput('file2'))))