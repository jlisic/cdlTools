source("getCDL.R")

# example.R

#########################################################################################
# example
#########################################################################################

if( F ) {

## get bbox
#      min     max
#myBBox <- matrix( c(
#       130783, 153923,    # longitude AEA
#       2203171, 2217961   # latitude AEA
#       ), byrow=T, nrow=2)

myBBox <- matrix( c( 
       -106198, -103027,    # longitude AEA
       1991871, 1995191    # latitude AEA
       ), byrow=T, nrow=2)

## get urls
urlList <- getCDLURL( myBBox, 2000:2004 )

# example output
#
#  $`1996`
#  1996 
#    NA 
#  
#  $`1997`
#  1997 
#    NA 
#  
#  $`1998`
#  1998 
#    NA 
#  
#  $`1999`
#  1999 
#    NA 
#  
#  $`2000`
#                                                                                     2000 
#  "http://nassgeodata.gmu.edu/nass_data_cache/CDL_2000_clip_20130720164503_479136358.tif" 
#  
#  $`2001`
#                                                                                     2001 
#  "http://nassgeodata.gmu.edu/nass_data_cache/CDL_2001_clip_20130720164505_167134732.tif" 
#  
#  $`2002`
#                                                                                      2002 
#  "http://nassgeodata.gmu.edu/nass_data_cache/CDL_2002_clip_20130720164507_1634276841.tif" 
#  
#  $`2003`
#                                                                                      2003 
#  "http://nassgeodata.gmu.edu/nass_data_cache/CDL_2003_clip_20130720164508_1393797597.tif" 
#  
#  $`2004`
#                                                                                      2004 
#  "http://nassgeodata.gmu.edu/nass_data_cache/CDL_2004_clip_20130720164510_1362287265.tif" 

geoTiffs <- download.files(urlList, mode="wb")

# remove missing Tiffs
geoTiffs$urls      <- geoTiffs$urls[geoTiffs$status == 0]
geoTiffs$filenames <- geoTiffs$filenames[geoTiffs$status == 0]
geoTiffs$status    <- geoTiffs$status[geoTiffs$status == 0]




rasterList  <- createComparableCDL( filenames=geoTiffs$filenames, baseIndex=1)
rasterStack <- stack(rasterList)

# turn the raster image into points
rasterPoints <- rasterToPoints(rasterStack,spatial=T)
proj4string(rasterPoints) <- CRS(cdl.proj)
}



countyFile <- "gz_2010_us_050_00_20m"
countyDir <-  "E:\\Data\\Tiger\\county"

countiesOfInterest <- getStateCounty(coordinates(rasterPoints), cdl.proj, countyFile, countyDir)
edgeData <- getCensusEdgeData( as.numeric(as.character(countiesOfInterest$STATE)), as.numeric(as.character(countiesOfInterest$COUNTY)) )

## finished fetching data
for( i in 1:length(edgeData) ) {
  edgeData[[i]] <- spTransform( edgeData[[i]],CRS(cdl.proj) )
}









