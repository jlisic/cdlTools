#'Get CDL raster data
#'
#'\code{getCDL} retrieves CDL state raster objects for a set of years.
#'
#'@param x Is either a two digit state FIPS code, a two letter abbreviation, or
#'  a state name.
#'@param year A numerical vector. A set of years of CDL data to download.
#'@param alternativeUrl An optional string containing an alternative url.
#'@param location An optional string containing a location to store the file.
#'@param https An optional boolean to turn on and off https, default is on.
#'@return A list of CDL raster objects of interested county for a set of years.
#'@examples
#'\dontrun{
#'# Get data for California, 2013 and 2015
#'# by FIPS
#'getCDL(6,c(2013,2015))
#'# Get data for California, 2013 and 2015
#'getCDL("California",c(2013,2015))
#'# Get all the west coast from 2009 to 2016
#'getCDL(c("CA","OR","WA"),2013:2016)
#'}
#' @importFrom utils download.file unzip
#' @importFrom raster raster
#' @importFrom RCurl url.exists 
#'@export
getCDL <- function(x,year,alternativeUrl,location,https=TRUE){

  cdl.list <- list()
  names.array <- c()
 
  x <- fips(x)
  years <- year # fix but can't change due to legacy

  for( i in 1:length(x) ) {
    if( is.na(x[i]) ) next 

    for(year in years){
      if(missing(location)) location <- tempdir()
      # create cropscape URL 
      if(missing(alternativeUrl)) {
          if(https) {
            url <- sprintf("https://nassgeodata.gmu.edu/nass_data_cache/byfips/CDL_%d_%02d.zip",year,x[i]) 
          } else {
            url <- sprintf("http://nassgeodata.gmu.edu/nass_data_cache/byfips/CDL_%d_%02d.zip",year,x[i]) 
          }
      } else {
        url <- paste(alternativeUrl,sprintf("CDL_%d_%02d.tif",year,x[i]),sep="/")
      }
        
      # check if URL exists 
      if( !RCurl::url.exists(url) ) {
        warning( sprintf("%s does not exist.",url) )
        next  
      }
     
      #download zip file 
      if(missing(alternativeUrl) ) {
        utils::download.file(url,destfile=paste(location,sprintf("CDL_%d_%02d.zip",year,x[i]),sep="/"),mode="wb")
        utils::unzip(paste(location,sprintf("CDL_%d_%02d.zip",year,x[i]),sep="/"),exdir=location)
        unlink(paste(location,sprintf("CDL_%d_%02d.zip",year,x[i]),sep="/"))
      } else {
        utils::download.file(url,destfile=paste(location,sprintf("CDL_%d_%02d.tif",year,x[i]),sep="/"),mode="wb")
      }
      target <- raster::raster(paste(location,sprintf("CDL_%d_%02d.tif",year,x[i]),sep="/")) 
      names.array <- append(names.array, paste0( fips(x[i],to="Abbreviation"),year))
      cdl.list <- append(cdl.list,target)
    }
  }
  names(cdl.list) <- names.array
  return(cdl.list)
}




