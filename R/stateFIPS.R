#'Get US state FIPS code
#'
#'Retrieve 2-digit US state FIPS code by names 
#'
#'@param x A character string. State names. It can be the two-letter postal abbreviation or the full name. The string is case insensitive.
#'
#'
#'@return 2-digit state FIPS code 
#'
#'@examples
#'stateFIPS("ia")
#'
#'@export
#'

stateFIPS <- function(x){
  if(length(x) == 0 ) return(NA)
  # handle the case of NA
  if(any(is.na(x))) return(NA)
  
  data(stateNames)
  #for maching convert to upper case
  x <- as.character(toupper(x))
  #find the index matched both county and state 
  id <- which((stateNames$State == x)|(toupper(stateNames$State_Name) == x))
  if(length(id) != 0) {
    return(stateNames$State_FIPS[id])}
  else {
    warning("Either State or County does not exist!")
    return (NA) 
  }
  
}