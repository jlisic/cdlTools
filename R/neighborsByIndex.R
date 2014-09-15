neighborsByIndex <-
function(rasterPoints,index,func,...) {

  rasterPoint <- rasterPoints[index,c('x','y')]

  neighbors <- func( rasterPoint, rasterPoints, ...)  

  return( rasterPoints[(rasterPoints[,'x'] %in% neighbors[,'x']) & (rasterPoints[,'y'] %in% neighbors[,'y']),] )

}
