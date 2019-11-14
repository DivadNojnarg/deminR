reveal_zeros <- function(data, case_id){
  
  res <- data
  
  # si 0, on revele les voisins
  if(res$value[res$ID == case_id] == 0){
    res$display[res$ID == case_id] = paste0(res$display[res$ID == case_id], "*")
    # Pour l'instant, on va séparer les différents cas. 
    # TODO : quelque chose de plus propre pour les frontières
    i = as.numeric(unlist(strsplit(case_id, "-"))[2])
    
    # 4 angles
    if(i == 1){ case_to_reveal = c(i+1,i+9,i+10)
    } else if(i==9) {case_to_reveal = c(i-1,i+8,i+9)
    } else if(i == 73){case_to_reveal = c(i+1,i-8,i-9)
    } else if (i == 81){case_to_reveal = c(i-1,i-9,i-10)
    } else if (i %in% 2:8){ case_to_reveal = c(i-1,i+1,i+8,i+9,i+10) # ligne du bas
    } else if (i %in% 74:80){case_to_reveal = c(i-1,i+1,i-8,i-9,i-10) # ligne du haut
    } else if (i %% 9 == 0){case_to_reveal = c(i-1,i-10,i+8,i-9,i+9) # colonne de gauche
    } else if (i %% 9 == 1){case_to_reveal = c(i+1,i+10,i-8,i-9,i+9) # colonne de droite
    } else{ # interieur
      case_to_reveal = c(i+1,i-1,i+10,i-10,i+8,i-8,i+9,i-9)
    }
    
    case_to_reveal = paste0("case-",case_to_reveal)
    
    # res$display[res$ID %in% case_to_reveal] = paste0(res$display[res$ID %in% case_to_reveal], "+")
    
    res$hide[res$ID %in% case_to_reveal] <- FALSE
    # on veut appliquer récursivement aux cases adjacentes
    
    # next_to_reveal
    # for(case in case_to_reveal){
    #   reveal_onclick(res, case)
    # }
    
    
  } 
  
  return(res)
}


cases_to_reveal <- function(res, case_id){
  list_to_test <- c(case_id)
  list_to_reveal <- c()
  list_rm_test <- c()
  
  while(length(list_to_test) > 0){
    
    # on parcourt les cases à tester
    for(case_id in list_to_test){
      
      # si la case ne contient pas 0, on l'ajoute à la liste des cases à supprimer du test
      if(res$value[res$ID == case_id] != 0){
        list_rm_test <- c(list_rm_test, case_id)
      } else {
        #### si la case contient un 0, on l'ajoute à la liste des cases à révéler
        
        list_to_reveal <- c(list_to_reveal, case_id)
        
        #### on ajoute ses voisines à la liste des cases à révéler et à tester
        
        # i = case_id
        i = as.numeric(unlist(strsplit(case_id, "-"))[2])
        
        # 4 angles
        if(i == 1){ case_to_reveal = c(i+1,i+9,i+10)
        } else if(i==9) {case_to_reveal = c(i-1,i+8,i+9)
        } else if(i == 73){case_to_reveal = c(i+1,i-8,i-9)
        } else if (i == 81){case_to_reveal = c(i-1,i-9,i-10)
        } else if (i %in% 2:8){ case_to_reveal = c(i-1,i+1,i+8,i+9,i+10) # ligne du bas
        } else if (i %in% 74:80){case_to_reveal = c(i-1,i+1,i-8,i-9,i-10) # ligne du haut
        } else if (i %% 9 == 0){case_to_reveal = c(i-1,i-10,i+8,i-9,i+9) # colonne de gauche
        } else if (i %% 9 == 1){case_to_reveal = c(i+1,i+10,i-8,i-9,i+9) # colonne de droite
        } else{ # interieur
          case_to_reveal = c(i+1,i-1,i+10,i-10,i+8,i-8,i+9,i-9)
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

reveal_onclick <- function(data, case_id){
  
  res <- data
  case_to_reveal <- cases_to_reveal(res, case_id)
  res$hide[res$ID %in% case_to_reveal] <- FALSE
  return(res)
}
