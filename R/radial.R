radial <-
function(myPoint, myPoints, a.x, a.y) {

  u.x <- myPoint[,1]
  u.y <- myPoint[,2]

  return ( myPoints[sqrt( ( (x - u.x)/a.x )^2 + ( (y - u.y)/a.y )^2 ) <= 1,] ) 

}
