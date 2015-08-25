#'Get CDL raster data 
#'
#'Retrieve CDL data for a set of years by names or 5-digit county FIPS code
#'
#'@param x A character string. either 5-digit county FIPS code or 2-digit state FIPS code if type= or county and state names seperated by ",".
#'@param year A numerical vector. A set of interestedy years
#'@param FIPS logical object. If TRUE, x is 5-digit county FIPS code. Otherwise, x is a character string to match in the county and state names. Default is TRUE.
#'
#'@return a list of CDL raster objects of interested county for a set of years.
#'
#'@examples
#'getCDL_fips("01001",c(2013,2014))
#'getCDL_fips("autauga county,al",c(2013,2014),FIPS = FALSE)
#'
#'@export
####input: x fips codes(5-digit) seperated by ","# 

getCDL_fips <- function(x,year,FIPS = TRUE){
  require(XML)
  require(raster)
  require(rgdal)
  cdl.list <- list()
  if(!FIPS){ if(grepl(",",x)){x<-countyFIPS(x)} 
            else {x<-stateFIPS(x)}
  }            
  for(year in year){
    location <- tempdir()
    xmlurl <- sprintf("http://nassgeodata.gmu.edu:8080/axis2/services/CDLService/GetCDLFile?year=%d&fips=%s",year,x)
    url <- as.character(xmlToDataFrame(xmlurl)$text)
    download.file(url,destfile=paste(location,sprintf("CDL_%d_%s.tif",year,x),sep="/"),mode="wb")
    target <- raster(paste(location,sprintf("CDL_%d_%s.tif",year,x),sep="/")) 
    names(target) <- year
    cdl.list[sprintf("%s",year)] <- target
    }
  return(cdl.list)
}




