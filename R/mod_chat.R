# Module UI

#' @title   mod_chat_ui and mod_chat_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param r cross module variable
#'
#' @rdname mod_chat
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
#' @importFrom dplyr slice
mod_chat_ui <- function(id){
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("chat")),
    f7Row(
      f7Col(
        f7Text(ns("message"), "My message")
      ),
      f7Col(
        f7Button(ns("sendMessage"), "Send")
      )
    )
  )
}

# Module Server

#' @rdname mod_chat
#' @export
#' @keywords internal

mod_chat_server <- function(input, output, session, r){
  ns <- session$ns
  
  # validate message input
  observe({
    f7ValidateInput(
      inputId = ns("message"),
      error = "Message cannot be empty!"
    )
  })
  
  # disable submit button if message content is ""
  observe({
    shinyjs::toggleState(
      id = "sendMessage", 
      condition = nchar(input$message)  > 0
    )
  })
  
  messages_table <- reactiveValues()
  
  # load the messages table
  observe({
    if (r$mod_welcome$firstVisit) {
      con <- DBI::dbConnect(
        RPostgres::Postgres(), 
        dbname = golem::get_golem_options("dbname"), 
        host = golem::get_golem_options("dbhost"), 
        port = golem::get_golem_options("dbport"), 
        user = golem::get_golem_options("dbuser"), 
        password = golem::get_golem_options("dbpwd")
      )
      
      # Get the scores
      messages_table$table <- DBI::dbReadTable(con, name = "messages") 
      # Disconnect from database
      DBI::dbDisconnect(con) 
    }
  }, priority = 999)
  
  
  observeEvent(input$sendMessage, {
    newMessage <- data.frame(
      nickname = r$cookies$user,
      message = input$message,
      date = lubridate::ymd_hms(Sys.time()),
      stringsAsFactors = FALSE
    )
    
    con <- DBI::dbConnect(
      RPostgres::Postgres(), 
      dbname = golem::get_golem_options("dbname"), 
      host = golem::get_golem_options("dbhost"), 
      port = golem::get_golem_options("dbport"), 
      user = golem::get_golem_options("dbuser"), 
      password = golem::get_golem_options("dbpwd")
    )
    
    # Write the new score
    DBI::dbAppendTable(con, name = "messages", value = newMessage)
    
    # Get the scores
    messages_table$table <- DBI::dbReadTable(con, name = "messages") 
    DBI::dbDisconnect(con) 
  })
  
  messagesTag <- reactive({
    req(messages_table$table)
    req(r$cookies$user)
    lapply(seq_len(nrow(messages_table$table)), function(i) {
      
      temp <- messages_table$table %>% slice(i)
      
      f7Message(
        state = if (temp$nickname != r$cookies$user) "received" else "sent",
        type = "text",
        author = temp$nickname,
        date = temp$date,
        temp$message,
        # below is a placeholder
        src = "https://cdn.framework7.io/placeholder/people-100x100-9.jpg"
      )
    })
  })
  
  # create chat items 
  output$chat <- renderUI({
    invalidateLater(5000)
    f7Messages(id = "messagelist", messagesTag())
  })
  
}

## To be copied in the UI
# mod_chat_ui("chat_ui_1")

## To be copied in the server
# callModule(mod_chat_server, "chat_ui_1")

