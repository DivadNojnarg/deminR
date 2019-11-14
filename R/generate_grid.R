#' @title Grid generation
#' @description Several functions to generate the minesweeper grid.
#'
#'
#' @param N size of the grid
#' @param n_mines number of mines
#' @param grid the grid
#' 
#' @export
grid_init <- function(N){
  return(matrix(data = 0, nrow = N, ncol = N))
}

#' grid_gen_mines
#' 
#' 
#' @rdname grid_init
grid_gen_mines <- function(grid, n_mines){
  # radom sample of coordinates for the mines
  mines_coord <- sample(1:nrow(grid)^2, size = n_mines)
  # mined cases get the value -999
  grid[mines_coord] <- -999
  return(grid)
}

#' grid_numbers
#'
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
  
  return(grid)
}

#' grid_data
#'
#' 
#' @rdname grid_init
grid_data <- function(grid, N){
  dt <- data.frame(
    ID=paste0("case-",1:(N*N)),
    value = as.vector(grid),
    hide = TRUE,
    flag = FALSE,
    stringsAsFactors = FALSE)
  dt$display <- sapply(1:(N*N), function(i){
    if(dt$hide[i]){ 
      res = " "
    } else{
      res = dt$value[i]
    }
  })
  return(dt)
}

#' generate_spatial_grid
#'
#' @importFrom sp Polygon Polygons SpatialPolygons SpatialPolygonsDataFrame
#' @importFrom purrr map2
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
  
  res2 <- lapply(1:length(res), function(i){
    Polygons(list(res[[i]]), paste0("case-", i))
  })
  
  SpP = SpatialPolygons(res2, 1:length(res2))
  
  SpDf <- SpatialPolygonsDataFrame(
    SpP, 
    data=data,
    match.ID = FALSE)
  return(SpDf)
}