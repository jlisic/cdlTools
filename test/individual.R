library(cdlTools)
library(raster)

# Get data for California, 2013 and 2015
bbox <- c(130783,2203171,153923,2217961)
resx <- 30 
resy <- 30 
year <- 2020
crs <- 'epsg:102004'
a <- getCDL_bbox(year,bbox,res=c(resx,resy),crs=crs)

print(a)
plot(a)
print(summary(a))
