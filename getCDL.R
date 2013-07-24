# This is a program designed to fetch CDL data from the internet
#
# This program makes use of the developer documentation found on the CDL
# website http://nassgeodata.gmu.edu/CropScape/devhelp/help.html
#
# The 'get' operation has two components, the first is to get a url to the
# item of interest from cropscape, the second is to fetch the contents
# of that url.

require("RCurl")
#require("XML")
require("raster")

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

  # create a list to return
  cdl.url.list <- list()

  for( year in years ) {
    # make a CDL request for the bounding box    
    htmlResult <- 
      unlist(
        strsplit( 
          getURL(
            sprintf("http://nassgeodata.gmu.edu:8080/axis2/services/CDLService/GetCDLFile?year=%d&bbox=%f,%f,%f,%f",year,x[1,1],x[2,1],x[1,2],x[2,2])
          )
          ,
        "<(/|)returnURL>"  # regexp to split on
        )
      )

    if( length(htmlResult) != 3 ) {
      targetGeoTif <- NA 
    } else {
      targetGeoTif <- htmlResult[2] 
    }

    # select the value from the html tree that contains the geotif file name 
    #targetGeoTif <- unlist(htmlResult)["children.html.children.body.children.getcdlfileresponse.children.returnurl.children.text.value"]
   
    # change the name associated with the targetGeoTif 
    names(targetGeoTif) <- year 

    # write the raster object into the list
    cdl.url.list[[sprintf("%s",year)]] <- targetGeoTif 

    # parse the html for  

  }

  return(cdl.url.list)

}


# this is a wrapper for download.file from the utils package, it accepts a list of files
download.files <- function( urls , filenames, ...) {
    
  # first see if we need to create temp files, and if so, creat them. 
  if ( missing(filenames) ) {

    filenames <- list()

    for( i in 1:length(urls)) {    
      filenames[[i]] <- tempfile() 
    }

  }

  # check if we have matching urls and filenames
  if( length(urls) != length(filenames) ) {
    stop("urls and filenames lists not of equal length.", call.=FALSE)  
  }

  # create a variable to return with status
  status <- c()

  # download the files
  for( i in 1:length(urls)) {

    # try to download
    status[i] <- tryCatch({ 
      download.file(urls[[i]], destfile=filenames[[i]], ...)
      },
      warning = function(x){
         message(x)
         return(-1)
      },
      error = function(x){
         message(x)
         return(-1)
       },
       finally = {
       })

    if( status[i] == -1 ) {
       # remove the target file if it exists
       unlink( filenames[[i]] )
       filenames[[i]] <- NA
    }

  }

  return( list( urls=urls, filenames=filenames, status=status ) )
}



#This function creates a set of raster images with matching extent and pixel size
createComparableCDL <- function( filenames, rasterList, baseIndex, ... ) {

  # take care of the case where the filenames are provided instead of a rasterlist
  if( !missing(filenames) ) {
    rasterList <- list()
    for( i in 1:length(filenames)) {
      rasterList[i] <- raster(filenames[[i]]) 
    }
  }
  
  # now that we have a list of raster files we will use the base index proprties for
  # any possible resampling
  
  base.extent <- extent(rasterList[[baseIndex]])
  base.xres <- xres(rasterList[[baseIndex]])
  base.yres <- yres(rasterList[[baseIndex]])

  rasterList.comparable <- list()

  for( i in 1:length(rasterList) ) {
    if ( 
        ( extent(rasterList[[i]]) != base.extent ) & 
        ( xres(rasterList[[i]])   != base.xres ) & 
        ( yres(rasterList[[i]])   != base.yres )  
       ) {

      # resample
      rasterList.comparable[i] <- resample(rasterList[[i]], rasterList[[baseIndex]], progress="text" ) 

    } else {
      rasterList.comparable[i] <- rasterList[[i]]
    }
  }

  return(rasterList.comparable)
}



#
radial <- function(myPoint, myPoints, a.x, a.y) {

  u.x <- myPoint[,1]
  u.y <- myPoint[,2]

  return ( myPoints[sqrt( ( (x - u.x)/a.x )^2 + ( (y - u.y)/a.y )^2 ) <= 1,] ) 

}

# 
neighborsByIndex <- function(rasterPoints,index,func,...) {

  rasterPoint <- rasterPoints[index,c('x','y')]

  neighbors <- func( rasterPoint, rasterPoints, ...)  

  return( rasterPoints[(rasterPoints[,'x'] %in% neighbors[,'x']) & (rasterPoints[,'y'] %in% neighbors[,'y']),] )

}





#########################################################################################
# example
#########################################################################################

if(T) {
## get bbox
#      min     max
myBBox <- matrix( c(
       130783, 153923,    # longitude AEA
       2203171, 2217961   # latitude AEA
       ), byrow=T, nrow=2)



## get urls
urlList <- getCDLURL( myBBox, 2000:2004 )

# example output
#
#  $`1996`
#  1996 
#    NA 
#  
#  $`1997`
#  1997 
#    NA 
#  
#  $`1998`
#  1998 
#    NA 
#  
#  $`1999`
#  1999 
#    NA 
#  
#  $`2000`
#                                                                                     2000 
#  "http://nassgeodata.gmu.edu/nass_data_cache/CDL_2000_clip_20130720164503_479136358.tif" 
#  
#  $`2001`
#                                                                                     2001 
#  "http://nassgeodata.gmu.edu/nass_data_cache/CDL_2001_clip_20130720164505_167134732.tif" 
#  
#  $`2002`
#                                                                                      2002 
#  "http://nassgeodata.gmu.edu/nass_data_cache/CDL_2002_clip_20130720164507_1634276841.tif" 
#  
#  $`2003`
#                                                                                      2003 
#  "http://nassgeodata.gmu.edu/nass_data_cache/CDL_2003_clip_20130720164508_1393797597.tif" 
#  
#  $`2004`
#                                                                                      2004 
#  "http://nassgeodata.gmu.edu/nass_data_cache/CDL_2004_clip_20130720164510_1362287265.tif" 

geoTiffs <- download.files(urlList, mode="wb")

# remove missing Tiffs
geoTiffs$urls      <- geoTiffs$urls[geoTiffs$status == 0]
geoTiffs$filenames <- geoTiffs$filenames[geoTiffs$status == 0]
geoTiffs$status    <- geoTiffs$status[geoTiffs$status == 0]




rasterList  <- createComparableCDL( filenames=geoTiffs$filenames, baseIndex=1)
rasterStack <- stack(rasterList)

# turn the raster image into points
rasterPoints <- rasterToPoints(rasterStack)
}








