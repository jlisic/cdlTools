getCensusEdgeData <-
function(states, counties, location) {

  removeFlag <- F

  if( length(states) != length(counties)) {
    print("states and counties do not have same length")
    return(NA)
  }

  # if the location is missing we download from the internet
  if( missing(location) ) {
    
    removeFlag <- T
    urls <- list()
    # multiple connections are available via http, so using http now instead of ftp
    censusFtp <- "http://www2.census.gov/geo/tiger/TIGER2012/EDGES/" 

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
