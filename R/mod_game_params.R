# Module UI

#' @title   mod_game_params_ui and mod_game_params_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param r cross 
#'
#' @rdname mod_game_params
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_game_params_ui <- function(id){
  ns <- NS(id)
  
  # custom reload button
  reload_bttn <- f7Button(
    inputId = ns("options"), 
    fill = FALSE
  )
  
  reload_bttn[[2]]$name <- "a"
  reload_bttn[[2]]$attribs$type <- NULL
  reload_bttn[[2]]$attribs$class <- "tab-link f7-action-button"
  reload_bttn[[2]]$children <- NULL
  reload_bttn[[2]] <- tagAppendChildren(
    reload_bttn[[2]], 
    f7Icon("hammer", old = FALSE),
    span(class = "tabbar-label", "Options")
  )
  
  sheetTag <- f7Sheet(
    id = ns("game_params_sheet"),
    orientation = "bottom",
    swipeToClose = TRUE,
    swipeToStep = TRUE,
    backdrop = TRUE,
    f7BlockTitle(title = "Game Options", size = "large"),
    f7Radio(
      inputId = ns("level"),
      label = "Choose difficulty",
      choices = difficulty$Level,
      selected = difficulty$Level[1]
    ),
    hiddenItems = tagList(
      f7BlockTitle(title = "Theme", size = "large"),
      tags$div(
        class = "row",
        tags$div(
          class = "col-50 bg-color-white demo-theme-picker",
          f7checkBox(inputId = ns("globalThemeLight"), label = "")
        ),
        tags$div(
          class = "col-50 bg-color-black demo-theme-picker",
          f7checkBox(inputId = ns("globalThemeDark"), label = "", value = TRUE)
        )
      ),
      f7BlockTitle(title = "Are you a warrior?", size = "large"),
      f7Toggle(
        inputId = ns("warrior"),
        label = "Unleash the beast?",
        checked = FALSE
      ),
      tags$div(" ", style = "margin-bottom: 2cm;")
    )
  )
  
  tagList(
    reload_bttn,
    sheetTag,
    tags$script(
      sprintf(
      "Shiny.addCustomMessageHandler('global-theme-setup', function(message) {
        app.methods.setLayoutTheme(message);
        if (message === 'light') {
          $('.panel').removeClass('theme-dark');
          $('.leaflet-container').removeClass('darkleaflet');
          $('#%s').css('background-color', '');
          $('.swipe-handler').css('background-color', '');
          $('.leaflet-container').css('background-color', '#ffffff');
          $('.accordion-item .item-content .item-inner').css('color', 'black');
          $('.accordion-item .accordion-item-content').css('color', 'black');
        } else {
          $('#%s').css('background-color', '#1b1b1d');
          $('.swipe-handler').css('background-color', '#1b1b1d');
          $('.leaflet-container').css('background-color', '#121212');
          $('.accordion-item .item-content .item-inner').css('color', 'white');
          $('.accordion-item .accordion-item-content').css('color', 'white');
        }
      });
      ",
      ns("game_params_sheet"),
      ns("game_params_sheet")
      )
    )
  )
  
}

# Module Server

#' @rdname mod_game_params
#' @export
#' @keywords internal

