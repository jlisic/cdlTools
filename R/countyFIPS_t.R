#'Get US county FIPS code
#'
#'Retrieve 5-digit US county FIPS code by names 
#'
#'@param x A character string. county and state names seperated by  ",". For the county, it should be full name. For the state, it can be the two-letter postal abbreviation or the full name. The string is case insensitive.
#'
#'
#'@return 5-digit county FIPS code 
#'
#'@examples
#'countyFIPS("fairfax county,va")
#'
#'@export
#'
countyFIPS <- function(x){
  
  if(length(x) == 0 ) return(NA)

  # handle the case of NA
  if(any(is.na(x))) return(NA)

  
  data(UScensusFIPS)
  #for maching convert to upper case
  x <- strsplit(toupper(as.character(x)),",")[[1]]

  #find the index matched both county and state 
    ids <- which((UScensusFIPS$STATE == x[2])|(toupper(UScensusFIPS$STATENAME) == x[2]))
    id <- ids[ids %in% grep(paste("^",x[1],sep=""),toupper(UScensusFIPS$COUNTYNAME))]
    if(length(id) != 0) {
      return(paste(UScensusFIPS$STATEFP[id],UScensusFIPS$COUNTYFP[id],sep=""))
      #return(list(STATEFP=UScensusFIPS$STATEFP[id],COUNTYFP=UScensusFIPS$COUNTYFP[id]))
    }
    else {
      warning("Either State or County does not exist!")
      return (NA) 
    }

}



