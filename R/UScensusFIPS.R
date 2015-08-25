#'US county FIPS codes
#'
#'Data from 2010 US census, including state postal code, state FIPS code, county FIPS code, county name,state full name and FIPS class code.  
#'
#'@name UScensusFIPS
#'
#'@docType data
#'
#'@usage data(UScensusFIPS)
#'
#'@format A data frame with 3235 observations on the following 6 variables:
#'
#'\code{STATE} a character vector. State Postal Code  
#'
#'\code{STATEFP} a character vector.State FIPS Code
#'
#'\code{STATENAME} a character vector.State Name
#'
#'\code{COUNTYFP} a character vector.County FIPS Code
#'
#'\code{COUNTYNAME} a character vector.County Name and Legal/Statistical Area Description
#'
#'\code{CLASSFP} a character vector.FIPS Class Code
#'  
#'@source \url{https://www.census.gov/geo/reference/codes/cou.html}
#'
#'@examples data(UScensusFIPS)
"UScensusFIPS"