gameInfoUI <- mod_game_info_ui("game_info")

test_that("game info UI global", {
  expect_shinytaglist(gameInfoUI)
  expect_length(gameInfoUI[[1]]$children, 4)
  expect_match(gameInfoUI[[1]]$attribs$class, "row")
  expect_equal(gameInfoUI[[1]]$children[[1]]$attribs$id, "game_info-userName")
  expect_equal(gameInfoUI[[1]]$children[[2]]$attribs$id, "game_info-difficultyBadge")
  expect_equal(gameInfoUI[[1]]$children[[3]]$attribs$id, "game_info-timer")
  expect_equal(gameInfoUI[[1]]$children[[4]]$attribs$id, "game_info-bombs")
})
