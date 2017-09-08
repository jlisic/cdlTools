#'Get CDL raster data
#'
#'\code{getCDL} retrieves CDL state raster objects for a set of years.
#'
#'@param x Is either a two digit state FIPS code, a two letter abbreviation, or
#'  a state name.
#'@param year A numerical vector. A set of years of CDL data to download.
#'@param alternativeUrl An optional string containing an alternative url.
#'@param location An optional string containing a location to store the file.
#'@return A list of CDL raster objects of interested county for a set of years.
#'@examples
#'\dontrun{
#'getCDL(6,c(2013,2015))
#'getCDL("California",c(2013,2015))
#'getCDL("CA",c(2013,2015))
#'}
#' @importFrom utils data download.file unzip
#' @importFrom raster raster
#' @importFrom XML xmlToDataFrame 
#'@export
getCDL <- function(x,year,alternativeUrl,location){

  cdl.list <- list()
  names.array <- c()
 
  x <- fips(x)

  for( i in 1:length(x) ) {
    if( is.na(x[i]) ) next 

    for(year in year){
      if(missing(location)) location <- tempdir()
      # get data from USDA
      if(missing(alternativeUrl)) {
          url <- sprintf("https://nassgeodata.gmu.edu/nass_data_cache/byfips/CDL_%d_%02d.zip",year,x[i]) 
      } else {
        url <- paste(alternativeUrl,sprintf("CDL_%d_%02d.tif",year,x[i]),sep="/")
      }
      
      if(missing(alternativeUrl) ) {
        download.file(url,destfile=paste(location,sprintf("CDL_%d_%02d.zip",year,x[i]),sep="/"),mode="wb")
        unzip(paste(location,sprintf("CDL_%d_%02d.zip",year,x[i]),sep="/"),exdir=location)
      } else {
        download.file(url,destfile=paste(location,sprintf("CDL_%d_%02d.tif",year,x[i]),sep="/"),mode="wb")
      }
      target <- raster(paste(location,sprintf("CDL_%d_%02d.tif",year,x[i]),sep="/")) 
      names.array <- append(names.array, paste0( fips(x[i],to="Abbreviation"),year))
      cdl.list <- append(cdl.list,target)
    }
  }
  names(cdl.list) <- names.array
  return(cdl.list)
}




