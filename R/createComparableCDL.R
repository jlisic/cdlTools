#'Create comparable raster images
#'
#'\code{createComparableCDL} uses a base index within a raster list, and sets all other
#' raster images within the list to the same resolution, projection, and extent.  The 
#' raster function resample is used to tranform raster images, therefore this 
#' function may be quite slow without tuning.
#'
#' @param rasterList A list of raster images.
#' @param filenames An array of file names of raster images to coerce into a raster list, 
#'  if \code{rasterList} is not provided.
#' @param baseIndex The index of the raster list element that all other elements will 
#'  match with respect to resolution, projection and extent.
#' @param progress A string for the raster progress bar type, default "" is none, 
#'  "text" provides text output, "window" provides a gui window if available.
#' @return A list of raster images matching in extent, resolution, and projection. 
#' @examples
#' \dontrun{
#' # download multiple years of Iowa Data
#' r <- getCDL('iowa',c(2006,2010))
#' # resample based on the 2006
#' r2 <- createComparableCDL(r,baseIndex=1)
#' }
#' @author Jonathan Lisic, \email{jlisic@@gmail.com}
#' @importFrom raster raster extent xres yres resample 
#' @export
createComparableCDL <-
function( rasterList, filenames,  baseIndex, progress="") {


  # take care of the case where the filenames are provided instead of a rasterlist
  if( !missing(filenames) ) {
    if( length(filenames) < baseIndex ) stop("baseIndex exceeds filenames length")
    rasterList <- list()
    for( i in 1:length(filenames)) {
      rasterList[i] <- raster::raster(filenames[[i]]) 
    }
  } else {
    if( length(rasterList) < baseIndex ) stop("baseIndex exceeds rasterList length")
  }
  
  # now that we have a list of raster files we will use the base index proprties for
  # any possible resampling
  
  base.extent <- raster::extent(rasterList[[baseIndex]])
  base.xres <- raster::xres(rasterList[[baseIndex]])
  base.yres <- raster::yres(rasterList[[baseIndex]])

  rasterList.comparable <- list()

  for( i in 1:length(rasterList) ) {
    if ( 
        ( raster::extent(rasterList[[i]]) != base.extent ) & 
        ( raster::xres(rasterList[[i]])   != base.xres ) & 
        ( raster::yres(rasterList[[i]])   != base.yres )  
       ) {

      # resample
      rasterList.comparable[i] <- raster::resample(
        x=rasterList[[i]], 
        y=rasterList[[baseIndex]], 
        method="ngb",
        progress=progress ) 

    } else {
      rasterList.comparable[i] <- rasterList[[i]]
    }
  }

  return(rasterList.comparable)
}
