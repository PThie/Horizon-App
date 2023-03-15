ui <- navbarPage(
    title = "Database for Environmental Data",
    fluid = TRUE,
    theme = shinythemes::shinytheme("paper"),
    # tabPanel(
    #     "Home"
    #     # shinyjs::useShinyjs(),
    #     # div(
    #     #     class = "container",
    #     #     style = "min-height:90vh;"
    #     # )
    # ),
    tabPanel(
        "Data base",
        tabsetPanel(
            type = "tabs",
            #--------------------------------------------------
            # Search feature
            tabPanel(
                "Search",
                fluidRow(
                    column(
                        6,
                        textInput(inputId = "search_query", "", width = "100%", placeholder = "Enter you search here")
                    ),
                    column(
                        1,
                        br(),
                        actionButton(inputId = "submit", label = "Search")
                    ),
                    column(
                        3,
                        br(),
                        shinyWidgets::materialSwitch(inputId = "show_all", label = "Show all data", value = TRUE, status = "success")
                    )
                ),
                fluidRow(
                    column(
                        6,
                        tableOutput("table_complete")
                    )
                ),
                fluidRow(
                    column(
                        6,
                        textOutput("search_prompt")
                    )
                ),
                fluidPage(
                    tableOutput("table_filtered")
                )
            ),
            #--------------------------------------------------
            # Adding new data sets
            tabPanel(
                "Add new data set",
                fluidRow(
                    column(
                        5,
                        textInput(
                            inputId = "text",
                            label = "TESTS",
                            width = "100%",
                            placeholder = "Test"
                        )
                    )
                )
            )
        )
    )
    
    "TEST"
)