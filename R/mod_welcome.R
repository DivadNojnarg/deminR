# Module UI

#' @title   mod_welcome_ui and mod_welcome_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param r cross module variable
#'
#' @rdname mod_welcome
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
#' @importFrom glouton add_cookie fetch_cookies
mod_welcome_ui <- function(id) {
  ns <- NS(id)

  submitBttn <- f7Button(inputId = ns("login"), label = "Submit")
  submitBttn$attribs$class <- "item-link list-button f7-action-button"
  submitBttn$name <- "a"

  shiny::tags$div(
    id = ns("loginPage"),
    `data-start-open` = "true",
    class = "login-screen",
    shiny::tags$div(
      class = "view",
      shiny::tags$div(
        class = "page",
        shiny::tags$div(
          class = "page-content login-screen-content",
          shiny::tags$div(class = "login-screen-title", "Welcome to deminR"),

          # inputs
          shiny::tags$form(
            shiny::tags$div(
              class = "list", shiny::tags$ul(
                f7Text(
                  inputId = ns("login_user"),
                  label = "",
                  placeholder = "Your name here"
                )
              )
            ),
            shiny::tags$div(
              class = "list",
              shiny::tags$ul(shiny::tags$li(submitBttn)),
              shiny::tags$div(
                class = "block-footer",
                "Made with love :). Disclaimer: we are not responsible if you become
                addicted!"
              )
            )
          )
        )
      )
    )
  )
}

# Module Server

#' @rdname mod_welcome
#' @export
#' @keywords internal
mod_welcome_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # This part only runs if there is no cookie containing her/his name.
    # I used a modified version of glouton by Colin Fay (the original
    # does not work with modules).
    # open the page if not already (in case of local authentication)
    observeEvent(fetch_cookies(),
      {
        r$cookies <- fetch_cookies()
        if (is.null(r$cookies$user)) {
          if (!input$loginPage) updateF7Login(id = "loginPage")
        }
      },
      once = TRUE,
      priority = 10000
    )


    # toggle the login only if not authenticated
    authenticated <- reactiveVal(FALSE)
    observeEvent(input$login, {
      if (!authenticated()) {
        # validate the user login
        if (validate_nickname(input$login_user)) {
          r$cookies$user <- input$login_user
          updateF7Login(
            id = "loginPage",
            user = input$login_user
          )
          authenticated(TRUE)
        } else {
          # if invalid nickname, display a message saying to enter a valid nickname
          f7Dialog(
            title = "Invalid input!",
            text = "You nickname must be between 2 and 20 alphanumeric characters",
            type = "alert"
          )
        }
      }
    })


    # add user to the cookies list
    observeEvent(input$login_user, {
      req(input$login_user)
      add_cookie("user", input$login_user)
    })


    return(reactive(input$loginPage))
  })
}

## To be copied in the UI
# mod_welcome_ui("welcome_ui_1")

## To be copied in the server
# callModule(mod_welcome_server, "welcome_ui_1")
