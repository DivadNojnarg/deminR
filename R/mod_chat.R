# Module UI

#' @title   mod_chat_ui and mod_chat_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param r cross module variable
#'
#' @rdname mod_chat
#'
#' @keywords internal
#' @export
#' @import dplyr
#' @importFrom tibble as_tibble
#' @importFrom shiny NS tagList
#' @importFrom utils tail
#' @importFrom lubridate as_datetime
mod_chat_ui <- function(id) {
  ns <- NS(id)
  tagList(
    f7Messages(id = ns("mymessages"), title = "Chat Room"),
    f7MessageBar(inputId = ns("mymessagebar"), placeholder = "Message")
  )
}

# Module Server

#' @rdname mod_chat
#' @export
#' @keywords internal
mod_chat_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    messages_table <- reactiveValues()
    firstConnect <- reactiveVal(TRUE)

    # only display message bar when the tab is chat
    observeEvent(r$currentTab$val, {
      shinyjs::toggle(id = "mymessagebar", condition = r$currentTab$val == "chat")
    })

    # load messages first
    observe(
      {
        # load all messages
        if (firstConnect()) {
          req(r$cookies$user)
          con <- createDBCon()

          # Get the messages
          messages_table$table <- DBI::dbReadTable(con, name = golem::get_golem_options("table_message"))
          messages <- lapply(seq_len(nrow(messages_table$table)), function(i) { # comment this line on windows
            # messages <- lapply(seq_len(nrow(messages_table$table)), function(i) { # comment this line on mac
            temp_message <- messages_table$table %>% slice(i)

            f7Message(
              text = temp_message$message,
              header = temp_message$date,
              name = temp_message$nickname,
              type = if (r$cookies$user == temp_message$nickname) {
                "sent"
              } else {
                "received"
              },
              avatar = "https://cdn.framework7.io/placeholder/people-100x100-9.jpg"
            )
          })

          updateF7Messages(id = "mymessages", messages)

          firstConnect(FALSE)
          # Disconnect from database
          DBI::dbDisconnect(con)
        }
      },
      priority = 999
    )



    # get update by other people
    observeEvent(r$currentTab$val, {
      req(!firstConnect())
      req(r$currentTab$val == "chat")
      con <- createDBCon()

      # select only the last message
      messages <- DBI::dbReadTable(con, name = golem::get_golem_options("table_message"))
      new_lines <- nrow(messages) - nrow(messages_table$table)
      if (new_lines > 0) {
        new_messages <- messages %>%
          slice(tail(row_number(), new_lines))
        new_messages <- lapply(seq_len(nrow(new_messages)), function(i) {
          temp_message <- new_messages %>% slice(i)
          f7Message(
            text = temp_message$message,
            header = temp_message$date,
            name = temp_message$nickname,
            type = if (r$cookies$user == temp_message$nickname) {
              "sent"
            } else {
              "received"
            },
            avatar = "https://cdn.framework7.io/placeholder/people-100x100-9.jpg"
          )
        })
        updateF7Messages(id = "mymessages", new_messages)
        messages_table$table <- messages
      }
      DBI::dbDisconnect(con)
    })



    # send message part
    observeEvent(input[["mymessagebar-send"]], {
      message_to_send <- f7Message(
        text = input$mymessagebar,
        name = r$cookies$user,
        type = "sent",
        header = format(lubridate::as_datetime(Sys.time()), "%B %d %H:%M"),
        avatar = "https://cdn.framework7.io/placeholder/people-100x100-9.jpg"
      )

      f7AddMessages(id = "mymessages", list(message_to_send))

      con <- createDBCon()

      # Convert to tibble to tidy data
      # DB column names are different
      # We need to do some cleaning
      message_to_send <- message_to_send %>%
        as_tibble() %>%
        select("name", "text", "header") %>%
        rename(nickname = "name", message = "text", date = "header")

      DBI::dbAppendTable(
        con,
        golem::get_golem_options("table_message"),
        value = message_to_send
      )
      messages_table$table <- DBI::dbReadTable(con, name = golem::get_golem_options("table_message"))
      DBI::dbDisconnect(con)
    })


    # update message bar if a score is exported in the grid module
    observeEvent(
      {
        r$mod_scores$sendToChat
      },
      {
        req(r$mod_scores$sendToChat)
        updateF7MessageBar(inputId = "mymessagebar", value = r$mod_scores$sendToChat)
      }
    )
  })
}

## To be copied in the UI
# mod_chat_ui("chat_ui_1")

## To be copied in the server
# callModule(mod_chat_server, "chat_ui_1")
