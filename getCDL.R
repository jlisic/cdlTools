# This is a program designed to fetch CDL data from the internet
#
# This program makes use of the developer documentation found on the CDL
# website http://nassgeodata.gmu.edu/CropScape/devhelp/help.html
#
# The 'get' operation has two components, the first is to get a url to the
# item of interest from cropscape, the second is to fetch the contents
# of that url.

library("RCurl")
library("raster")
library("rgdal")

# include cdlVar name handling, a mapping of variable indexes to names, and 
# the default projection for the cdl data
source("~/src/cdlTools/cdlVars.R")


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
          a <- getURL(
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


# get URL function for bbox
getCDLURL.fips <- function(x, years) {

  # create a list to return
  cdl.url.list <- list()

  for( year in years ) {
    # make a CDL request for the bounding box    
    htmlResult <- 
      unlist(
        strsplit( 
          a <- getURL(
            sprintf("http://nassgeodata.gmu.edu:8080/axis2/services/CDLService/GetCDLFile?year=%d&fips=%d",year,x)
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


#find counties
# given a set of points (latitude, longitude) and projection, determine if the points are within a county.
  
  
getStateCounty <- function(userPoints, userProj, countyFile, countyDir) {

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


#fetch census characteristics

# given a list of 
getCensusEdgeData <- function(states, counties, location) {

  removeFlag <- F

  if( length(states) != length(counties)) {
    print("states and counties do not have same length")
    return(NA)
  }

  # if the location is missing we download from the internet
  if( missing(location) ) {
    
    removeFlag <- T
    urls <- list()
    censusFtp <- "ftp://ftp2.census.gov/geo/tiger/TIGER2012/EDGES/" 

    for( i in 1:length(states)) {
      urls[i] <- sprintf("%stl_2012_%02d%03d_edges.zip",censusFtp,states[i],counties[i]) 
    }    
 
    # download the files 
    tiger.zip.files <- download.files( urls ) 
   
    # set the file location    
    location <- tempdir() 

    # unzip and open the files 
    for( i in 1:length(states)) {
      if( tiger.zip.files$status[i] == 0) {
      #unzip the shape file
        unzip(tiger.zip.files$filenames[[i]],exdir=location) 
      #delete the temp file
        unlink(tiger.zip.files$filenames[[i]])
      }
    }
  }

  result <- list()
  # read files
  for( i in 1:length(states)) {
    #read file
    result[i] <- readOGR(location, sprintf("tl_2012_%02d%03d_edges",states[i],counties[i])) 

    if( removeFlag ) {
      unlink( sprintf( "%s/tl_2012_%02d%03d_edges.*",location,states[i],counties[i]) )
    }
  }

  return(result)

}



