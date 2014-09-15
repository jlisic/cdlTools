raster.setId <-
function( r ) {
  # get the r extent
  r.extent <- extent(r)
  rx <- raster( r.extent, nrows=nrow(r), ncols=ncol(r) )
  values(rx) <- 1:ncell(rx)
  return(rx)
}
