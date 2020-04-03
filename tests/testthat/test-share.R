r <- reactiveValues(
  mod_scores = reactiveValues(sendToChat = NULL),
  mod_grid = reactiveValues(playing = "onload"),
  cookies = reactiveValues(user = "Toto"),
  mod_timer = reactiveValues(seconds = 0),
  settings = reactiveValues(level = "Intermediate"),
  device = reactiveValues(deviceType = "mobile"),
  click = reactiveValues(counter = 0)
)


# If no click on the share button, we expect r$mod_scores$sendToChat to be NULL
testModule(mod_share_server, {
  expect_null(r$mod_scores$sendToChat)
}, r = r)


# simulate a click on share button -> r$mod_scores$sendToChat should be updated
testModule(mod_share_server, {
  session$setInputs(shareChat = 1)
  expect_equal(r$mod_scores$sendToChat, paste("My score: ", r$mod_timer$seconds))
}, r = r)

