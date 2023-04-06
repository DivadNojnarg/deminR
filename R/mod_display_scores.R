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
#' @importFrom dplyr select_at mutate_at filter_at arrange_at vars
#' @importFrom readr cols col_character
#' @importFrom shinyjs click hide show enable disable
#' @importFrom utils read.table write.table
#' @importFrom lubridate ymd_hms as_datetime
#' @importFrom stats median
mod_display_scores_ui <- function(id){
  ns <- NS(id)
  tagList(
    f7Tab(
      title = "Scores",
      tabName = "Scores",
      icon = f7Icon("list_bullet"),
      active = TRUE,
      f7Block(
        f7Button(
          inputId = ns("scoresOpts"),
          label = "Filter Scores",
          fill = FALSE
        ),
        f7Sheet(
          id = ns("scoresSheetOpts"),
          orientation = "top",
          swipeToClose = TRUE,
          backdrop = TRUE,
          swipeHandler = FALSE,
          f7BlockTitle(title = "Basic filters", size = "large"),
          f7Flex(
            uiOutput(ns("filterDeviceUI")),
            f7Toggle(
              inputId = ns("myScoresOnly"),
              label = "Only me?",
              checked = FALSE
            )
          ),
          f7BlockTitle(title = "Other filters", size = "large"),
          f7Flex(
            f7Toggle(
              inputId = ns("filterClicks"),
              label = "By clicks?",
              checked = FALSE
            ),
            uiOutput(ns("scoresNClicksUI"))
          )
        )
      ),
      uiOutput(ns("scoresList"), class = "list")
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
  
  
  # Open scores options when click on filter
  observeEvent(input$scoresOpts, {
    updateF7Sheet(id = "scoresSheetOpts")
  })
  
  # numeric input to filter by number of clicks
  output$scoresNClicksUI <- renderUI({
    req(input$filterClicks)
    req(scores())
    f7Stepper(
      inputId = ns("scoresNClicks"),
      label = "Cut-off (<=)",
      value = round(median(scores()$clicks)),
      min = round(min(scores()$clicks)),
      max = round(max(scores()$clicks)),
      wraps = TRUE,
      manual = TRUE,
      fill = TRUE
    )
  })
  
  # filter only by devices
  output$filterDeviceUI <- renderUI({
    req(r$device$deviceType)
    f7Toggle(
      inputId = ns("filterDevice"),
      label = paste0("Only ", r$device$deviceType, " ?"),
      checked = TRUE
    )
  })
  
  # Trigger refresh when app start so that score are displayed
  # This event occurs once. Then the user will need to click on
  # the refresh button
  observe({
    if (r$mod_welcome$firstVisit & !r$loginPage$visible) {
      r$mod_scores$refresh <- TRUE 
      f7Toast(
        text = "Scores successfully loaded!",
        position = "center",
        closeButtonColor = NULL
      )
    }
  }, priority = 1000)
  
  # hide searchbar if input tabs is not score
  observeEvent(r$currentTab$val, {
    shinyjs::toggle(id = "searchbar", condition = (r$currentTab$val == "scores"))
  })
  
  observeEvent(r$mod_scores$refresh, {
    # invalidateLater(100)
    req(r$mod_scores$refresh)

    
    if (golem::get_golem_options("usecase") == "database") {
      # Connect to database
      con <- createDBCon()
      # Get the scores
      score_table$table <- DBI::dbReadTable(
        con, 
        name = golem::get_golem_options("table_scores")
      ) 
      
      # Disconnect from database
      DBI::dbDisconnect(con)
    } else if (golem::get_golem_options("usecase") == "local") {
      score_table$table <- read.table(
        "inst/app/www/scores.txt",
        header = TRUE,
        sep = ";",
        stringsAsFactors = FALSE
      )
    }
  }, priority = 100)
  
  
  # scores tibble
  scores <- reactive({
    # prepare data
    score_table$table %>%
      filter_at(vars("difficulty"), ~ . == r$settings$Level) %>%
      select_at(vars("date", "nickname", "score", "device", "clicks")) %>%
      mutate_at(vars("date"), list(~gsub("_", "-", .))) %>%
      arrange_at(vars("score"))
  })
  
  
  # filtered scores by device
  scores_filtered <- reactive({
    
    # at start input$filterDevice needs the modal sheet to be first open
    # to exists. We must ensure this does not trigger error. In the meantime,
    # we cannot set req(input$filterDevice) since scores would never appear at start...
    scores <- if (is.null(input$filterDevice)) {
      scores()
    } else {
      if (input$filterDevice) {
        scores() %>% filter_at(vars("device"), ~ . == r$device$deviceType)
      } else {
        scores()
      }
    }
    
    # filter by name
    if (input$myScoresOnly) {
      scores <- scores %>% filter_at(vars("nickname"), ~ . == r$cookies$user)
    } 
    
    # filter by clicks
    if (input$filterClicks) {
      req(input$scoresNClicks)
      scores <- scores %>% filter_at(vars("clicks"), ~ . <= input$scoresNClicks)
    }
    scores
  })
  

  # List containing all scores
  output$scoresList <- renderUI({

    req(score_table$table)
    scores <- scores_filtered()
    
    # generate list items
    tagList(
      f7List(
        mode = "media",
        inset = TRUE,
        class = "swiper-no-swiping",
        lapply(seq_len(nrow(scores)), function(i) {
          file <- generateAvatar(golem::get_golem_options("avatars"))
          
          temp <- scores %>% dplyr::slice(i)
          
          trophy <- if (i == 1) {
            emo::ji("1st_place_medal")
          } else if (i == 2) {
            emo::ji("2nd_place_medal")
          } else if (i == 3) {
            emo::ji("3rd_place_medal")
          } else if (i == nrow(scores)) {
            emo::ji("hankey")
          } else {
            NULL
          }
          
          items <- f7ListItem(
            header = if (r$warrior$mode) emo::ji("scream") else NULL,
            title = if (!is.null(trophy)) {
              paste0(temp$nickname, ": ", trophy)
            } else {
              temp$nickname
            },
            subtitle = paste("Level: ", r$settings$Level),
            footer = temp$device,
            h1(paste0(temp$score, " (", temp$clicks, " clicks)"), class = "text-color-blue"),
            media = tags$img(src = file),
            right = tags$small(format(lubridate::as_datetime(temp$date), "%B %d %H:%M"))
          )
          
          # user may export their scores by mail
          if (temp$nickname == r$cookies$user) {
            f7Swipeout(
              tag = items,
              side = "left",
              f7SwipeoutItem(
                id = ns("sendToChat"),
                f7Icon("envelope_badge")
              )
            )
          } else {
            items
          }
        })
      ) %>% f7Found(),
      f7Block(
        p("Nothing found")
      ) %>% f7NotFound()
    )
  })
  
  
  # send to chat signal
  observeEvent(input$sendToChat, {
    r$mod_scores$sendToChat <- if(input$sendToChat) {
      input$sendToChat
    } else {
      FALSE
    }
  })
  
  
  # trigger refresh scores 
  observeEvent({
    r$currentTab$val
  },{
    req(r$currentTab$val == "scores")
    r$mod_welcome$firstVisit <- FALSE
    req(r$mod_scores$autoRefresh)
    r$mod_scores$refresh <- TRUE
  })
  
  # inform user that scores are successfully loaded
  observeEvent({
    r$mod_scores$refresh
    req(!r$mod_welcome$firstVisit)
  },{
    req(r$mod_scores$refresh)
    req(nrow(score_table$table) > 0)
    f7Toast(
      session, 
      text = "Scores successfully updated!",
      position = "center",
      closeButtonColor = NULL
    )
    # set refresh back to FALSE so that the parameter module may 
    # change its value again and trigger this observe event!
    r$mod_scores$refresh <- FALSE
  })
  
  # alert if no scores in the table
  observeEvent(score_table$table, {
    if (nrow(score_table$table) == 0)
      f7Dialog(
        type = "alert",
        "No score to show!"
      )
  })
  
  # Feedback when the current score becomes a winner in the 
  # selected category or the worse score ever registered
  observeEvent({
    r$mod_grid$playing
  }, {
    req(r$mod_grid$playing == "won")
    if (r$mod_timer$seconds/100 < min(scores()$score)) {
      f7Dialog(
        type = "alert",
        title = paste("Congratulations", emo::ji("trophy")),
        text = paste("You are the new winner of the", r$settings$Level, "category")
      )
    } else if (r$mod_timer$seconds/100 > max(scores()$score)) {
      f7Dialog(
        type = "alert",
        title = paste("Wowowo", emo::ji("ghost")),
        text = paste("You are the new worse score of the", r$settings$Level, "category")
      )
    }
  })
  
  
  # When the game is won, add new entry in the remote storage
  # either DB or locally, depending on the 
  # golem::get_golem_options("usecase") value.
  observeEvent({
    r$mod_grid$playing
  }, {
    req(r$mod_grid$playing == "won")
    if(!is.null(r$cookies$user) & !is.na(r$cookies$user)){
      # insert into base
      line <- data.frame(
        nickname = r$cookies$user,
        difficulty = r$settings$Level,
        score = r$mod_timer$seconds/100,
        date = lubridate::ymd_hms(Sys.time()),
        device = r$device$deviceType,
        clicks = r$click$counter,
        stringsAsFactors = FALSE
      )

      if (golem::get_golem_options("usecase") == "database") {
        # Connect to database
        con <- createDBCon()
        
        # Write the new score
        DBI::dbAppendTable(
          con, 
          name = golem::get_golem_options("table_scores"),
          value = line
        )
        
        DBI::dbDisconnect(con)      
      } else if (golem::get_golem_options("usecase") == "local") {
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
    }
  })
  
  
  # toggle searchbar when leave the scores tab
  observeEvent(r$currentTab$val, {
    if (r$currentTab$val == "scores") {
      shinyjs::runjs(
        sprintf(
          "$(function() {
          var searchbar = app.searchbar.get('#%s');
          if (searchbar.enabled) {
            searchbar.toggle();
          }
        });
        ",
          ns("searchScore")
        )
      ) 
    }
  })
  
  # send scores to the stat brother module
  return(reactive(score_table$table))
  
}

## To be copied in the UI
# mod_display_scores_ui("display_scores_ui_1")

## To be copied in the server
# callModule(mod_display_scores_server, "display_scores_ui_1")