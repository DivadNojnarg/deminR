test_that("display scores UI", {
  # this module is a tagList containing 2 elements
  # [[1]] is a tab item, [[2]] is the searchbar trigger/searchbar tag
  scoresUI <- mod_display_scores_ui("scores_ui")
  expect_shinytaglist(scoresUI)
  expect_length(scoresUI, 2)
})
