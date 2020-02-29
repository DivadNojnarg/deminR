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
