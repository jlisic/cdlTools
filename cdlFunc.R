library(sp)
library(rgdal)
library(raster)

#windowDir <- 'C:/Documents and Settings/lisijo/My Documents/Data/'
macDir <- '/Users/jonathanlisic/data/CDL/'
#linuxDir <- '/Rproj/substrata/data/CDL/'


Dir <- macDir
years <- 1997:2012
State <- 'NorthDakota'
Fips <-  38

source('~/src/cdlTools/getCDL.R')
source('~/src/cdlTools/incident.R')
source('~/src/cdlTools/rasterClusterApply.R')

source('~/src/cdlTools/rasterProper.R')


CDLRaster <- cdlBrick(Dir, Years, State, Fips) 

writeRaster( CDLRaster, sprintf('%sCDL_%s/CDL_Brick_%d.grd',Dir,State,Fips),format="raster" )

# set the appropriate directory
beginCluster()

  win <- 5
  subsets <- list( cultivated, corn, soybeans, winterWheat, springWheat, durumWheat, cotton, pasture )  

  raster.cdlIncident <- rasterClusterApply( CDLRaster, cellFun=incident, needed= list('win', 'subsets'), progress="text" )

endCluster()

writeRaster( raster.cdlIncident , sprintf('%sCDL_%s/CDL_Brick_Incident_%d.grd',Dir,State,Fips),format="raster" )





