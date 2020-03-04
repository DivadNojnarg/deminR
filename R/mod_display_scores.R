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
    uiOutput(ns("scoresList"), class = "list"),
    f7Segment(
      container = "row",
      f7Button(inputId = ns("save"), label = "Save")
    ),
    div(
      id = ns("searchbar"),
      f7SearchbarTrigger(targetId = ns("searchScore")),
      f7Searchbar(
        id = ns("searchScore"), 
        expandable = TRUE,
        placeholder = "Search in scores"
      )
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
  
  # Trigger refresh when app start so that score are displayed
  # This event occurs once. Then the user will need to click on
  # the refresh button
  observe({
    if (r$mod_welcome$firstVisit) {
      r$mod_scores$refresh <- TRUE 
      r$mod_welcome$firstVisit <- FALSE
    }
  })
  
  # hide searchbar if input tabs is not score
  observeEvent(r$currentTab$val, {
    shinyjs::toggle(id = "searchbar", condition = (r$currentTab$val == "scores"))
  })
  
  observeEvent(r$mod_scores$refresh, {
    # invalidateLater(100)
    req(r$mod_scores$refresh)
    
    if(golem::get_golem_options("usecase") == "ethercalc"){
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
    
    if(golem::get_golem_options("usecase") == "database"){
      
      # Connect to database
      con <- DBI::dbConnect(
        RPostgres::Postgres(), 
        dbname = golem::get_golem_options("dbname"), 
        host = golem::get_golem_options("dbhost"), 
        port = golem::get_golem_options("dbport"), 
        user = golem::get_golem_options("dbuser"), 
        password = golem::get_golem_options("dbpwd")
      )
      
      # Get the scores
      score_table$table <- DBI::dbReadTable(
        con, 
        name = golem::get_golem_options("table_name")
      ) 
      
      
      # Disconnect from database
      DBI::dbDisconnect(con)
      
    }
    
    
    if(golem::get_golem_options("usecase") == "local"){
      score_table$table <- read.table(
        "inst/app/www/scores.txt",
        header = TRUE,
        sep = ";",
        stringsAsFactors = FALSE
      )
    }
  }, priority = 100)
  
  output$scoresList <- renderUI({
    
    req(score_table$table)
    
    randImgId <- sample(1:9, 1)
    files <- list.files("avatars")
    file <- files[randImgId]
    # prepare data
    scores <- score_table$table %>%
      filter_at(vars("difficulty"), ~ . == r$settings$Level) %>%
      select_at(vars("date", "nickname", "score", "device")) %>%
      mutate_at(vars("date"), list(~gsub("_", "-", .))) %>%
      arrange_at(vars("score"))
    
    # generate list items
    tagList(
      f7BlockTitle(title = "Scores", size = "large"),
      f7List(
        mode = "media",
        inset = TRUE,
        class = "swiper-no-swiping",
        lapply(seq_len(nrow(scores)), function(i) {
          temp <- scores %>% dplyr::slice(i)
          f7ListItem(
            title = temp$nickname,
            subtitle = r$settings$Level,
            footer = temp$device,
            temp$score,
            media = tags$img(src = paste0("avatars", file)),
            right = temp$date
          )
        })
      ) %>% f7Found(),
      f7Block(
        p("Nothing found")
      ) %>% f7NotFound()
    )
  })
  
  # inform user that scores are successfully loaded
  observe({
    req(score_table$table)
    req(r$currentTab$val == "scores")
    req(r$mod_scores$refresh)
    f7Toast(
      session, 
      text = if (r$mod_scores$refresh) {
        "Score successfully updated!"
      } else {
        "Score successfully loaded!"
      },
      position = "bottom",
      closeButtonColor = NULL
    )
    # set refresh back to FALSE so that the parameter module may 
    # change its value again and trigger this observe event!
    r$mod_scores$refresh <- FALSE
  })
  
  # alert if no scores in the table
  observeEvent(score_table$table, {
    if (is.null(score_table$table))
      f7Dialog(
        type = "alert",
        "No score to show!"
      )
  })
  
  # Display the score saving only if the game is won
  observe({
    if(r$mod_grid$playing == "won"){
      f7Dialog(
        type = "prompt",
        inputId = ns("nickname"),
        text = "Enter your nickname"
      )
      shinyjs::show("save")
      shinyjs::enable("save")
    }
    if(r$mod_grid$playing == "onload"){
      shinyjs::hide("save")
    }
    if(r$mod_grid$playing == "loose"){
      shinyjs::hide("save")
    }
  })
  
  observeEvent(input$save, {
    
    if(!is.null(r$cookies$user) & !is.na(r$cookies$user)){
      # insert into base
      shinyjs::disable(id = "save") # avoid several clicks
      
      # gather device info
      deviceDetails <- if (r$device$info$desktop) {
        webBrowser <- if (r$device$info$ie) {
          "ie"
        } else if (r$device$info$edge) {
          "edge"
        } else if (r$device$info$firefox) {
          "firefox"
        }
        if (!is.null(webBrowser)) {
          paste(r$device$info$os, r$device$info$osVersion, webBrowser)
        } else {
          paste(r$device$info$os, r$device$info$osVersion)
        }
      } else {
        if (r$device$info$os == "ios") {
          extraInfos <- if (r$device$info$ipad) {
            "ipad"
          } else if (r$device$info$iphone) {
            "iphone"
          } else if (r$device$info$ipod) {
            "ipod"
          }
          paste(r$device$info$os, r$device$info$osVersion, extraInfos)
        } else {
          paste(r$device$info$os, r$device$info$osVersion)
        }
      }
      
      if (r$device$info$standalone) deviceDetails <- paste(deviceDetails, "PWA")
      
      
      line <- data.frame(
        nickname = r$cookies$user,
        difficulty = r$settings$Level,
        score = r$mod_timer$seconds/100,
        date = paste(
          format(Sys.Date(), "%Y"),
          format(Sys.Date(), "%m"),
          format(Sys.Date(), "%d"), 
          sep = "_"
        ),
        device = deviceDetails,
        stringsAsFactors = FALSE
      )
      
      if(golem::get_golem_options("usecase") == "ethercalc"){
        ec_append(
          line, 
          room = golem::get_golem_options("ec_room"),
          ec_host = golem::get_golem_options("ec_host")
        )
      }
      
      if(golem::get_golem_options("usecase") == "database"){
        # Connect to database
        con <- DBI::dbConnect(
          RPostgres::Postgres(), 
          dbname = golem::get_golem_options("dbname"), 
          host = golem::get_golem_options("dbhost"), 
          port = golem::get_golem_options("dbport"), 
          user = golem::get_golem_options("dbuser"), 
          password = golem::get_golem_options("dbpwd")
        )
        
        # Write the new score
        DBI::dbAppendTable(
          con, 
          name = golem::get_golem_options("table_name"),
          value = line
        )
        
        DBI::dbDisconnect(con)      
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