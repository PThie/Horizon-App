#--------------------------------------------------
# load libraries

library(shiny)
library(bslib)
library(particlesjs)
library(shinyjs)

#--------------------------------------------------
# JS code for allowing to hit ENTER for inputs

jscode <- '
$(function() {
  var $els = $("[data-proxy-click]");
  $.each(
    $els,
    function(idx, el) {
      var $el = $(el);
      var $proxy = $("#" + $el.data("proxyClick"));
      $el.keydown(function (e) {
        if (e.keyCode == 13) {
          $proxy.click();
        }
      });
    }
  );
});
'

#--------------------------------------------------
# file locations
# NOTE: Is there a way to make it not rely on the file being existent on my
# local drive?
file_loc <- "G:/work/horizon_database/horizon_app/shiny/www"


#--------------------------------------------------
# define user interface

ui <- fluidPage(
    tags$head(tags$script(HTML(jscode))),
    # add overall styling
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = file.path(file_loc, "mystyling.css"))
    ),
    # add tab title
    title = "Database for Environmental Data",
    fluid = TRUE,
    theme = bslib::bs_theme(bootswatch = "quartz"),
    id = "tabs",
    tabPanel(
        "Home",
        shinyjs::useShinyjs(),
        div(
            class = "container",
            style = "min-height:90%;",
            # define background picture and main title
            div(
                style = "width: 100%; height: 300px; position: relative;z-index:-9;",
                div(
                    id = "particles-target",
                    style = "position: absolute; top: 0; bottom: 0; right: 0; left: 0;"
                ),
                div(
                    p(
                        "Database for Environmental Data",
                        align = "center"
                    ),
                    style = "padding-top:90px; font-size:60px",
                )
            ),
            # particles background picture
            particlesjs::particles(file.path(file_loc, "particles.json"), target_id = "particles-target", element_id =  "particles"),
            # define features
            tabsetPanel(
                type = "hidden",
                #--------------------------------------------------
                # Search feature
                tabPanel(
                    "Search",
                    fluidRow(
                        column(
                            2
                        ),
                        column(
                            6,
                            tagAppendAttributes(
                                textInput(inputId = "search_query", "", width = "100%", placeholder = "Enter you search here"),
                                `data-proxy-click` = "submit"
                            )
                        ),
                        column(
                            1,
                            br(),
                            actionButton(inputId = "submit", label = "Search")
                        ),
                        column(
                            3,
                            br(),
                            actionButton(inputId = "add", label = "Add data")
                        )
                    ),
                    fluidRow(
                        column(
                            2
                        ),
                        column(
                            6,
                            tableOutput(outputId = "table_filtered")
                        )
                    )
                    # fluidRow(
                    #     column(
                    #         12,
                    #         textOutput(outputId = "text")
                    #     )
                    # )
                )
            ),
            hr(),
            print("DISCLAIMER")
        )
    )
)