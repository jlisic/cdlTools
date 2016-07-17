\name{cdlTools-package}
\alias{cdlTools-package}
\alias{cdlTools}
\docType{package}
\title{
Cropland Data Layer Tools
}
\description{
Tools to obtain and use CDL data with the raster package.  
}
\details{
\tabular{ll}{
Package: \tab cdlTools\cr
Type: \tab Package\cr
Version: \tab 0.1\cr
Date: \tab 2014-08-26\cr
License: \tab Unlimited\cr
}
This package allows for simple retreival of agricultural land cover in the United States 
through USDA's Cropland Data Layer (CDL).  The most useful functions are getCDL, a 
function to download CDL data by state.  updateNamesCDL, a function to apply class 
descriptions to the enumerated CDL data.
}
\author{
Lu Chen and Jonathan Lisic 
Maintainer: Jonathan Lisic <jonathan.lisic@nass.usda.gov>
}
\references{
Boryan, Claire, et al. "Monitoring US agriculture:  the US department of agriculture, national agricultural statistics service, cropland data layer program." Geocarto International 26.5 (2011): 341-358.
}
\examples{
\dontrun{
# copy data to a local directory
cdlRaster <- getCDL("Rhode Island",c(2012,2013),location="/tmp")

# get land land cover change between 2012 and 2013
landCoverChange <- matchCount(cdlRaster$'2012',cdlRaster$'2013')

# convert to data frame
landCoverChange.df <- as.data.frame(landCoverChange)

# convert CDL category enumerations to text
landCoverChange.df[c('CDL_2012_44','CDL_2013_44')] <- 
  lapply(landCoverChange.df[c('CDL_2012_44','CDL_2013_44')],updateNamesCDL)
}
}
