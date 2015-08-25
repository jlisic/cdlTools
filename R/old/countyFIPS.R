

###########################################
####countyfibs function####################
####input: x=state y=county################
####output: county fibs code(5 digits)#####


#use mapply if x, and y are list#
countyFIPS <- function(x,y){
  
  if(length(x) == 0 ) return(NA)
  if(length(y) == 0 ) return(NA)
  # handle the case of NA
  if(any(is.na(x))) return(NA)
  if(any(is.na(y))) return(NA)
  
  data(UScensusFIPS)
  #for maching convert to upper case
  x <- as.character(toupper(x))
  y <- as.character(toupper(y))
  #find the index matched both county and state 
    ids <- which((UScensusFIPS$STATE == x)|(toupper(UScensusFIPS$STATENAME) == x))
    id <- ids[ids %in% grep(paste("^",y,sep=""),toupper(UScensusFIPS$COUNTYNAME))]
    if(length(id) != 0) {
      return(paste(UScensusFIPS$STATEFP[id],UScensusFIPS$COUNTYFP[id],sep=""))
      #return(list(STATEFP=UScensusFIPS$STATEFP[id],COUNTYFP=UScensusFIPS$COUNTYFP[id]))
    }
    else {
      warning("Either State or County does not exist!")
      return (NA) 
    }

}

#stateFIPS <- function(x){
#  if(length(x) == 0 ) return(NA)
#  # handle the case of NA
#  if(any(is.na(x))) return(NA)
#  
#  data(UScensusFIPS)
#  #for maching convert to upper case
#  x <- as.character(toupper(x))
#  #find the index matched both county and state 
#  id <- which(UScensusFIPS$STATE == x)
#  if(length(id) != 0) {
#    return(paste(paste(UScensusFIPS$STATEFP[id],UScensusFIPS$COUNTYFP[id],sep=""),collapse=","))
#    #return(list(STATEFP=UScensusFIPS$STATEFP[id],COUNTYFP=UScensusFIPS$COUNTYFP[id]))
#  }
#  else {
#    warning("Either State or County does not exist!")
#    return (NA) 
#  }
#  
#}
#
