#' @import shiny
#' @importFrom shinyMobile f7Dialog
#' @importFrom sever sever
app_server <- function(input, output, session) {
  
  # custom disconnect screen
  sever()
  ### reactiveValues to communicate between all modules
  # 'strategie du petit r'
  r <- reactiveValues(
    mod_grid = reactiveValues(playing = "onload", start = FALSE),
    mod_timer = reactiveValues(),
    mod_bomb = reactiveValues(),
    mod_welcome = reactiveValues(firstVisit = TRUE),
    mod_scores = reactiveValues(refresh = NULL, sendToChat = NULL),
    click = reactiveValues(counter = 0),
    currentTab = reactiveValues(val = NULL),
    warrior = reactiveValues(mode = FALSE),
    cookies = reactiveValues(),
    device = reactiveValues(info = NULL),
    loginPage = reactiveValues(visible = TRUE)
  )
  
  # when a message is exported from grid to chat
  # switch to the chat tab
  observeEvent({
    r$mod_scores$sendToChat
  },{
    req(r$mod_scores$sendToChat)
    f7Dialog(
      inputId = "goToChat",
      type = "confirm",
      text = "Do you want to go to the 
      chat tab to share your score?"
    )
  })
  
  observeEvent(input$goToChat, {
    if (input$goToChat) {
      updateF7Tabs(session, id = "tabset", selected = "chat")
    } else {
      r$mod_scores$sendToChat <- NULL
    }
  })
  
  # needed to get the value of the currently selected tabs
  # between modules
  observe({
    r$currentTab$val <- input$tabset
    r$device$info <- input$deviceInfo
    r$device$deviceType <- ifelse(r$device$info$desktop, "Desktop", "Mobile")
  })
  
  # welcome module
  login <- callModule(mod_welcome_server, "welcome_ui_1", r = r)
  observeEvent({
    login()
  },{
    shinyjs::delay(1000,{
      if (!login()) {
        r$loginPage$visible <- FALSE
      }
    })
  })
  # set cookies based on authentication layer
 
  ### Help module
  callModule(mod_help_server, "help_ui_1")
  ### Params 
  callModule(mod_game_params_server, "game_params_ui_1", r = r)
  ### Grid module (count the number of clicks)
  clickOnGrid <- callModule(mod_game_grid_server, id = "game_grid_ui_1", r = r)
  observeEvent(clickOnGrid(), {
    r$click$counter <- r$click$counter + 1
  })
  ### Timer module + bomb counter
  callModule(mod_game_info_server, "game_info_ui_1", r = r)
  ### Score module
  callModule(mod_display_scores_server, id = "display_scores_ui_1", r = r)
  # share module
  callModule(mod_share_server, "share_ui_1", r = r)
  # chat module
  callModule(mod_chat_server, "chat_ui_1", r = r)
}
