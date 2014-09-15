getStateCounty <-
function(userPoints, userProj, countyFile, countyDir) {

  require('prevR') # I should remove this dependency
  
  # read in the county shape file
  countyShape <- readOGR(countyDir, countyFile)
  
  # re project the county shape file
  countyShape.proj <- spTransform(countyShape, CRS(userProj))
  
  # get the county centroids
  centroid.county <- coordinates(countyShape.proj)
  
  # find the counties closest to our points for efficent processing
  xBar <- mean(userPoints[,'x'])
  yBar <- mean(userPoints[,'y'])
  
  countyOrder <- sort( ( centroid.county[,1] - xBar )^2 + (centroid.county[,2] - yBar )^2, index.return=T)$ix 
  
  # not iteratively check how many points each county contains
  # terminate when all points are assigned to counties
  
  # create assignment data set
  assignment <- vector(mode='numeric', length=nrow(userPoints) )
  
  for( i in 1:nrow(countyShape) ) {
  
    countyIndex <- countyOrder[i]
    countyPolygon <- countyShape.proj[countyIndex,]
    assignment[ point.in.SpatialPolygons(userPoints[,'x'], userPoints[,'y'], countyPolygon) ] <- countyIndex
  
    if( is.na(table(assignment)['0']) ) break 
  }
  
  # get the unique assignments 
  targetCounties <- unique( assignment ) 
  
  # check if there are any points that haven't been assigned to counties
  if( 0 %in% targetCounties  ) print("Not all points assigned to counties") 

  return( as.data.frame(countyShape)[targetCounties,] )
}
