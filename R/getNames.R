#' Retrieve the names from state or county fips code.
#' 
#' @param x A character string. Five-digit county fips code or two-digit state fips code.
#'
#' @return A list of corresponding state name or county name.
#' @examples
#' getNames("19015")
#' 
#' @export
getNames <- function(x){
  
  if(length(x) == 0 ) return(NA)
  # handle the case of NA
  if(any(is.na(x))) return(NA)
  
  data(UScensusFIPS)
  if(nchar(x) == 5){
    x <- substring(x,c(1,3),c(2,5))
    id <- which((UScensusFIPS$STATEFP %in% as.character(x[1]))&(UScensusFIPS$COUNTYFP %in% as.character(x[2])))
    return(paste(UScensusFIPS$COUNTYNAME[id],UScensusFIPS$STATE[id],sep=","))
}
  if(nchar(x) == 2){
    return(UScensusFIPS$STATE[which(UScensusFIPS$STATEFP %in% x)[1]])
  }
  
  else{return(NA)}
}