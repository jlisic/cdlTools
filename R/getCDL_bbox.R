#'Get CDL raster data 
#'
#'Retrieve CDL data for a set of years by bounding box 
#'
#'@param x A numeric matrix. Bounding box coordinates of an interested couty. first column has the minimum values, the second has the maximum values; rows represent the spatial dimensions.
#'@param year A numerical vector. A set of interestedy years
#'
#'@return a list of CDL raster objects of interested county for a set of years.
#'
#'@examples
#'getCDL_fips("01001",c(2013,2014))
#'
#'@export
#'
####input: x bounding box seperated by ","# 
getCDL_bbox <- function(x,year){
  #   require(XML)
  cdl.list <- list()
  for(i in 1:length(year)){
    location <- tempdir()
    xmlurl <- sprintf("http://nassgeodata.gmu.edu:8080/axis2/services/CDLService/GetCDLFile?year=%d&bbox=%f,%f,%f,%f",year[i],x[1,1],x[2,1],x[1,2],x[2,2])
    url <- as.character(xmlToDataFrame(xmlurl)$text)
    download.file(url,destfile=paste(location,sprintf("temp_%d_%s.tif",year[i],i),sep="/"))
    target<-raster(paste(location,sprintf("temp_%d_%s.tif",year[i],i),sep="/")) 
    names(target)<-year[i]
    cdl.list[sprintf("%s",year[i])]<-target
  }
  return(cdl.list)
}