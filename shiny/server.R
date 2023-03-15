# define server logic
server <- function(input, output) {
    #--------------------------------------------------
    # Search feature
  
    # read data from Excel
    database <- readxl::read_excel("G:/work/horizon_database/data/database.xlsx")
    
    # Filter table based on user input
    filtered <- reactive(
        {
            if(input$search_query != "") {
                # dplyr::filter(stringr::str_detect(tolower(dateset), tolower(input$search_query)) == TRUE)
                stringr::str_detect(tolower(database$dataset), tolower(input$search_query))
                # dplyr::filter(str_detect(tolower(key_words), tolower(input$search_query) == TRUE))
            } else {
                seq(1, nrow(database), by = 1)
            }
        }
    )
    
    # Render table based on filter input
    output$table_filtered <- renderTable(database[filtered(), ])
    
    

}