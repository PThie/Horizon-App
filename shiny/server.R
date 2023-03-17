#--------------------------------------------------
# file location
# NOTE: Is there a way to make it not rely on the file being existent on my
# local drive?
file_loc <- "G:/work/horizon_database/horizon_app/shiny/www"

# define server logic
server <- function(input, output) {
    #--------------------------------------------------
    # Search feature
  
    # read data from Excel
    database <- openxlsx::read.xlsx(file.path(file_loc, "database.xlsx"), check.names = FALSE)
    
    # Filter table based on user input
    filtered <- eventReactive(input$submit,
        {
            if(input$search_query != "") {
                # Search in data set title and in key words
                stringr::str_detect(tolower(database$dataset), tolower(input$search_query)) |
                stringr::str_detect(tolower(database$key_words), tolower(input$search_query))
            } else {
                TRUE
            }
        }
    )
    
    # Render table based on filter input
    output$table_filtered <- DT::renderDataTable(datatable(database[filtered(), ], options = list(searching = FALSE)))

    #--------------------------------------------------
    # Adding new data sets
    
    # set up a popup window to enter new information
    # pops up then "add" button is clicked
    added <- observeEvent(
        input$add,
        {
            showModal(
                modalDialog(
                    tags$h2("Add metadata"),
                    # Define meta data fields
                    textInput(inputId = "dataset_name", label = "", placeholder = "Name of the data set"),
                    textInput(inputId = "keywords", label = "", placeholder = "Key words (comma-separated)"),
                    textInput(inputId = "time_range", label = "", placeholder = "Time range"),
                    textInput(inputId = "provider", label = "", placeholder = "Data provider"),
                    # Buttons to submit or cancel input
                    footer = tagList(
                        actionButton(inputId = "ok", label = "Submit"),
                        modalButton("Cancel")
                    ),
                    easyClose = TRUE # allow ESC for closing the pop-up
                )
            )
        }
    )
    
    # grab entered information and store it into summary table
    table <- reactive({
        data.frame(
            `Data set` = input$dataset_name,
            Keywords = input$keywords,
            `Time Range` = input$time_range,
            Provider = input$provider,
            check.names = FALSE # to allow for column names with space
        )
    })
    
    # pop-up window to show the user what was entered
    # wait for confirmation
    observeEvent(
        input$ok,
        {
            # Check if all meta data inputs have been entered
            if (input$dataset_name == "") {
                shinyalert::shinyalert("Please enter a data set name!", type = "error")
            } else if (input$keywords == "") {
                shinyalert::shinyalert("Please enter keywords!", type = "error")
            } else if (input$time_range == "") {
                shinyalert::shinyalert("Please enter specify a time range!", type = "error")
            } else if (input$provider == "") {
                shinyalert::shinyalert("Please enter the data provider!", type = "error")
            } else {
                # Return table when all information is complete
                showModal(
                    modalDialog(
                        tags$h2("Do you want to add the following data set?"),
                        renderTable(table()),
                        footer = tagList(
                            actionButton(inputId = "yes", label = "Yes"),
                            modalButton("No")
                        ),
                        easyClose = TRUE # allow ESC for closing the pop-up
                    )
                )
            }
        }
    )
    
    # DOES NOT WORK YET
    # column names do not match
    new_table <- reactive({rbind(table(), database)})
    
    observeEvent(
        input$yes,
        {
            openxlsx::write.xlsx(new_table(), "new_table.xlsx", append = TRUE, rowNames = FALSE)
        }
    )
    
    

}