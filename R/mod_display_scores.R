# Module UI

#' @title   mod_display_scores_ui and mod_display_scores_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param r cross module variable
#'
#' @rdname mod_display_scores
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
#' @importFrom shinyMobile f7Row f7Col
#' @importFrom ethercalc ec_edit ec_read ec_append
#' @importFrom dplyr select_at mutate_at filter_at arrange_at vars
#' @importFrom readr cols col_character
#' @importFrom shinyjs click hide show enable disable
#' @importFrom utils read.table write.table
mod_display_scores_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$script(
      "$(function() {
      $(.dataTables_info, .paginate_button, .dataTables_length').css('color', 'white');
      });
      "
    ),
    f7Text(inputId = ns("nickname"), label = "Nickname"),
    f7Block(
      class = "swiper-no-swiping",
      strong = TRUE, 
      inset = TRUE, 
      DT::dataTableOutput(ns("score_"))
    ),
    f7Flex(
      f7Button(inputId = ns("save"), label = "Save"),
      f7Button(inputId = ns("refresh"), label = "Refresh scores")
    )
  )
}

# Module Server

#' @rdname mod_display_scores
#' @export
#' @keywords internal

mod_display_scores_server <- function(input, output, session, r){
  ns <- session$ns
  
  score_table <- reactiveValues()
  str <- reactiveValues(warning = " ")
  
  observeEvent(input$refresh, {
    # invalidateLater(100)
    if(golem::get_golem_options("usecase") == "online"){
      score_table$table <- data.frame(
        ec_read(
          room = golem::get_golem_options("ec_room"), 
          ec_host = golem::get_golem_options("ec_host"),
          col_type = readr::cols(
            Nickname = col_character(),
            Difficulty = col_character(),
            Score = col_character(),
            Date = col_character()
          )
        ),
        stringsAsFactors = FALSE
      )
    }
    
    if(golem::get_golem_options("usecase") == "local"){
      score_table$table <- read.table(
        "inst/app/www/scores.txt",
        header = TRUE,
        sep = ";",
        stringsAsFactors = FALSE
      )
    }
    
  })
  
  # click so the table is loaded at the launch of the app and doesn't cause the "ajax problem error" or smthg
  observe({
    shinyjs::click("refresh")
  })
  
  output$score_ <- DT::renderDataTable({
    if(!is.null(score_table$table)){
      score_table$table %>%
        filter_at(vars("Difficulty"), ~ . == r$settings$Level) %>%
        select_at(vars("Date", "Nickname", "Score")) %>%
        mutate_at(vars("Date"), list(~gsub("_", "-", .))) %>%
        arrange_at(vars("Score")) %>%
        DT::datatable(
          rownames = FALSE,
          selection = "none",
          options = list(
            dom = 't',
            columnDefs = list(
              list(className = 'dt-center', targets = 0:2)
            )
          )
        ) %>%
        DT::formatStyle(
          columns = c("Date", "Nickname", "Score"), 
          target = "cell", 
          backgroundColor = "#1b1b1d"
        )
    } else{
      data.frame(Score = "No data available")
    }
  })
  
  # Display the score saving only if the game is won
  observe({
    if(r$mod_grid$playing == "won"){
      shinyjs::show("nickname")
      shinyjs::show("save")
      shinyjs::enable("save")
    }
    if(r$mod_grid$playing == "onload"){
      shinyjs::hide("nickname")
      shinyjs::hide("save")
    }
    if(r$mod_grid$playing == "loose"){
      shinyjs::hide("nickname")
      shinyjs::hide("save")
    }
  })
  
  
  observeEvent(input$save, {
    if(valid_nickname(input$nickname)){
      # insert into base
      shinyjs::disable(id = "save") # avoid several clicks
      
      line <- data.frame(
        Nickname = input$nickname,
        Difficulty = r$settings$Level,
        Score = r$mod_timer$seconds/100,
        Date = paste(
          format(Sys.Date(), "%Y"),
          format(Sys.Date(), "%m"),
          format(Sys.Date(), "%d"), 
          sep = "_"
        ),
        stringsAsFactors = FALSE
      )
      
      if(golem::get_golem_options("usecase") == "online"){
        ec_append(line, 
                  room = golem::get_golem_options("ec_room"),
                  ec_host = golem::get_golem_options("ec_host"))
      }
      if(golem::get_golem_options("usecase") == "local"){
        write.table(
          line,
          file = "inst/app/www/scores.txt",
          append = TRUE,
          quote = FALSE,
          sep = ";",
          row.names = FALSE,
          col.names = FALSE
        )
      }
      # wait to make sure the changes are done
      invalidateLater(1000)
      shinyjs::click(id = "refresh")
    } else {
      # if invalid nickname, display a message saying to enter a valid nickname
      f7Dialog(
        title = "Invalid input!",
        text = "You nickname must be between 2 and 20 alphanumeric characters",
        type = "alert"
      )
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