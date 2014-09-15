cdl.updateNames.data.frame <-
function( x ) {
  newNames <- cdl.updateNames(as.numeric(names(x ) ))
  names(x) <- newNames
  return(x)
}
