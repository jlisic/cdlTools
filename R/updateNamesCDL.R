#'Label CDL classes.
#'
#'\code{updateNamesCDL} converts numeric CDL categories to class labels.
#'
#'@param y A numeric array of integers associated with CDL categories.
#'@return An array of strings labeling each CDL class.  If the CDL class is 
#'  unspecified then the original integer is returned.
#'@examples
#'updateNamesCDL(0:255)
#' @author Jonathan Lisic, \email{jlisic@@gmail.com}
#' @importFrom utils data 
#'@export
updateNamesCDL <-
function( y ) {
 
  return(
    unlist(lapply(y, function(x) { 
                  if( as.character(x) %in% cdlTools::varNamesCDL) {
                    return(cdlTools::varNamesCDL[ which(as.character(x)==cdlTools::varNamesCDL)+1 ])
                  } else {
                    return(as.character(x))
                  }
    }))
  )
}