mod_game_params_server <- function(input, output, session, r){
  ns <- session$ns
  ### The user chooses a difficutlty and it determines several parameters :
  # size of the grid, number of mines, leaflet zoom level
  observe({
    r$settings <- difficulty[difficulty$Level == input$level,]
  })
  
  ### Reset parameters when the user changes the difficulty or clicks on reload button
  observeEvent({
    r$settings
    input$action1_button == 1
    1
  },{
    r$click$counter <- 0 # reset click counter
    r$mod_timer$seconds <- 0 # reset timer
    r$mod_grid$playing <- "onload" # reset current playing status
    r$mod_grid$start  <- FALSE # reset game started
    # generate game grid
    r$mod_grid$data <- generate_spatial_grid(N = r$settings$Size, n_mines = r$settings$Mines)
  })
  
  # handle the case where the user trigger a bomb on first click
  observeEvent({
    r$mod_grid$playing == "loose"
  },{
    if (r$mod_grid$playing == "loose" & r$click$counter == 1) {
      shinyjs::delay(3000, {
        r$click$counter <- 0 # reset click counter
        r$mod_timer$seconds <- 0 # reset timer
        r$mod_grid$playing <- "onload" # reset current playing status
        r$mod_grid$start  <- FALSE # reset game started
        # generate game grid
        r$mod_grid$data <- generate_spatial_grid(N = r$settings$Size, n_mines = r$settings$Mines)
      }) 
    }
  })
  
  
  # sheet trigger. Only works if the timer is 0 (meaning that the game is not running).
  # Change refresh data reactiveValues status to send back to the 
  # display score module. Only run when the game is not launched.
  observeEvent(input$action1_button, {
    req(r$mod_timer$seconds == 0)
    if (input$action1_button == 2) {
      updateF7Sheet(inputId = "game_params_sheet", session = session)
    } else if (input$action1_button == 1) {
      r$mod_scores$refresh <- TRUE
    } else if (input$action1_button == 3) {
      f7Dialog(
        type = "prompt",
        inputId = ns("newNickname"),
        text = "Change nickname"
      )
    }
  })
  
  
  # Manually change user nickname during the game.
  # This will overwrite the cookie...
  observeEvent(input$newNickname, {
    r$cookies$user <- input$newNickname
  })
  
  
  # trigger action sheet when click on options button
  observeEvent(input$options, {
    
    buttons <- if (r$mod_timer$seconds == 0) {
      list(
        list(
          text = "Refresh Data",
          icon = f7Icon("cloud_download", old = FALSE)
        ),
        list(
          text = "Parameters",
          icon = f7Icon("settings_outline", old = TRUE)
        ),
        list(
          text = "Nickname",
          icon = f7Icon("doc_person", old = TRUE)
        )
      )
    } else {
      list(
        list(
          text = "Reset Game",
          icon = f7Icon("refresh_outline", old = TRUE)
        )
      )
    }
    
    # some list may be NULL and we don't want them!
    buttons <- dropNulls(buttons)
    
    sheetProps <- list(grid = TRUE, id = ns("action1"), buttons = buttons)
    do.call(f7ActionSheet, sheetProps)
  })
  
  
  # warrior mode
  observeEvent({
    req(input$warrior)
  }, {
    r$warrior$mode <- TRUE
  })
  
  # global theme (transform checkboxes in radio like)
  observe({
    shinyjs::runjs(
      paste0(
        "$(function(){
        $('.bg-color-white').on('click', function() {
          console.log('light');
          $('#", ns("globalThemeLight"), "').prop('checked', true);
          if ($('#", ns("globalThemeDark"), "').prop('checked')) {
            $('#", ns("globalThemeDark"), "').prop('checked', false);
          }
          $('#", ns("globalThemeDark"), "').addClass('disabled');
          Shiny.setInputValue('", ns("globalTheme"), "', 'light');
        });
        
        $('.bg-color-black').on('click', function() {
          console.log('dark');
          $('#", ns("globalThemeDark"), "').prop('checked', true);
          if ($('#", ns("globalThemeLight"), "').prop('checked')) {
            $('#", ns("globalThemeLight"), "').prop('checked', false);
          }
          $('#", ns("globalThemeLight"), "').addClass('disabled');
          Shiny.setInputValue('", ns("globalTheme"), "', 'dark');
        });
      });
      "
      )
    )
  })

  
  # send R values to JS for global theme setting
  observe({
    session$sendCustomMessage(
      type = "global-theme-setup",
      message = input$globalTheme
    )
  })
  
}

## To be copied in the UI
# mod_game_params_ui("game_params_ui_1")

## To be copied in the server
# callModule(mod_game_params_server, "game_params_ui_1")

