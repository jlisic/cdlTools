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
#'  match with respect to resolution, projection and extent (default = 1).
#' @param progress A string for the raster progress bar type, default "" is none, 
#'  "text" provides text output, "window" provides a gui window if available.  Not 
#'  available for terra.
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
function( rasterList, filenames,  baseIndex=1, progress="", ...) {
  
  # determine what type of object we are dealing with
  if( class(rasterList[[1]])[1] == 'RasterLayer') {
    type = 'raster'
    raster_resample = function(x,y) raster::resample(x,y, method="ngb", progress=progress,...)  
    raster_raster = raster::raster
    raster_extent = raster::extent
    raster_yres = raster::yres
    raster_xres = raster::xres
  } else {
    type = 'terra'
    raster_resample = function(x,y) terra::resample(x,y, method="near",...)  
    raster_raster = terra::rast
    raster_extent = function(x){return(
      c(terra::xmin(x),terra::xmax(x),terra::ymin(x),terra::ymax(x))
    )}
    raster_yres = terra::yres
    raster_xres = terra::xres
  }
  

  # take care of the case where the filenames are provided instead of a rasterlist
  if( !missing(filenames) ) {
    if( length(filenames) < baseIndex ) stop("baseIndex exceeds filenames length")
    rasterList <- list()
    for( i in 1:length(filenames)) {
      rasterList[i] <- raster_raster(filenames[[i]]) 
    }
  } else {
    if( length(rasterList) < baseIndex ) stop("baseIndex exceeds rasterList length")
  }
  
  # now that we have a list of raster files we will use the base index properties for
  # any possible resampling
  
  base.extent <- raster_extent(rasterList[[baseIndex]])
  base.xres <- raster_xres(rasterList[[baseIndex]])
  base.yres <- raster_yres(rasterList[[baseIndex]])

  rasterList.comparable <- NULL 

  for( i in 1:length(rasterList) ) {
    if ( 
        ( !identical(raster_extent(rasterList[[i]]), base.extent) ) | 
        ( raster_xres(rasterList[[i]])   != base.xres ) | 
        ( raster_yres(rasterList[[i]])   != base.yres )  
       ) {

      # resample
      rasterList.comparable = append( rasterList.comparable,  raster_resample(
        x=rasterList[[i]], 
        y=rasterList[[baseIndex]]
        ))

    } else {
      rasterList.comparable = append( rasterList.comparable, rasterList[[i]])
    }
  }
  
  if( type == 'terra') terra::varnames(rasterList.comparable) = names(rasterList)

  return(rasterList.comparable)
}
