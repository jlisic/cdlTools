getCDLURL <-
function( x , years ) {  

  result <- NULL

  # sanity checks
  if( length(years) == 0 ) return( result )

  # check if we have a bounding box 
  if( is.matrix(x) == T) {
    if( ( nrow(x) == ncol(x) ) & (nrow(x) == 2) ) {
      return( getCDLURL.bbox( x, years) ) 
    }
  }

  return( result )
}
