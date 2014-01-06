# This is a function that will return a cdl aggregation given a polygon and a CDL data set

############################## Libraries #######################################
library(rgdal)
library(sp)
library(foreign)
library(raster)
library(snow)


############################## Global Constants ################################


source('~/src/cdlTools/cdlVars.R')

initYear <- 1997 
ST    <- 'ND'
STATE <- 'NorthDakota'
FIPS <- 38 
  
macDir <- '/mnt/data/CDL/'
Dir <- macDir 

subset.names <- list( "cultivated", "corn", "soybeans", "winterWheat", "springWheat", "durumWheat", "cotton", "pasture","water","nothing")
funcs <- c('movingWindow','incident')

############################## Functions #######################################

# this is a function that aggregates over multiple years
aggregateCDL <- function(
  r, 
  sqMiles,
  getNA=F  
  ) { 

  x.res <- res(r)[1] 
  y.res <- res(r)[2] 

  x.scale <- round(sqMiles * 1609.34/ x.res )
  y.scale <- round(sqMiles * 1609.34/ y.res )
 
  cat(sprintf("  original res:\n    x = %d meters\n    y = %d meters\n", x.res, y.res ) )   
  cat(sprintf("  scale factor:\n    x =  %d y =  %d\n",x.scale, y.scale) )
  
  cat(sprintf("  rescale to approx %f square miles\n",sqMiles) )
  cat(sprintf("  final size:\n    x = %f miles \n    y = %f miles\n", 
                x.res * x.scale / 1609.34,
                y.res * y.scale / 1609.34) )
                

  maxPixel <<- x.res * x.scale * y.res * y.scale 
  acres <<- maxPixel * 640 / (1609.34^2)



  if(getNA == F ) {
    r <- raster::aggregate( r, fact= c(x.scale, y.scale), fun=sum, na.rm=T,progress='text' )
  } else { 
    getNA.func <- function(x,...){
      return(sum(is.na(x)) )
    }

    r <- raster::aggregate( r, fact= c(x.scale, y.scale), fun=getNA.func, na.rm=F, progress='text' ) 
  }

  r.coord <<- coordinates(r)

  return( values(r) )

}


############################## Script #######################################


if( F ) {

for(k in 1:length(funcs)) {

  r <- brick( sprintf('%sCDL_%s/CDL_Brick_%s_%02d.grd',Dir,STATE,funcs[k],FIPS),format="raster" )
  r.raw <- brick( sprintf('%sCDL_%s/CDL_Brick_%02d.grd',Dir,STATE,FIPS),format="raster" )
  
  years <- initYear:(initYear + nlayers(r)/length(subset.names) - 1)
  
  # aggregate over each year
  for( y in 1:length(years)) {
    year <- years[y]
    print(sprintf("Working on %s : %d",STATE,year))
  
    for( l in 1:length(subset.names) ) {
     
      # aggregate over each commodity 
      print(subset.names[l]) 
      if( l == 1) {
        agg <- aggregateCDL(  
          raster( r, layer=y - 1 + l), 
          sqMiles = 1
        )
      } else {
        agg <- cbind(agg,aggregateCDL(  
          raster( r, layer=y - 1 + l), 
          sqMiles = 1
        ))
      } 
  
    } # finish with substs
        
    agg <- cbind(agg,aggregateCDL(  
        raster( r.raw, layer=1), 
        sqMiles = 1,
        getNA=T
      ))
      
    agg <- cbind(year,agg,maxPixel,acres,r.coord)
    colnames(agg) <- c('initYear',subset.names,'NA','maxPixel','acres','x','y')
  
    if(y == 1) {
      result <- agg 
    } else {
      result <- rbind( agg, result)
    }
  
  } # finish with years
  
  
  write.csv(result, file = sprintf("%sCDL_Summary/CDL_FAKESEG_SUMMARY_%s_%02d.csv",Dir,funcs[k],FIPS))
  
}

}


# all years

r <- brick( sprintf('%sCDL_%s/CDL_Brick_%02d.grd',Dir,STATE,FIPS),format="raster" )

years <- initYear:(initYear + nlayers(r)/length(subset.names) - 1)

# aggregate over each year
for( y in 1:length(years)) {
  year <- years[y]
  print(sprintf("Working on %s : %d",STATE,year))

  for( l in 1:length(subset.names) ) {
   
    # aggregate over each commodity 
    print(subset.names[l]) 
    if( l == 1) {
      agg <- aggregateCDL(  
        raster( r, layer=y - 1 + l), 
        sqMiles = 1
      )
    } else {
      agg <- cbind(agg,aggregateCDL(  
        raster( r, layer=y - 1 + l), 
        sqMiles = 1
      ))
    } 

  } # finish with substs
      
  agg <- cbind(agg,aggregateCDL(  
      raster( r, layer=1), 
      sqMiles = 1,
      getNA=T
    ))
    
  agg <- cbind(year,agg,maxPixel,acres,r.coord)
  colnames(agg) <- c('initYear',subset.names,'NA','maxPixel','acres','x','y')

  if(y == 1) {
    result <- agg 
  } else {
    result <- rbind( agg, result)
  }

} # finish with years


write.csv(result, file = sprintf("%sCDL_Summary/CDL_FAKESEG_SUMMARY_%s_%02d.csv",Dir,"ALL",FIPS))
  





