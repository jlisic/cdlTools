
movingWindow <- function(x) {
   
  n.subsets <- length(subsets)
  n.win <- length(x) - win + 1
    
  # if there is nothing to do 
  if( n.win < 1 ) { 
    return( -1 )
  }

  result <- c()

  for( j in 1:n.subsets ) {
    inc.sum <- vector(mode="integer",length=n.win)
    
    inc <- x %in% subsets[[j]] 

    inc.sum[1] <- sum( inc[1:win] )

    if( n.win > 1 )  {
      for(k in 2:n.win ) {
        inc.sum[k] <- inc.sum[k-1] - inc[k-1] + inc[k+win -1]
      }
    }
   
    result <- c( result, inc.sum )  
    
  }
  
  return( result )

}

ma1 <- function(x) {
 
  n.subsets <- length(subsets)
    
  result <- c()

  for( j in 1:n.subsets ) {
    inc <- x %in% subsets[[j]] 
    result <- c( result, as.numeric(inc) )  
  }
  
  return( result )

}

