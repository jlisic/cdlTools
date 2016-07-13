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
Version: \tab 1.0\cr
Date: \tab 2014-08-26\cr
License: \tab BSD 2 clause\cr
}
This package allows for simple retreival of agricultural land cover in the United States through USDA's Cropland Data Layer (CDL).
The most useful functions are 
getCDL, a function to download CDL data by geographic bounding box, state, or county.
cdl.updateNames, a function to apply class descriptions to the enumerated CDL data.
, a function to download classification rates of the CDL data.
, a function for quick classification of zonal statistics.  FUNC requires gdal_rasterize and gdal_polygonize to be available on the system path.
}
\author{
Lu Chen and Jonathan Lisic 
Maintainer: Jonathan Lisic <jonathan.lisic@nass.usda.gov>
}
\references{
Boryan, Claire, et al. "Monitoring US agriculture:  the US department of agriculture, national agricultural statistics service, cropland data layer program." Geocarto International 26.5 (2011): 341-358.
}
\keyword{ package }
\keyword{ datasets }
\seealso{
  raster
~~ Optional links to other man pages, e.g. ~~
~~ \code{\link[<pkg>:<pkg>-package]{<pkg>}} ~~
}
\examples{
~~ simple examples of the most important functions ~~
}
