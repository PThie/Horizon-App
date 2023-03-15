# define server logic
server <- function(input, output) {
    #--------------------------------------------------
    # Search feature
  
    # read data from Excel
    database <- readxl::read_excel("G:/work/horizon_database/data/database.xlsx")
    
    # Filter data based on user input
    # filtered <- reactive(
    #     if(input$show_all == TRUE) {
    #         database
    #     }
    #     database |>
    #         dplyr::filter(key_words == input$search_query)
    # 
    # )
    
    # Show complete table if switch "Show all data" is ON
    complete_table <- reactive(
        {
            if(input$show_all == TRUE){
                database
            }
        }
    )
    
    # Ask for filtering if switch "Show all data" is OFF
    prompt_for_search <- reactive(
        {
            if(input$show_all == FALSE){
                print("Please enter a search value")
            }
        }
    )
    
    # reactive({print(input$search_query)})
    
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
    output$table_complete <- renderTable(complete_table())
    output$search_prompt <- renderText(prompt_for_search())
    output$table_filtered <- renderTable(database[filtered(), ])
    
    

}