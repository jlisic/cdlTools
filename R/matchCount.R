#'Counts distinct pixel pairs in CDL raster images
#'
#'\code{matchCount} counts distinct pixel pairs for CDL raster images with 
#'  same extents and resolution.
#'
#'@param x A CDL raster image.
#'@param y A CDL raster image.
#'@param m A bound for the max enumeration of CDL categories.  The default is 256.
#'@return A matrix with pixel counts by unique ordered CDL crop pairs in x and y. 
#'@examples\dontrun{
#'z1 <- matrix( rep(c(1,4),8), nrow=4) 
#'z2 <- matrix( rep(c(1:4),4), nrow=4) 
#'
#'r1 <- raster(z1)
#'r2 <- raster(z2)
#'
#' a <- matchCount(r1,r2)
#' }
#' @author Jonathan Lisic, \email{jlisic@@gmail.com}
#' @importFrom raster raster values
#' @useDynLib cdlTools, .registration = TRUE
#'@export
matchCount <- function(
  x,
  y,
  m=256
  ) {

  # get the values 
  x.values <- values(x)
  y.values <- values(y)

  # get rid of na
  x.values[is.na(x.values)] <- -1 
  y.values[is.na(y.values)] <- -1 

  x.max <- max(x.values) +1


  # get the number of pixels
  r.result <- .C("rMatchCount",
    as.integer(x.values), 
    as.integer(y.values),
    as.integer( rep(-1, x.max * m )),
    as.integer( rep( 0, x.max * m )),
    as.integer(m),
    as.integer(length(x.values)),
    PACKAGE='cdlTools'
  )

  # get matched values
  matched <- r.result[[4]] > 0
  output <- cbind( 
    rep(0:x.max,each=m)[matched],
    r.result[[3]][matched], 
    r.result[[4]][matched]
    )

  colnames(output) <- c( names(x), names(y), 'count')
  
  return( output ) 
}


