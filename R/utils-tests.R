#' @importFrom XML xmlAttrs
#' @importFrom stringr str_detect
makeAttrs <- function(node) {
  attrs <- xmlAttrs(node)
  names(attrs) %>%
    Map(function(name) {
      val <- attrs[[name]]
      if (str_detect(string = name, pattern = "-")) {
        name <- paste0("`", name, "`")
      }
      paste0(name, " = ", if (val == "") "NA" else paste0('"', val, '"'))
    }, .)
}



Keep <- function(fun, xs) Map(fun, xs) %>% Filter(Negate(is.null), .)



#' @importFrom XML xmlName xmlValue xmlChildren
#' @importFrom stringr str_pad
#' @importFrom purrr partial
renderNode <- function(node, indent = 0, prefix = FALSE) {
  if (xmlName(node) == "text") {
    txt <- xmlValue(node)
    if (nchar(trimws(txt)) > 0) {
      paste0('"', trimws(txt), '"')
    }
  } else {
    tagName <- if (prefix) paste0("tags$", xmlName(node)) else xmlName(node)
    newIndent <- indent + length(tagName) + 1
    xmlChildren(node) %>%
      Keep(partial(renderNode, indent = newIndent, prefix = prefix), .) %>%
      append(makeAttrs(node), .) %>%
      paste(collapse = str_pad(",\n", width = newIndent, side = c("right"))) %>%
      trimws(which = c("left")) %>%
      paste0(tagName, "(", ., ")")
  }
}


#' Convert HTML content to R Shiny tags
#'
#' @param htmlStr HTML string
#' @param prefix Whether to prefix elements by tag$...
#'
#' @return A list of R Shiny tags
#' @export
#' @author Alan Dipert, RStudio
#' @importFrom XML htmlParse getNodeSet
html2R <- function(htmlStr, prefix = FALSE) {
  htmlStr %>%
    htmlParse() %>%
    getNodeSet("/html/body/*") %>%
    `[[`(1) %>%
    renderNode(prefix = prefix) %>%
    parse(text = .) %>%
    eval()
}
