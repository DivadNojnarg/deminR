test_that("display scores UI", {
  # this module is a tagList containing 2 elements
  # [[1]] is a tab item, [[2]] is the searchbar trigger/searchbar tag
  scoresUI <- mod_display_scores_ui("scores_ui")
  expect_shinytaglist(scoresUI)
  expect_length(scoresUI, 2)
  
  # inspect each item individually
  searchBarUI <- scoresUI[[2]]
  expect_equal(searchBarUI$attribs$id, "scores_ui-searchbar")
  # [[1]] is searchbar trigger, [[2]] is the searchbar
  expect_length(searchBarUI$children, 2)
  searchBarTriggerUI <- searchBarUI$children[[1]]
  expect_equal(searchBarTriggerUI$attribs$`data-searchbar`, "#scores_ui-searchScore")
  
  # the searchbar tag is composed of a JavaScript part and the HTML part
  searchBarTag <- searchBarUI$children[[2]]
  expect_length(searchBarTag, 2)
  expect_equal(searchBarTag[[1]]$name, "script")
  # the id attributes must match with the data-searchbar of the searchbarTrigger
  expect_equal(searchBarTag[[2]]$attribs$id, "scores_ui-searchScore")
})
