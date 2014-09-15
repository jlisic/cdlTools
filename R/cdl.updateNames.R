cdl.updateNames <-
function( y ) {
  return(
    unlist(lapply(y, function(x) { 
                  if( as.character(x) %in% cdl.varNames) {
                    return(cdl.varNames[ which(as.character(x)==cdl.varNames)+1 ])
                  } else {
                    return(as.character(x))
                  }
    }))
  )
}
