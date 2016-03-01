# this is a test program 
# assumptions
# m > 0 
# x > 0 or NA
# y > 0 or NA
# m is the max value

matchCount <- function(
  x,
  y,
  m 
  ) {

  require(raster)


  # get the values 
  x.values <- values(x)
  y.values <- values(y)

  # get rid of na
  x.values[is.na(x.values)] <- -1 
  y.values[is.na(y.values)] <- -1 

  x.max <- max(x.values) +1


  # get the number of parcels

  r.result <- .C("rMatchCount",
    as.integer(x.values), 
    as.integer(y.values),
    as.integer( rep(-1, x.max * m )),
    as.integer( rep( 0, x.max * m )),
    as.integer(m),
    as.integer(length(x.values))
  )

  # get matched values
  matched <- r.result[[4]] > 0
  output <- cbind( 
    rep(0:x.max,each=m)[matched],
    r.result[[3]][matched], 
    r.result[[4]][matched]
    )

  return( output ) 
}


if( F ) {
z1 <- matrix( rep(c(1,4),8), nrow=4) 
z2 <- matrix( rep(c(1:4),4), nrow=4) 

r1 <- raster(z1)
r2 <- raster(z2)


a <- matchCount(r1,r2,8)
print(a)
}


