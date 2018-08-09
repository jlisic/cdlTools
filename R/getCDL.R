#'Get CDL raster data
#'
#'\code{getCDL} retrieves CDL state raster objects for a set of years.
#'
#'@param x Is either a two digit state FIPS code, a two letter abbreviation, or
#'  a state name.
#'@param year A numerical vector. A set of years of CDL data to download.
#'@param bbox A four element numeric bounding box vector specifying 
#'  xmin, ymin, xmax, ymax. All coordinates must be in the projection of 
#'  USA Contiguous Albers Equal Area Conic (USGS version).
#'@param alternativeUrl An optional string containing an alternative url.
#'@param location An optional string containing a location to store the file.
#'@param https An optional boolean to turn on and off https, default is on.
#'@param ssl.verifypeer An optional boolean to turn on and off ssl verfication, default is on.
#'@return A list of CDL raster objects of interested county for a set of years.
#'@examples
#'\dontrun{
#' # Get data for California, 2013 and 2015
#' # by FIPS
#' getCDL(6,c(2013,2015))
#'
#' # Get data for California, 2013 and 2015
#' getCDL("California",c(2013,2015))
#'
#' # Get all the west coast from 2009 to 2016
#' getCDL(c("CA","OR","WA"),2013:2016)
#'
#' # Get data for a custom bounding box
#' getCDL(year = 2013, bbox = c(130783, 2203171, 153923, 2217961))
#'    
#' # Get data for a custom bounding box from 2013 to 2015
#' getCDL(year = 2013:2015, bbox = c(130783, 2203171, 153923, 2217961))
#'    
#'}
#' @author Jonathan Lisic, \email{jlisic@@gmail.com}
#' @author Joseph Stachelek, \email{stachel2@@msu.edu}
#' @importFrom utils download.file unzip
#' @importFrom raster raster
#' @importFrom httr http_error 
#' @importFrom httr config GET write_disk
#' @importFrom stringr str_extract
#' @export
getCDL <- function(x = NA, year, bbox = NA, alternativeUrl, location = tempdir(), 
                   https = TRUE, ssl.verifypeer = TRUE){
  
  if(all(all(!is.na(x)), !is.na(bbox))){
    stop("Can only specify either x OR bbox.")
  }

  cdl.list <- list()
  names.array <- c()
  years <- year # fix but can't change due to legacy

  if(all(!is.na(x))){
    x <- fips(x)
  
    for(i in 1:length(x)) {
      if(is.na(x[i])) next 
  
      for(year in years){
        # create cropscape URL 
        if(missing(alternativeUrl)) {
            if(https) {
              url <- sprintf("https://nassgeodata.gmu.edu/cdlservicedata/nass_data_cache/byfips/CDL_%d_%02d.zip",year,x[i]) 
            } else {
              url <- sprintf("http://nassgeodata.gmu.edu/cdlservicedata/nass_data_cache/byfips/CDL_%d_%02d.zip",year,x[i]) 
            }
        } else {
          url <- paste(alternativeUrl,sprintf("CDL_%d_%02d.tif",year,x[i]),sep="/")
        }
         
        # check if URL exists
        if(httr::http_error(url, config = httr::config(ssl_verifypeer = ssl.verifypeer)) ){
          warning( sprintf("%s does not exist.",url) )
          next
        }
       
        # download zip file 
        if(missing(alternativeUrl) ) {
          httr::GET(url, 
            httr::write_disk(paste(
              location, sprintf("CDL_%d_%02d.zip", year, x[i]), sep = "/"), 
            overwrite = TRUE), 
            config = httr::config(ssl_verifypeer = ssl.verifypeer))
          
          utils::unzip(paste(
            location, sprintf("CDL_%d_%02d.zip", year, x[i]), sep="/"), 
            exdir = location)
          
          unlink(paste(location,sprintf("CDL_%d_%02d.zip",year,x[i]),sep="/"))
        } else {
          utils::download.file(url,destfile=paste(location,sprintf("CDL_%d_%02d.tif",year,x[i]),sep="/"),mode="wb", method = "curl")
        }
        target <- raster::raster(paste(location,sprintf("CDL_%d_%02d.tif",year,x[i]),sep="/")) 
        names.array <- append(names.array, paste0( fips(x[i],to="Abbreviation"),year))
        cdl.list <- append(cdl.list,target)
      }
    }
  }else{
    for(year in years){
      url <- paste0("https://nassgeodata.gmu.edu/axis2/services/CDLService/GetCDLFile?year=", year, "&bbox=", paste0(bbox, collapse = ","))
      url <-  httr::content(
                httr::GET(url, 
                          config = httr::config(ssl_verifypeer = ssl.verifypeer)), 
                "text")
      url <- stringr::str_extract(url, "(?<=returnURL>)(.*)(?=</returnURL>)")
      
      out_path <- file.path(location, basename(url))
      
      httr::GET(url, 
                httr::write_disk(out_path, 
                  overwrite = TRUE), 
                config = httr::config(ssl_verifypeer = ssl.verifypeer))
      
      target <- raster::raster(out_path)
      cdl.list <- append(cdl.list,target) 
    }
  }
  
  names(cdl.list) <- names.array
  return(cdl.list)
}
