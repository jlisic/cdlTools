#'Get CDL raster data
#'
#'\code{getCDL} retrieves CDL state raster objects for a set of years.
#'
#'@param x Is either a two digit state FIPS code, a two letter abbreviation, or
#'  a state name.
#'@param year A numerical vector. A set of years of CDL data to download.
#'@param alternativeUrl An optional string containing an alternative url.
#'@param location An optional string containing a folder to store the file.  If no folder is given, the R temporary directory will be used.
#'@param https Legacy https flag, all traffic uses https, if you need http provide alternative url.
#'@param ssl.verifypeer An optional boolean to turn on and off ssl verfication, default is on.
#'@param returnType An optional parameter to select to return either 'raster' or 'terra' based raster files.
#'@return A list of CDL raster objects of interested county for a set of years.  Note that this is a generic list allowing for rasters with different extents and resolutions. 
#'@examples
#'\dontrun{
#'# Get data for California, 2013 and 2015
#'# by FIPS
#'getCDL(6,c(2013,2015))
#'# Get data for California, 2013 and 2015 with Terra
#'getCDL("California",c(2013,2015), returnType='terra')
#'# Get all the west coast from 2009 to 2016
#'getCDL(c("CA","OR","WA"),2013:2016)
#'}
#' @author Jonathan Lisic, \email{jlisic@@gmail.com}
#' @author Jemma Stachelek, \email{stachel2@@msu.edu}
#' @importFrom utils download.file unzip
#' @importFrom raster raster
#' @importFrom terra rast
#' @importFrom httr http_error 
#' @importFrom httr config GET write_disk
#'@export
getCDL <- function(x,year,alternativeUrl,location=tempdir(),https=TRUE, ssl.verifypeer = TRUE, returnType = 'raster'){

  if( returnType == 'raster') {
    raster_read = raster::raster
  } else {
    raster_read = terra::rast
  }
  
  cdl.list <- list()
  names.array <- c()
 
  x <- fips(x)
  cdl_years <- year # fix but can't change due to legacy

  for( i in 1:length(x) ) {
    if( is.na(x[i]) ) next 

    for(cdl_year in cdl_years){
      out_target <- paste(location, 
                          sprintf("CDL_%d_%02d.tif", 
                                  cdl_year, x[i]), sep = "/")
      if(file.exists(out_target)){
        target   <- raster_read(out_target)
        if( length(cdl.list) == 0 ) {
          cdl.list = list(target) 
        } else {
          cdl.list[[length(cdl.list) + 1]] = target 
        }
        next
      }
      # create cropscape URL 
      if(missing(alternativeUrl)) {
          if(https) {
            url <- sprintf("https://nassgeodata.gmu.edu/cdlservicedata/nass_data_cache/byfips/CDL_%d_%02d.zip",cdl_year,x[i]) 
          } else {
            url <- sprintf("https://nassgeodata.gmu.edu/cdlservicedata/nass_data_cache/byfips/CDL_%d_%02d.zip",cdl_year,x[i]) 
          }
      } else {
        url <- paste(alternativeUrl,sprintf("CDL_%d_%02d.tif",cdl_year,x[i]),sep="/")
      }
       
      # useful test URL
      # "http://nassgeodata.gmu.edu/cdlservicedata/nass_data_cache/byfips/CDL_2006_19.zip"
      
      # check if URL exists
      if(httr::http_error(url, config = httr::config(ssl_verifypeer = ssl.verifypeer)) ){
        warning( sprintf("%s does not exist.",url) )
        next
      }
     
      # download zip file 
      if(missing(alternativeUrl) ) {
        httr::GET(url, 
          httr::write_disk(paste(
            location, sprintf("CDL_%d_%02d.zip", cdl_year, x[i]), sep = "/"), 
          overwrite = TRUE), 
          config = httr::config(ssl_verifypeer = ssl.verifypeer), httr::progress())
        
        utils::unzip(paste(
          location, sprintf("CDL_%d_%02d.zip", cdl_year, x[i]), sep="/"), 
          exdir = location)
        
        unlink(paste(location,sprintf("CDL_%d_%02d.zip",cdl_year,x[i]),sep="/"))
      } else {
        utils::download.file(url,destfile=paste(location,sprintf("CDL_%d_%02d.tif",cdl_year,x[i]),sep="/"),mode="wb", method = "curl")
      }
      target <- raster_read(paste(location,sprintf("CDL_%d_%02d.tif",cdl_year,x[i]),sep="/")) 
      names.array <- append(names.array, paste0( fips(x[i],to="Abbreviation"),cdl_year))
      # terra seems to overwrite the append function
      # so we do this to allow extents to be in the same list even
      # if they don't match
      if( length(cdl.list) == 0 ) {
        cdl.list = list(target) 
      } else {
        cdl.list[[length(cdl.list) + 1]] = target 
      }
    }
  }
  names(cdl.list) <- names.array
  return(cdl.list)
}




