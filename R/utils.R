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