# This is a scrip that will create a multiyear crop incident estimate for each crop in the subsets list
# for a temporal window of size 5.
# this is a multicore, operation

# all results and downloaded data is stored in Dir, the CDLRaster program will search this directory for 
# a directory named CDL_(state), where (state) is the name of the state.  If this directory is not found
# it will be created
#
# if CDL files are not present in this directory they will be downloaded from the cropscape data set

library(sp)
library(rgdal)
library(raster)

cdlToolsDir <- '~/src/cdlTools/'

source( sprintf('%s/getCDL.R', cdlToolsDir) )
source( sprintf('%s/cdlVars.R', cdlToolsDir) )
source( sprintf('%s/incident.R', cdlToolsDir ) )
source( sprintf('%s/movingWindow.R', cdlToolsDir ) )
source( sprintf('%s/rasterClusterApply.R', cdlToolsDir) )
source( sprintf('%s/cdlBrick.R', cdlToolsDir) )

#windowDir <- 'C:/Documents and Settings/lisijo/My Documents/Data/'
#macDir <- '/Users/jonathanlisic/data/CDL/'
macDir <- '/mnt/data/CDL/'
#linuxDir <- '/Rproj/substrata/data/CDL/'

#Dir <- linuxDir
#years <- 2007:2012
#State <- 'California'
#Fips <- 6 

Dir <- macDir
years <- 2008:2012
State <- 'RhodeIsland'
Fips <- 44 

win <- 5
#funcs <- c('incident','movingWindow','ma1')
funcs <- c('incident','ma1')

subsets <- list( cultivated, corn, soybeans, winterWheat, springWheat, durumWheat, cotton, pasture, water, nothing )  

# create a brick
CDLRaster <- cdlBrick(Dir, Years, State, Fips) 

writeRaster( CDLRaster, sprintf('%sCDL_%s/CDL_Brick_%02d.grd',Dir,State,Fips),format="raster", overwrite=TRUE)

# set the appropriate directory
beginCluster()

  for(i in 1:length(funcs)) {
    eval(parse(text=sprintf("func<-%s",funcs[i])))

    #run the code
    raster.cdlMethod <- rasterClusterApply( CDLRaster, cellFun=func, needed= list('win', 'subsets'), printLog =F, progress="text" )
    
    # write the data out
    writeRaster( raster.cdlMethod , sprintf('%sCDL_%s/CDL_Brick_%s_%02d.grd',Dir,State,funcs[i],Fips),format="raster", overwrite=TRUE )
  }

endCluster()
  





