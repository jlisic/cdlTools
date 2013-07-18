# This is a program designed to fetch CDL data from the internet
#
# This program makes use of the developer documentation found on the CDL
# website http://nassgeodata.gmu.edu/CropScape/devhelp/help.html
#
# The 'get' operation has two components, the first is to get a url to the
# item of interest from cropscape, the second is to fetch the contents
# of that url.


# returns a list of URLs, one for each year selected
# if the data is not available or does not exist for a given year
# the result is returned as NULL
getCDLURL <- function( x , years ) {  

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


# get URL function for bbox
getCDLURL.bbox <- function(x, years) {

  for( year in years ) {
    # make a CDL request for the bounding box    
    htmlResult <<- url(
      sprintf("http://nassgeodata.gmu.edu:8080/axis2/services/CDLService/GetCDLFile?year=%d&bbox=%f,%f,%f,%f",year,x[1,1],x[2,1],x[1,2],x[2,2]),
      open="r" 
      )
 
    # parse the html for  

  }

}


#########################################################################################
# example
#########################################################################################



#      min     max
myBBox <- matrix( c(
       130783, 153923,    # longitude AEA
       2203171, 2217961   # latitude AEA
       ), byrow=T, nrow=2)




getCDLURL( myBBox, 2009 )


       



