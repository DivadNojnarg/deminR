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



f7Messages <- function (..., id) {
  messagesJS <- shiny::singleton(
    shiny::tags$script(
      paste0("$(function() { 
                var messages = app.messages.create({
                  el: '#", id, "',\n         
                });
                $('.page-content').addClass('messages-content');
              });
             ")
    )
  )
  
  if (inherits(..., "list")) {
    messages <- list(...)
    for (i in seq_along(messages[[1]])) {
      messages[[1]][[i]][[2]]$attribs$class <- paste0(messages[[1]][[i]][[2]]$attribs$class, 
                                                 " message-first message-last message-tail")
    }
  } else {
    messages <- list(...)
    for (i in seq_along(messages)) {
      messages[[i]][[2]]$attribs$class <- paste0(messages[[i]][[2]]$attribs$class, 
                                                 " message-first message-last message-tail")
    }
  }
  
  messagesTag <- shiny::tags$div(class = "messages", messages)
  shiny::tagList(messagesJS, messagesTag)
}