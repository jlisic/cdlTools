library(sp)
library(rgdal)
library(raster)


source('~/src/cdlTools/getCDL.R')
source('~/src/cdlTools/incident.R')
source('~/src/cdlTools/rasterClusterApply.R')


# set the appropriate directory


#windowDir <- 'C:/Documents and Settings/lisijo/My Documents/Data/'
macDir <- '/Volumes/data/CDL/'
linuxDir <- '/Rproj/substrata/data/CDL/'


Dir <- linuxDir
years <- 2000:2012
State <- 'Iowa'
Fips <- 19

# at this point we have a raster brick
# CDLRaster <- brick( unlist( a ) ) 

beginCluster()

  win <- 5
  subsets <- list( cultivated, corn, soybeans, winterWheat, springWheat, durumWheat, cotton, pasture )  

  rasterClusterApply( CDLRaster, cellFun=incident, needed= list('win', 'subsets'), progress="text" )

endCluster()





