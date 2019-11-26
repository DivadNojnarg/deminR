
cases_to_reveal <- function(res, case_id, N){
  list_to_test <- c(case_id)
  list_to_reveal <- c()
  list_rm_test <- c()
  
  while(length(list_to_test) > 0){
    
    # go through the cases to test
    for(case_id in list_to_test){
      
      # if the cases isn't 0, we add it to the list of cases to delete from the test list
      if(res$value[res$ID == case_id] != 0){
        list_rm_test <- c(list_rm_test, case_id)
      } else {
        #### if the case is 0, we add it to the list of cases to reveal
        
        list_to_reveal <- c(list_to_reveal, case_id)
        
        #### we add its neighbour to the test list
        
        i = as.numeric(unlist(strsplit(case_id, "-"))[2])
        
        # 4 angles
        if(i == 1){ case_to_reveal = c(i+1,i+N,i+N+1) # bottom left angle
        } else if(i==N) {case_to_reveal = c(i-1,i+N-1,i+N) # bottom right angle
        } else if(i == (N*N-N+1)){case_to_reveal = c(i+1,i-N+1,i-N) # top left angle
        } else if (i == (N*N)){case_to_reveal = c(i-1,i-N,i-N-1) # top right angle
        } else if (i %in% (2:N)){ case_to_reveal = c(i-1,i+1,i+N-1,i+N,i+N+1) # bottom line
        } else if (i %in% ((N*N-N+2):(N*N-1))){case_to_reveal = c(i-1,i+1,i-N+1,i-N,i-N-1) # top line
        } else if (i %% N == 0){case_to_reveal = c(i-1,i-N-1,i+N-1,i-N,i+N) # right column
        } else if (i %% N == 1){case_to_reveal = c(i+1,i+N+1,i-N+1,i-N,i+N) # left column
        } else{ # inside
          case_to_reveal = c(i+1,i-1,i+N+1,i-N-1,i+N-1,i-N+1,i+N,i-N)
        }
        
        case_to_reveal = paste0("case-",case_to_reveal)
        
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
  
  return(list_to_reveal)
}

reveal_onclick <- function(data, case_id, N){
  
  res <- data
  case_to_reveal <- cases_to_reveal(res, case_id, N)
  res$hide[res$ID %in% case_to_reveal] <- FALSE
  return(res)
}
