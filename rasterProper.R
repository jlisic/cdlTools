library(sp)
library(rgdal)
library(raster)


source('~/src/cdlTools/getCDL.R')

# set the appropriate directory


#resolutions <- c(30,30,56) # used for file name
# --------------------------------- FUNCTIONS ---------------------------------------

# We need a function that will get us resolution, min, max, ncols, nrows, from a specified file
tifListProp <- function(fileNames) {

  n <- length(fileNames)
 
  xmin <- matrix(0,nrow=n,ncol=1)
  ymin <- matrix(0,nrow=n,ncol=1)
  xmax <- matrix(0,nrow=n,ncol=1)
  ymax <- matrix(0,nrow=n,ncol=1)
  xsize <- matrix(0,nrow=n,ncol=1)
  ysize <- matrix(0,nrow=n,ncol=1)
  xres <- matrix(0,nrow=n,ncol=1)
  yres <- matrix(0,nrow=n,ncol=1)
 
  #read file
  for(i in 1:n){
  tifProp <- raster(fileNames[i])

   # this is the minimum projection variables (AEA)
    xmin[i] <- slot(slot(tifProp,'extent'),'xmin')
    ymin[i] <- slot(slot(tifProp,'extent'),'ymin')
    xmax[i] <- slot(slot(tifProp,'extent'),'xmax')
    ymax[i] <- slot(slot(tifProp,'extent'),'ymax')
      
    # max column size
    xsize[i] <- ncol(tifProp)
    ysize[i] <- nrow(tifProp)
    
    # resolution
    xres[i] <- xres(tifProp) 
    yres[i] <- yres(tifProp) 
  }

  result <- cbind( xmin,ymin,xmax,ymax,xsize,ysize,xres,yres ) 
  colnames(result) <- c('xmin','ymin','xmax','ymax','xsize','ysize','xres','yres') 
  return(result)
} 


# function that takes a set of years, and a specific state / fips combination and returns
# a raster brick, intermediate states are saved in Dir
cdlBrick  <- function( Dir, Years, State, Fips) {

  #recall we are going from NW to SE.
  #   (startx,starty) ---> x increases in this direction
  #     |
  #     v
  #     y decreases in this direction                        (stopx,stopy)
  
  # create a list of raster objects
  cdl.fileNames <- c()
  for (i in 1:length(years)) {
    year <- years[i]
    cdl.fileName <- sprintf('%sCDL_%s/CDL_%d_%d.tif',Dir,State,year,Fips) 
  
    # check if the file exists, if it doesn't download it
    if( !file.exists( cdl.fileName ) ) { 
      download.files(
        getCDLURL.fips(Fips,year),
        list( cdl.fileName )
      ) 
    } 
  
    cdl.fileNames <- c( cdl.fileNames, cdl.fileName )
  }
  
  cdl.properties <- cbind(years,tifListProp( cdl.fileNames ))
  
  
  
  
  # we want to create a RasterStack so we need matching extents and resolutions, therefore we will resample
  
  # figure out which years to resample based on the base year ( worse resolution )
  
  base.index <- which.max( cdl.properties[,'xres'] )
  
  cdl.resampleList <- as.matrix(apply(cdl.properties, 1, function(x) x != cdl.properties[base.index,]))
  cdl.resampleList <- colSums(cdl.resampleList[-1,])
  cdl.resampleList <- cdl.resampleList > 0
  
  print(sprintf("The following years need to be resampled: %s", paste(years[cdl.resampleList],collapse= " ") ))
  
  
  
  # start multicore
  beginCluster( 8, type='SOCK')
  
  cdl.baseRaster <- raster(cdl.fileNames[base.index])
  
  
  for( index in which(cdl.resampleList ==T) ) {
  
    year <- years[index]
    fileName <- cdl.fileNames[index]  
  
    print(sprintf("Starting year %d", year))
  
    # first check if the resample file already exists
    if( file.exists( sprintf('%sCDL_%s/CDL_%d_%d_resampled.tif',Dir,State,year,Fips))) {
      print(sprintf("File exists skipping for year %d", year))
    } else {
  
      cdl.reproj <- raster(fileName) 
   
      print(proj4string(cdl.reproj))
      print(proj4string(cdl.baseRaster))
  
      if ( proj4string(cdl.reproj) != proj4string(cdl.baseRaster) ) { 
        print(sprintf("Requires Reprojection year %d", year))
        cdl.reproj <- projectRaster( cdl.reproj, cdl.baseRaster,progress="text") 
        print(sprintf("Resampling year %d", year))
        cdl.resampled <- resample( cdl.reproj, cdl.baseRaster, method='ngb', progress="text") 
      } else {
        print(sprintf("Resampling year %d", year))
        cdl.resampled <- resample( cdl.reproj, cdl.baseRaster, method='ngb', progress="text") 
      }
    
    
      print(sprintf("Writing year %d", year))
     
      writeRaster( cdl.resampled, 
                   sprintf('%sCDL_%s/CDL_%d_%d_resampled.tif',Dir,State,year,Fips),
                   'GTiff',
                   overwrite=T )
    }
    cdl.fileNames[index] <- 
                 sprintf('%sCDL_%s/CDL_%d_%d_resampled.tif',Dir,State,year,Fips)
    
  }
  
  endCluster()
  
  # update our properties matrix
  cdl.properties <- cbind(years,tifListProp( cdl.fileNames ))
  
  
  
  ## now for each segment we build a brick, and save it 
  
  # first to make a brick to work with
  for( i in 1:length(cdl.fileNames) ) {
  
    print( sprintf("Opening New files: %s", cdl.fileNames[i]))
  
    if( i == 1) {
      a <- list(raster(cdl.fileNames[i]))
    } else {
      a[[i]] <- raster(cdl.fileNames[i])
      projection(a[[i]]) <-proj4string( a[[1]] ) 
    }
   
  }
  
  
  ### This takes a while so use it sparingly
  print("Creating Brick")
  CDLRaster <- brick( unlist( a ) ) 

  return(CDLRaster)
}


