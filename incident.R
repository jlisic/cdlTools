
incident <- function(x) {
   
  n.subsets <- length(subsets)
  n.win <- length(x) - win + 1

  result <- c()

  for( j in 1:n.subsets ) {
  
    inc.sum <- vector(mode="integer",length=n.win)
    inc <- x %in% subsets[[j]] 
    
    inc.sum[1] <- sum( inc[1:win] )
    for(k in 2:n.win ) inc.sum[k] <- inc.sum[k-1] - inc[k-1] + inc[k+win -1]
   
    result <- c( result, inc.sum )  
    
  }
  
  return( result )

}

