#'Get US county edge data
#'
#'Retrieve US county edge data from 2014 Cartographic Boundary Shapefiles - Counties 
#'
#'@param x A character string. county and state names seperated by  ",". For the county, it should be full name. For the state, it can be the two-letter postal abbreviation or the full name. The string is case insensitive.
#'
#'
#'@return county edge data
#'
#'@examples
#'getCensusEdgeData("fairfax county,va")
#'
#'@export
#'
getCensusEdgeData <-
  function(x, location) {
    
    removeFlag <- F
    
    if(length(x) == 0 ) return(NA)
    
    # handle the case of NA
    if(any(is.na(x))) return(NA)
    
    fips<-c()

    # if the location is missing we download from the internet
    if( missing(location) ) {
      fips <- mapply(countyFIPS,x)
      removeFlag <- T
      urls <- list()
      # multiple connections are available via http, so using http now instead of ftp
      censusFtp <- "http://www2.census.gov/geo/tiger/TIGER2014/EDGES/" 
      
      for( i in 1:length(x)) {
        urls[i] <- sprintf("%stl_2014_%s_edges.zip",censusFtp,fips[i]) 
      }
      
      # set the file location    
      location <- tempdir() 
      
      # download the files 
      tiger.zip.files.name <- paste(location, sprintf("tl_2014_%s_edges.zip",fips),sep="/")
      tiger.zip.files <- mapply(download.file, unlist(urls), tiger.zip.files.name) 
  
     for(i in 1:length(x)){
        if( tiger.zip.files[i] == 0) {
          #unzip the shape file
          unzip(tiger.zip.files.name[i],exdir=location) 
          #delete the temp file
          unlink(tiger.zip.files.name[i])
        }
      }
    
    
    result <- list()
    # read files
    for( i in 1:length(x)) {
      #read file
      result[i] <- readOGR(location, sprintf("tl_2014_%s_edges",fips[i])) 
      
      if( removeFlag ) {
        unlink( sprintf( "%s/tl_2014_%s_edges.*",location,fips[i]) )
      }
    }
    
    return(result)
    
  }
  }
