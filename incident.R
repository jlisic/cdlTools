
incident <- function(x) {
   
  n.subsets <- length(subsets)
  n.win <- length(x) - win + 1
    
  # if there is nothing to do 
  if( n.win < 1 ) { 
    return( -1 )
  }

  result <- c()

  for( j in 1:n.subsets ) {
    inc.max <- vector(mode="integer",length=n.win)
    
    inc <- x %in% subsets[[j]] 

    inc.max[1] <- max( inc[1:win] )

    if( n.win > 1 )  {
      for(k in 2:n.win ) {
        inc.max[k] <- max( inc[ k:(win + k - 1) ] ) 
      }
    }
   
    result <- c( result, inc.max )  
  }
  
  return( result )
}

