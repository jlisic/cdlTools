#'FIPS code conversion function.
#'
#'\code{fips} converts U.S. state names and abbreviations to and from FIPS codes.
#'
#'The Federal Information Processing Standard (FIPS) provides a set of standard numeric 
#'codes for refering to U.S. states.  This function converts between FIPS codes, state two 
#'letter abbreviations, and full state names.
#'
#' @param x A vector, data frame or matrix of character strings or numeric FIPS codes. Character input can be the two-letter 
#'  postal abbreviation, the full name of a state, or a FIPS code in character format. 
#'  The string is case insensitive.  FIPS codes are the only numeric input supported.
#' @param to A character string of output type:  "FIPS" will return a numeric fips code.
#'  "Abbreviation" will return a two letter state abbreviation.  "Name" will return the
#'  full state name with spaces.  The default output is a numeric FIPS code.
#' @return The output type specified by the "to" argument.  If no match can be made, the 
#'  program returns NA.
#' @examples
#' fips("ia")
#' fips('northcarolina', to='Abbreviation')
#' fips('North Carolina')
#' fips(44,to='Name')
#' @author Jonathan Lisic, \email{jlisic@@gmail.com}
#' @importFrom utils data download.file
#' @export

fips <- function( x , to='FIPS') {

  # handle the case of 0 length
  if(length(x) == 0 ) return(NA)
  
  # handle the case of multiple items
  if(length(x) > 1) {
    if(!is.null(ncol(x))) return( apply(x, 1:2, fips, to=to) )
    return( sapply( x, fips, to=to ) )
  }

  # handle the case of NA
  if(is.na(x)) return(NA)

  # Convert To Fips
  if( toupper(to) == 'FIPS') {
    
    # for matching convert to upper case 
    x <- sub(" ","",toupper(as.character(x)))
    
    # check if x contains numbers 
    if( grepl("[0-9]",x[1]) ) {
      # if the two letters are actually numbers we convert to numeric
      # and return the abbreviation
      if(as.numeric(x) %in% cdlTools::census2010FIPS$State.ANSI) {
        return(as.numeric(x)) 
      } else return(NA)
    }
    
    # if it is a full state name convert to  
    if( x %in% sub(" ","",toupper(as.character(cdlTools::stateNames$STATENAME)))) {
      x <- cdlTools::stateNames[x == sub(" ","",toupper(as.character(cdlTools::stateNames$STATENAME))),'STATE'][1] 
      x <- as.character(x)
    }
   
    # if the two letters are in the state factor we return the fips
    if( x %in% as.character(cdlTools::census2010FIPS$State) ) {
      return( cdlTools::census2010FIPS[x == as.character(cdlTools::census2010FIPS$State), 'State.ANSI'][1] ) 
    }

    return(NA)
  }
  
  if( toupper(to) == 'ABBREVIATION') {
  
    # if the two letters are actually numbers we convert to numeric
    # and return the abbreviation
    if( grepl("[0-9]",x[1]) ) {
      if(as.numeric(x) %in% cdlTools::census2010FIPS$State.ANSI) {
        return( as.character( cdlTools::census2010FIPS[as.numeric(x) == cdlTools::census2010FIPS$State.ANSI, 'State'] )[1]) 
      }
    }

    x <- toupper(x)
   
    # full state name 
    if( x %in% sub(" ","",toupper(as.character(cdlTools::stateNames$STATENAME)))) {
      return( as.character(cdlTools::stateNames[x == toupper(sub(" ","",as.character(cdlTools::stateNames$STATENAME))),'STATE'][1]))
    }

    # abbreviation to abbreviation
    # if the two letters are in the state factor we return the fips
    if( x %in% as.character(cdlTools::census2010FIPS$State) ) {
      return( as.character(cdlTools::census2010FIPS[x == as.character(cdlTools::census2010FIPS$State), 'State'][1] )) 
    }


    return(NA)

  }
  
  if( toupper(to) == 'NAME') {

    # check if x contains numbers 
    if( grepl("[0-9]",x[1]) ) {
      # if the two letters are actually numbers we convert to numeric
      # and return the abbreviation
      if(as.numeric(x) %in% cdlTools::census2010FIPS$State.ANSI) {
         x <-  as.character( cdlTools::census2010FIPS[as.numeric(x) == cdlTools::census2010FIPS$State.ANSI, 'State'] )[1] 
      }
    }
    
    x <- toupper(x)
   
    # full state name 
    if( x %in% sub(" ","",toupper(as.character(cdlTools::stateNames$STATENAME)))) {
      x <- as.character(cdlTools::stateNames[x == toupper(sub(" ","",as.character(cdlTools::stateNames$STATENAME))),'STATE'][1])
    }
  
    # abbreviation to full state 
    return( as.character( cdlTools::stateNames[x == toupper(as.character(cdlTools::stateNames$STATE)),'STATENAME'][1]) )

  }
 
  return(NA) 
  
}

