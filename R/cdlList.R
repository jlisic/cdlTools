cdlList <-
function( Dir, years, State, Fips) {
    
  # create a directory if it doesn't exist 
  dir.create( file.path(Dir,sprintf('CDL_%s',State)), showWarnings = FALSE ) 

  #recall we are going from NW to SE.
  #   (startx,starty) ---> x increases in this direction
  #     |
  #     v
  #     y decreases in this direction                        (stopx,stopy)
  
  # create a list of raster objects
  cdl.fileNames <- c()
  for (i in 1:length(years)) {
    year <- years[i]
    cdl.fileName <- sprintf('%sCDL_%s/CDL_%d_%02d.tif',Dir,State,year,Fips) 
    print( paste( "Downloading", cdl.fileName) ) 
    # check if the file exists, if it doesn't download it
    if( !file.exists( cdl.fileName ) ) { 
      download.files(
        getCDLURL.fips(Fips,year),
        list( cdl.fileName )
      ) 
    } 
  
    cdl.fileNames <- c( cdl.fileNames, cdl.fileName )
  }
 
  
  CDLRaster <- list() 
  for (i in 1:length(years)) CDLRaster[i] <- raster(cdl.fileNames)

  return(CDLRaster)
}
