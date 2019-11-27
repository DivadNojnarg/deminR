# Module UI
  
#' @title   mod_display_scores_ui and mod_display_scores_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_display_scores
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
#' @importFrom shinyMobile f7Row f7Col
#' @importFrom ethercalc ec_edit ec_read
#' @importFrom dplyr select mutate filter arrange
#' @importFrom readr cols col_character
#' @importFrom shinyjs click
mod_display_scores_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    f7Row(
      f7Col(
        ""
      ),
      f7Col(
        f7Button(inputId = ns("refresh"), label = "Refresh scores")
      ),
      f7Col(
        ""
      )
    ),
    
    
    f7Row(
      f7Col(
        ""
      ),
      f7Col(
        DT::dataTableOutput(ns("score_"))
      ),
      f7Col(
        ""
      )
    ),
  )
}
    
# Module Server
    
#' @rdname mod_display_scores
#' @export
#' @keywords internal
    
mod_display_scores_server <- function(input, output, session, r){
  ns <- session$ns
  
  score_table <- reactiveValues()
  
  observeEvent(input$refresh, {
    invalidateLater(100)
    if(golem::get_golem_options("usecase") == "online"){
      score_table$table <- data.frame(ec_read(room = "v6p3ec82vl5b", ec_host = "https://ethercalc.org",
                                              col_type = readr::cols(
                                                Nickname = col_character(),
                                                Difficulty = col_character(),
                                                Score = col_character(),
                                                Date = col_character()
                                              )),
                                      stringsAsFactors = FALSE)
    }
    
    if(golem::get_golem_options("usecase") == "local"){
      score_table$table <- read.table("inst/app/www/scores.txt",
                                      header = TRUE,
                                      sep = ";",
                                      stringsAsFactors = FALSE)
    }

  })
  
  observe({
    shinyjs::click("refresh")
  })
  
  output$score_ <- DT::renderDataTable({
    if(!is.null(score_table$table)){
      score_table$table %>%
        filter(Difficulty == r$settings$Level) %>%
        select(Date, Nickname, Score) %>%
        mutate(Date = gsub("_", "-", Date)) %>%
        arrange(Score)
    } else{
      data.frame(Score = "No data available")
    }
  })

}
    
## To be copied in the UI
# mod_display_scores_ui("display_scores_ui_1")
    
## To be copied in the server
# callModule(mod_display_scores_server, "display_scores_ui_1")
#  
# library(shiny)
# library(ethercalc)
# library(readr)
# 
# 
# if (interactive()){
#  ui <- fluidPage(
#    mod_display_scores_ui("test")
#  )
#  server <- function(input, output, session) {
#    callModule(mod_display_scores_server, "test")
# 
#  }
#  shinyApp(ui, server)
# }