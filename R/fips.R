fips <- function( x , level='State') {

  data(census2010FIPS)

  if( level == 'State') {
    # check if the input is character 
    if( is.character(x) ) {
    
      # if the two letters are in the state factor we return the fips
      if( x %in% as.character(census2010FIPS$State) ) {
        return( census2010FIPS[x == as.character(census2010FIPS$State), 'State.ANSI'][1] ) 
      }
  
      # if the two letters are actually numbers we convert to numeric
      # and return the abreviation
      if(as.numeric(x) %in% census2010FIPS$State.ANSI) {
        return(
          as.character( 
            census2010FIPS[as.numeric(x) == census2010FIPS$State.ANSI, 'State'] )[1]) 
      }
    }
  
    # The only valid numeric input type is state fips codes 
    return(
      as.character( 
        census2010FIPS[x == census2010FIPS$State.ANSI, 'State'] )[1]) 
  }
  
}

