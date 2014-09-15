tifListProp <-
function(fileNames) {

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
