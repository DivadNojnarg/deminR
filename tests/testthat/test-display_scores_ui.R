context("Display scores UI")


# this module is a tagList containing 2 elements
# [[1]] is a tab item, [[2]] is the searchbar trigger/searchbar tag
scoresUI <- mod_display_scores_ui("scores_ui")

test_that("display scores UI global", {
  expect_shinytaglist(scoresUI)
  expect_length(scoresUI, 2)
})


tabScoresUI <- scoresUI[[1]]
tabScoresContentUI <- tabScoresUI[[1]]
test_that("scores UI Tab content", {
  # inspect the tab content
  expect_length(tabScoresUI, 4)
  expect_shinytag(tabScoresContentUI)
  expect_equal(tabScoresContentUI$attribs$id, "Scores")
  expect_length(tabScoresContentUI$children, 2)
  # f7List output
  expect_equal(tabScoresContentUI$children[[2]]$attribs$id, "scores_ui-scoresList")
  expect_equal(tabScoresContentUI$children[[2]]$attribs$class, "shiny-html-output")
})


test_that("scores UI Tab sheet", {
  # inspect the tab content
  sheetUI <- tabScoresContentUI$children[[1]]$children
  expect_length(sheetUI, 2)
  # sheet trigger
  expect_equal(sheetUI[[1]][[2]]$name, "button")
  expect_equal(sheetUI[[1]][[2]]$attribs$id, "scores_ui-scoresOpts")
  
  # sheet content
  sheetTag <- sheetUI[[2]]
  # [[1]] is ths JS binding, [[2]] is the CSS, [[3]] is the HTML content
  expect_length(sheetTag, 2)
  expect_is(sheetTag[[1]], "html_dependency")
  expect_equal(sheetTag[[2]]$attribs$id, "scores_ui-scoresSheetOpts")
})


test_that("scores UI searchbar", {
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
