createComparableCDL <-
function( filenames, rasterList, baseIndex, ... ) {

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
