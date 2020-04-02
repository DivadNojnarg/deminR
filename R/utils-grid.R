#' @title Grid generation
#' @description Several functions to generate the minesweeper grid.
#'
#' @param N size of the grid
#' @param n_mines number of mines
#' @param grid the grid
#' 
#' @export
grid_init <- function(N){
  matrix(data = 0, nrow = N, ncol = N)
}

#' grid_gen_mines
#' 
#' @rdname grid_init
grid_gen_mines <- function(grid, n_mines){
  # radom sample of coordinates for the mines
  mines_coord <- sample(1:nrow(grid)^2, size = n_mines)
  # mined cases get the value -999
  grid[mines_coord] <- -999
  grid
}

#' grid_numbers
#'
#' @rdname grid_init
grid_numbers <- function(grid){
  # add padding to the matrix to avoid problems with borders
  grid.pad <- rbind(NA, cbind(NA, grid, NA), NA)
  ind <- 2:(nrow(grid) + 1) # row/column indices of the "middle"
  # get the neighbours for each case of the matrix
  neigh <- rbind(N  = as.vector(grid.pad[ind - 1, ind    ]),
                 NE = as.vector(grid.pad[ind - 1, ind + 1]),
                 E  = as.vector(grid.pad[ind    , ind + 1]),
                 SE = as.vector(grid.pad[ind + 1, ind + 1]),
                 S  = as.vector(grid.pad[ind + 1, ind    ]),
                 SW = as.vector(grid.pad[ind + 1, ind - 1]),
                 W  = as.vector(grid.pad[ind    , ind - 1]),
                 NW = as.vector(grid.pad[ind - 1, ind - 1]))
  # each mine counts for one
  neigh[neigh == -999] <- 1
  # sum of mines for each coordinate
  neigh <- colSums(neigh, na.rm = TRUE)
  # keep only the coordinates where the number of adjacent mines is > 0 and the case is not a mine 
  index <- which(neigh != 0 & grid!=-999)
  
  # set the number of adjacent mines for each case
  grid[index] <- neigh[index]
  
  grid
}

#' grid_data
#'
#' @rdname grid_init
grid_data <- function(grid, N){
  dt <- data.frame(
    ID=paste0("case-",1:(N*N)),
    value = as.vector(grid),
    hide = TRUE,
    flag = FALSE,
    color = '#0f3a4a',
    fillcolor = '#0f3a4a',
    todisplay = as.vector(grid),  # what should be displayed if clicked
    display = " ", # actual display on the grid
    stringsAsFactors = FALSE)
  
  dt$todisplay[dt$value == -999] = emo::ji("bomb")
  dt$todisplay[dt$value == 0] = " "
  
  dt
}

#' generate_spatial_grid
#'
#' @importFrom sp Polygon Polygons SpatialPolygons SpatialPolygonsDataFrame
#' @importFrom purrr map2
#' @importFrom parallel mclapply
#' 
#' @export
#' @rdname grid_init
generate_spatial_grid <- function(N, n_mines){
  grid <- grid_init(N)
  grid <- grid_gen_mines(grid, n_mines)
  grid <- grid_numbers(grid)
  data <- grid_data(grid, N)
  
  x <- 1:N
  y <- 1:N
  calc <- function(i, j){
    Polygon(cbind(c(i,i+1,i+1,i,i),
                  c(j,j,j+1,j+1,j)))
  }
  combn <- as.data.frame(expand.grid(x,y))
  res <- map2(combn$Var1, combn$Var2, calc)
  
  # Comment this bloc on windows
  res2 <- parallel::mclapply(seq_along(res), function(i){
    Polygons(list(res[[i]]), paste0("case-", i))
  }, mc.cores = detectCores() - 1)
  
  # Comment this block on mac
  # res2 <- lapply(seq_along(res), function(i){
  #   Polygons(list(res[[i]]), paste0("case-", i))
  # })
  
  SpP = SpatialPolygons(res2, seq_along(res2))
  
  SpDf <- SpatialPolygonsDataFrame(
    SpP, 
    data=data,
    match.ID = FALSE)
  SpDf
}


#' Create a list of cases to reveal
#' 
#' This function is used by \link{reveal_onclick}
#'
#' @param res Leaflet data.
#' @param case_id Case to reveal.
#' @param N Grid size.
#'
#' @return List containing cases to reveal.
#' @export
#' @rdname reveal
cases_to_reveal <- function(res, case_id, N) {
  list_to_test <- c(case_id)
  list_to_reveal <- c()
  list_rm_test <- c()

  while (length(list_to_test) > 0) {

    # go through the cases to test
    for (case_id in list_to_test) {

      # if the cases isn't 0, we add it to the list of cases to delete from the test list
      if (res$value[res$ID == case_id] != 0) {
        list_rm_test <- c(list_rm_test, case_id)
      } else {
        #### if the case is 0, we add it to the list of cases to reveal

        list_to_reveal <- c(list_to_reveal, case_id)

        #### we add its neighbour to the test list

        i <- as.numeric(unlist(strsplit(case_id, "-"))[2])

        # 4 angles
        if (i == 1) {
          case_to_reveal <- c(i + 1, i + N, i + N + 1) # bottom left angle
        } else if (i == N) {
          case_to_reveal <- c(i - 1, i + N - 1, i + N) # bottom right angle
        } else if (i == (N * N - N + 1)) {
          case_to_reveal <- c(i + 1, i - N + 1, i - N) # top left angle
        } else if (i == (N * N)) {
          case_to_reveal <- c(i - 1, i - N, i - N - 1) # top right angle
        } else if (i %in% (2:N)) {
          case_to_reveal <- c(i - 1, i + 1, i + N - 1, i + N, i + N + 1) # bottom line
        } else if (i %in% ((N * N - N + 2):(N * N - 1))) {
          case_to_reveal <- c(i - 1, i + 1, i - N + 1, i - N, i - N - 1) # top line
        } else if (i %% N == 0) {
          case_to_reveal <- c(i - 1, i - N - 1, i + N - 1, i - N, i + N) # right column
        } else if (i %% N == 1) {
          case_to_reveal <- c(i + 1, i + N + 1, i - N + 1, i - N, i + N) # left column
        } else { # inside
          case_to_reveal <- c(i + 1, i - 1, i + N + 1, i - N - 1, i + N - 1, i - N + 1, i + N, i - N)
        }

        case_to_reveal <- paste0("case-", case_to_reveal)

        list_to_reveal <- c(list_to_reveal, case_to_reveal)
        list_to_test <- c(list_to_test, case_to_reveal)

        list_rm_test <- c(list_rm_test, case_id)
      }
    }

    list_to_reveal <- unique(list_to_reveal)
    list_to_test <- unique(list_to_test)
    list_rm_test <- unique(list_rm_test)

    list_to_test <- list_to_test[!list_to_test %in% list_rm_test]
  }

  list_to_reveal
}




#' Reveal grid mines
#'
#' @param data Leaflet data.
#' @param case_id Case to reveal.
#' @param N Grid size.
#' @export
#' @rdname reveal
reveal_onclick <- function(data, case_id, N){
  res <- data
  case_to_reveal <- cases_to_reveal(res, case_id, N)
  res$hide[res$ID %in% case_to_reveal] <- FALSE
  res
}
