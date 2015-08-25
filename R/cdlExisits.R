library(cdlTools)




# a function that takes a fips code (state) and a year, and returns
# true if a CDL image exists for this particular pair, otherwise false.
CDLexists <- function( fips, year) {
  require(RCurl)

  # base url for cdl metadata
  urlCheck <- "http://www.nass.usda.gov/research/Cropland/metadata/metadata_"
   
  # get the full url for the metadata 
  urlName <- sprintf("%s%s%02d.htm",
         urlCheck,
         tolower(fips(fips)), 
         year%% 100 
         )

  # do a url request and scan for 404
  if( length(grep("Error 404", getURL(urlName))) == 0 ) return( TRUE)
  return(FALSE)
}


#example

CDLexists(1,1997) # returns false

CDLexists(1,2008) # returns false


