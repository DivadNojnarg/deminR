library(shiny)

r <- reactiveValues(
  mod_scores = reactiveValues(sendToChat = NULL),
  mod_grid = reactiveValues(playing = "onload"),
  cookies = reactiveValues(user = "Toto"),
  mod_timer = reactiveValues(seconds = 0),
  settings = reactiveValues(level = "Intermediate"),
  device = reactiveValues(deviceType = "mobile", info = reactiveValues(os = "windows")),
  click = reactiveValues(counter = 0)
)

context("Share server")


# If no click on the share button, we expect r$mod_scores$sendToChat to be NULL.
# Moreover, initially r$mod_grid$playing is not equal to "won". Therefore, we expect
# output$shareFabs and shareToolbar not to be shown
testModule(mod_share_server, {
  expect_null(r$mod_scores$sendToChat)
  expect_error(print(str(output$shareFabs)))
  expect_error(print(str(output$shareToolbar)))
}, r = r)


# simulate a click on share button -> r$mod_scores$sendToChat should be updated
testModule(mod_share_server, {
  session$setInputs(shareChat = 1)
  expect_equal(r$mod_scores$sendToChat, paste("My score: ", r$mod_timer$seconds))
}, r = r)


# Now we inspect each output individually. We set the game status to won, which is
# the requirement to create outputs
r$mod_grid <- reactiveValues(playing = "won")
testModule(mod_share_server, {
  # check deps
  expect_true(length(output$shareToolbar$deps) > 0)
  
  # this element is composed of $html and $deps
  #expect_length(str(output$shareToolbar), 2)
  # inspect html
  toolbarTag <- html2R(output$shareToolbar$html, prefix = TRUE)
  expect_length(toolbarTag$children[[1]]$children, 2)
  expect_equal(toolbarTag$children[[1]]$children[[1]]$attribs$id, "mock-session-shareChat")
  expect_equal(toolbarTag$children[[1]]$children[[2]]$attribs$onclick, "Shiny.setInputValue(mock-session-shareTwitter, true)")
  
  # check if toolbar margin style is correctly updated based on the current
  # operating system
  r$device$info$os <- "ios"
  session$flushReact()
  toolbarTag <- html2R(output$shareToolbar$html, prefix = TRUE)
  expect_equal(toolbarTag$children[[1]]$attribs$style, "margin-top: 44px;")
}, r = r)