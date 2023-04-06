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

#' Custom framework7 subnavbar
#'
#' @param ... Subnavbar items.
#' @export
f7SubNavbar <- function(...) {
  shiny::tags$div(
    class = "subnavbar",
    shiny::tags$div(
      class = "subnavbar-inner",
      ...
    )
  )
}

#' Validate a nickname provided by the user.
#' 
#' Used by the \link{mod_welcome_server} module
#'
#' @param char Nickname.
#'
#' @return Boolean
#' @export
validate_nickname <- function(char){
  valid <- TRUE
  cond <- c(
    nchar(char) <= 20,
    nchar(char) >=2,
    grepl("^[a-zA-Z0-9]*$", char)
  )
  if (!all(cond)) valid <- FALSE
  valid
}
