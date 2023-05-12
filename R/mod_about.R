# Module UI

#' @title   mod_about_ui and mod_about_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#'
#' @rdname mod_about
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
mod_about_ui <- function(id) {
  ns <- NS(id)
  tagList(
    f7Panel(
      id = ns("about_panel"),
      title = "About",
      side = "left",
      theme = "dark",
      effect = "cover",
      resizable = FALSE,
      f7Block(
        f7Chip(image = "www/avatars/girl.svg", label = tags$a(href = "https://twitter.com/devauxgabrielle", target = "_blank", "Gabrielle Devaux", class = "external")),
        f7Chip(image = "www/avatars/boy.svg", label = tags$a(href = "https://twitter.com/divadnojnarg", target = "_blank", "David Granjon", class = "external"))
      ),
      f7Link(
        label = "Github",
        href = "https://github.com/DivadNojnarg/deminR",
        icon = f7Icon("ant")
      )
    )
  )
}

# Module Server

#' @rdname mod_about
#' @export
#' @keywords internal

mod_about_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  })
}

## To be copied in the UI
# mod_about_ui("about_ui_1")

## To be copied in the server
# callModule(mod_about_server, "about_ui_1")
