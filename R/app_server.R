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
    mod_scores = reactiveValues(refresh = NULL, sendToChat = NULL, autoRefresh = NULL),
    click = reactiveValues(counter = 0),
    currentTab = reactiveValues(val = NULL),
    warrior = reactiveValues(mode = FALSE),
    cookies = reactiveValues(),
    device = reactiveValues(info = NULL),
    loginPage = reactiveValues(visible = TRUE),
    # set to dark by default since at start, the global theme
    # input value does not exist (only when one triggers the switch)
    theme = reactiveValues(color = "dark")
  )

  # hide tabs menu when on message tab
  observeEvent(r$currentTab$val, {
    shinyjs::toggle(selector = ".tabLinks", condition = r$currentTab$val != "chat")
  })

  # when a message is exported from grid to chat
  # switch to the chat tab
  observeEvent(
    {
      r$mod_scores$sendToChat
    },
    {
      req(r$mod_scores$sendToChat)
      f7Dialog(
        id = "goToChat",
        type = "confirm",
        text = "Do you want to go to the
      chat tab to share your score?"
      )
    }
  )

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
    r$device$deviceType <- ifelse(r$device$info$desktop, "desktop", "mobile")
  })

  # welcome module
  login <- mod_welcome_server("welcome_ui_1", r = r)
  observeEvent(
    {
      login()
    },
    {
      shinyjs::delay(10, {
        if (!login()) {
          r$loginPage$visible <- FALSE
        }
      })
    },
    ignoreInit = TRUE
  )
  # set cookies based on authentication layer

  # once cookies are set up, the page content is not hidden
  observeEvent(r$cookies$user, {
    req(r$cookies$user)
    shinyjs::runjs(
      "$(function() {
        $('.view.view-main .page').css('visibility', '');
      });
      "
    )
  })

  ### Help module
  mod_help_server("help_ui_1")
  ### Params
  mod_game_params_server("game_params_ui_1", r = r)
  ### Grid module (count the number of clicks)
  clickOnGrid <- mod_game_grid_server(id = "game_grid_ui_1", r = r)
  observeEvent(clickOnGrid(), {
    r$click$counter <- r$click$counter + 1
  })
  ### Timer module + bomb counter
  mod_game_info_server("game_info_ui_1", r = r)
  ### Score module
  mod_scores_server(id = "scores_ui_1", r = r)
  # share module
  mod_share_server("share_ui_1", r = r)
  # about me module
  mod_about_me_server("about_me_ui_1", r = r)

  # activate chat module only on database mode
  if (golem::get_golem_options("usecase") == "database") {
    # chat module
    mod_chat_server("chat_ui_1", r = r)
  }

  # disable chat if local mode
  observeEvent(req(r$currentTab$val == "chat"),
    {
      if (golem::get_golem_options("usecase") == "local") {
        f7Dialog(
          type = "alert",
          text = "Chat is disabled in local mode"
        )
      }
    },
    once = TRUE
  )
}
