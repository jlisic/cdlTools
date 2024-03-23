#'Get CDL raster data for a bounding box
#'
#'\code{getCDL_bbox} retrieves a CDL raster object within a bounding box for a set of years.
#'
#'@param year A numerical vector. A set of years of CDL data to download.
#'@param bbox An array defining a bounding box of length four.  Defining the two points that form the box by latitude then longitude, in that order.  The furthest north west pair is entered first.
#'@param fileName An optional string indicating where the file should be saved to, default is an R tempfile.
#'@param res An optional array of length two defining the pixel resolution in meters, default is 30m.
#'@param crs An optional string containing the coordinate reference system, default is EPSG:5070 (Albers is EPSG:5070).
#'@param alternativeUrl An optional string containing an alternative url.
#'@param https Legacy https, all traffic uses https, if you need http provide alternative url.
#'@param ssl.verifypeer An optional boolean to turn on and off ssl verfication, default is on.
#'@param returnType An optional parameter to select to return either 'raster' or 'terra' based raster files.
#'@return A raster object containing the contents of a bounding box.
#'@examples
#'\dontrun{
#'# Get data for California in 2020
#'bbox <- c(130783,2203171,153923,2217961)
#'resx <- 30 
#'resy <- 30 
#'year <- 2020
#'crs <- 'epsg:102004'
#'getCDL_bbox(year,bbox,res=c(resx,resy),crs=crs)
#'}
#' @author Jonathan Lisic, \email{jlisic@@gmail.com}
#' @author Jemma Stachelek, \email{stachel2@@msu.edu}
#' @importFrom utils download.file unzip
#' @importFrom raster raster
#' @importFrom terra rast
#' @importFrom httr http_error 
#' @importFrom httr config GET write_disk
#'@export

  
getCDL_bbox <- function(year,bbox,fileName,res,crs='EPSG:5070',https=TRUE,alternativeUrl,ssl.verifypeer = TRUE, returnType = 'raster'){

  if( returnType == 'raster') {
    raster_read = raster::raster
  } else {
    raster_read = terra::rast
  }
  
  # create cropscape URL 
  if(missing(alternativeUrl)) {
    if(https) {
      url <- sprintf("https://nassgeodata.gmu.edu/CropScapeService/wms_cdlall.cgi?service=wcs&version=1.0.0&request=getcoverage&coverage=cdl_%d&crs=%s&bbox=%d,%d,%d,%d&resx=%d&resy=%d&format=gtiff",year,crs,bbox[1],bbox[2],bbox[3],bbox[4],res[1],res[2])
    } else {
      url <- sprintf("https://nassgeodata.gmu.edu/CropScapeService/wms_cdlall.cgi?service=wcs&version=1.0.0&request=getcoverage&coverage=cdl_%d&crs=%s&bbox=%d,%d,%d,%d&resx=%d&resy=%d&format=gtiff",year,crs,bbox[1],bbox[2],bbox[3],bbox[4],res[1],res[2])
    }
  } else {
    url <- sprintf("%s/CropScapeService/wms_cdlall.cgi?service=wcs&version=1.0.0&request=getcoverage&coverage=cdl_%d&crs=%s&bbox=%d,%d,%d,%d&resx=%d&resy=%d&format=gtiff",alternativeUrl,year,crs,bbox[1],bbox[2],bbox[3],bbox[4],res[1],res[2])
  }
    
  # check if URL exists
  if(httr::http_error(url, config = httr::config(ssl_verifypeer = ssl.verifypeer)) ){
    warning( sprintf("%s does not exist, returning NULL.",url) )
    return(NULL)
  }
  
  if(missing(fileName)) {
    fileName <- tempfile(fileext = ".tiff")
  }
    
  httr::GET(url, 
          httr::write_disk(fileName, overwrite = TRUE), 
          config = httr::config(ssl_verifypeer = ssl.verifypeer), httr::progress())
     
  return(raster_read(fileName)) 
}
