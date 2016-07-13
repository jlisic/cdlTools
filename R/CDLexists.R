



# a function that takes a fips code (state) and a year, and returns
# true if a CDL image exists for this particular pair, otherwise false.
CDLexists <- function( x, year) {
  require(RCurl)

  # base url for cdl metadata
  urlCheck <- "https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/metadata_"
   
  # get the full url for the metadata 
  urlName <- sprintf("%s%s%02d.htm",
         urlCheck,
         tolower(fips(x,to="Abbreviation")), 
         year%% 100 
         )

  # do a url request and scan for 404
  if( length(grep("the page you requested was not found", getURL(urlName))) == 0 ) return( TRUE)
  return(FALSE)
}


#example

#CDLexists(1,1997) # returns false

#CDLexists(1,2008) # returns false


