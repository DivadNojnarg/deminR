valid_nickname <- function(char){
  valid = TRUE
  cond <- c(nchar(char) <= 20,
               nchar(char) >=2,
               grepl("^[a-zA-Z0-9]*$", char))
  if(!all(cond)){
    valid = FALSE
  }
  return(valid)
}