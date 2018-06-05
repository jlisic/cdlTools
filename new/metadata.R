#'CDL metadata.
#'
#'\code{metadata} downloads classification and crop class metadata from the cropscape website. 
#'
#'Cropscape provides classification and crop class metadata on the Cropland Data Layer.
#'This function fetches this data through scraping cropscape html.
#'
#' @param state A numeric fips code, a state's two letter abbreviation, or a state name.
#' @param year A numeric year.
#' @param https An optional boolean to turn on and off https, default is on.
#' @param ssl.verifypeer An optional boolean to turn on and off ssl verfication, default is on.
#' @return The metadata for the state identified by the state argument.  If no match can be made, the 
#'  program returns NA.  The metadata is returned as a list with two elements, classification and
#'  classes.
#' @examples
#' metadata("ia", 2007)
#' metadata('North Carolina',2008)
#' metadata(44,2017)
#' @author Jonathan Lisic, \email{jlisic@@gmail.com}
#' @importFrom utils download.file
#' @export

metadata  <- function( state , year,https=TRUE, ssl.verifypeer = TRUE){

  # handle the case of 0 length
  if(length(state) == 0 ) return(NA)

  # convert to NA
  state = fips(state, to='FIPS')
  
  # handle the case of NA
  if(is.na(state)) return(NA)

  # downloading file
  if(https) {
    url <- "https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/metadata_%s%20d.htm", fips(state, to="abbreviation"),year %% 100)
  } else {
    url <- "http://www.nass.usda.gov/Research_and_Science/Cropland/metadata/metadata_%s%20d.htm", fips(state, to="abbreviation"),year %% 100)
  }

  # check if URL exists
  if(httr::http_error(url, config = httr::config(ssl_verifypeer = ssl.verifypeer)) ){
     warning( sprintf("%s does not exist.",url) )
     return(NA)
   }

  tempFile <- tempfile()
    
  # download file
  utils::download.file(url,destfile=tempFile,mode="wb", method = "curl")


}

