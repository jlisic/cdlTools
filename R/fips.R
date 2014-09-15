# this will need to be renames .fips
# fips will be an sapply of fips

fips <- function( x , to='Abbreviation') {

  # handle the case of 0 length
  if(length(x) == 0 ) return(NA)

  # handle the case of NA
  if(is.na(x)) return(NA)


  data(census2010FIPS)
  data(stateNames)

  # Convert To Fips
  if( to == 'FIPS') {
    
    # for matching convert to upper case 
    x <- toupper(x)


    # if it is a full state name convert to  
    if( x %in% sub(" ","",toupper(as.character(stateNames$State_Name)))) {
      x <- stateNames[x == sub(" ","",toupper(as.character(stateNames$State_Name))),'State'][1] 
      x <- as.character(x)
    }
   
    # if the two letters are in the state factor we return the fips
    if( x %in% as.character(census2010FIPS$State) ) {
      return( census2010FIPS[x == as.character(census2010FIPS$State), 'State.ANSI'][1] ) 
    }

    return(NA)
  }
  
  if( to == 'Abbreviation') {
  
    # if the two letters are actually numbers we convert to numeric
    # and return the abreviation
    if( grepl("[0-9]",x[1]) ) {
      if(as.numeric(x) %in% census2010FIPS$State.ANSI) {
        return( as.character( census2010FIPS[as.numeric(x) == census2010FIPS$State.ANSI, 'State'] )[1]) 
      }
    }

    x <- toupper(x)
   
    # full state name 
    if( x %in% sub(" ","",toupper(as.character(stateNames$State_Name)))) {
      return( as.character(stateNames[x == toupper(sub(" ","",as.character(stateNames$State_Name))),'State'][1]))
    }

    # abbreviation to abbreviation
    # if the two letters are in the state factor we return the fips
    if( x %in% as.character(census2010FIPS$State) ) {
      return( as.character(census2010FIPS[x == as.character(census2010FIPS$State), 'State'][1] )) 
    }


    return(NA)

  }
  
  if( to == 'Name') {

    # check if x contains numbers 
    if( grepl("[0-9]",x[1]) ) {
      # if the two letters are actually numbers we convert to numeric
      # and return the abreviation
      if(as.numeric(x) %in% census2010FIPS$State.ANSI) {
         x <-  as.character( census2010FIPS[as.numeric(x) == census2010FIPS$State.ANSI, 'State'] )[1] 
      }
    }
    
    x <- toupper(x)
   
    # full state name 
    if( x %in% sub(" ","",toupper(as.character(stateNames$State_Name)))) {
      x <- as.character(stateNames[x == toupper(sub(" ","",as.character(stateNames$State_Name))),'State'][1])
    }
  
    # abbreviation to full state 
    return( sub(" ","",as.character( stateNames[x == toupper(as.character(stateNames$State)),'State_Name'][1])) )

  }
 
  return(NA) 
  
}

