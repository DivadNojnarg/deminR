dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE = logical(1))]
}



#' Toggle login page
#'
#' @param id \link{f7Login} unique id.
#' @param user Value of the user input.
#' @param session Shiny session object.
#' @export
#' @rdname authentication
updateF7Login <- function(id, user = NULL, session = shiny::getDefaultReactiveDomain()) {
  message <- dropNulls(list(user = user))
  session$sendInputMessage(id, message)
}



#' Create connection to a Postgres database.
#' 
#' Parameters are extracted from Golem options
#' which is convenient to keep credentials secrets
#' @export
createDBCon <- function() {
  DBI::dbConnect(
    RPostgres::Postgres(), 
    dbname = golem::get_golem_options("dbname"), 
    host = golem::get_golem_options("dbhost"), 
    port = golem::get_golem_options("dbport"), 
    user = golem::get_golem_options("dbuser"), 
    password = golem::get_golem_options("dbpwd")
  )
}



#' Generate a random avatar image
#'
#' @param avatars List of avatars.
#' @export
generateAvatar <- function(avatars) {
  n <- length(avatars)
  randImgId <- sample(1:n, 1)
  paste0("www/avatars/", avatars[randImgId])
}


#' Create a Framework7 page with tab layout
#'
#' Build a Framework7 page with tab layout
#'
#' @param ... Slot for \link{f7Tabs}.
#' @param navbar Slot for \link{f7Navbar}.
#' @param messagebar Slot for \link{f7MessageBar}.
#' @param panels Slot for \link{f7Panel}.
#' Wrap in \link[shiny]{tagList} if multiple panels.
#' @param appbar Slot for \link{f7Appbar}.
f7TabLayout <- function (..., navbar, messagebar = NULL, panels = NULL, appbar = NULL) {
  shiny::tagList(
    appbar, 
    panels, 
    shiny::tags$div(
      class = "view view-main", 
      messagebar,
      shiny::tags$div(class = "page", navbar, ...)
    )
  )
}