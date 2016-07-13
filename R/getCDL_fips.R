#'Get CDL raster data 
#'
#'Retrieve CDL data for a set of years by names or 5-digit county FIPS code
#'
#'@param x Is either a 2-digit state FIPS code, a 2 letter abbreviation, or a state name.
#'@param year A numerical vector. A set of years of CDL data to download.
#'@param FIPS logical object. If TRUE, x is 2-digit county FIPS code. Otherwise, x is a character string to match in the county and state names. Default is TRUE.
#'@param alternativeUrl an optional string containing an alternative url.
#'@param location an optional string containing a location to store the file.
#'
#'@return a list of CDL raster objects of interested county for a set of years.
#'
#'@examples
#'getCDL_fips(6,c(2013,2015))
#'getCDL_fips("California",c(2013,2015))
#'getCDL_fips("CA",c(2013,2015))
#'
#'@export


getCDL_fips <- function(x,year,FIPS = TRUE,alternativeUrl,location){
  require(XML)
  require(raster)
  require(rgdal)
  cdl.list <- list()
  names.array <- c()
 
  x <- fips(x,to = 'Abbreviation')
  x <- fips(x)
             
  for(year in year){
    if(missing(location)) location <- tempdir()
    # get data from USDA
    if(missing(alternativeUrl)) {
      xmlurl <- sprintf("http://nassgeodata.gmu.edu:8080/axis2/services/CDLService/GetCDLFile?year=%d&fips=%s",year,x)
      url <- as.character(xmlToDataFrame(xmlurl)$text)
    } else {
      url <- paste(alternativeUrl,sprintf("CDL_%d_%s.tif",year,x),sep="/")
    }
    
    download.file(url,destfile=paste(location,sprintf("CDL_%d_%s.tif",year,x),sep="/"),mode="wb")
    target <- raster(paste(location,sprintf("CDL_%d_%s.tif",year,x),sep="/")) 
    names.array <- append(names.array, year)
    cdl.list <- append(cdl.list,target)
  }
  names(cdl.list) <- names.array
  return(cdl.list)
}




