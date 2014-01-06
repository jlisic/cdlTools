# acf
library(ggplot2)



plotACF <- function(a, commodities, maxNAPercent, x.res, y.res, windowSize, Dir, prefix ) {

  # first remove anything past the NA threshold
  maxNAPixel <- x.res * y.res * (1-maxNAPercent/100)  
  a <- a[ a[,'NA'] < maxNAPixel,] 
  
  
  yearsVector <- a[,'initYear']
  
  for( commodity in commodities ) { 
  
    # get the unique sorted years
    yearsVector <- a[,'initYear']
    years <- sort(unique(yearsVector))
    n.years <- length(years)
    
    
    # calculate the per unit ACF
    if( n.years > 1 ) {
      a.years <- a[yearsVector == years[1],commodity] 
      a.xy    <- a[yearsVector == years[1],c('x','y')] 
    
      for( i in 2:n.years ) {
        a.years <- cbind( a.years, a[yearsVector == years[i],commodity] ) 
      }
    
      # this mess applies the acf to each observation over the set of years 
      a.acf <- t(apply(a.years,1,function(x) return( c(acf(x,plot=F,type='correlation')$acf))))
      colnames(a.acf) <- sprintf("lag%d",1:length(a.acf.mean) )
      a.df <- as.data.frame( cbind( a.xy, a.acf ) )
    
      #conditioned on x% cultivated
      for( condCap in c(.75, .50, .25, 0) ) {
        cultCap <- x.res * y.res * condCap * windowSize
        a.cult  <- ( a[,c('cultivated')] >= cultCap )[ yearsVector == years[1] ]   
    
        a.df.cult <- a.df[a.cult,]
        a.df.mean <- colMeans(a.df.cult[,c(-1,-2)],na.rm=T)
    
        #create ggplot
        p <- ggplot(a.df.cult, aes(x,y))
        for( k in 1:length(a.acf.mean) ) { 
          pdf( file = sprintf("%s%s_%s_lag%s_minCult%f.pdf", Dir, prefix, commodity, k, condCap) )
          print( 
                p + geom_point( aes_string(color = sprintf("lag%d",k) ) ) + scale_color_gradient2(limits=c(-1,1))  
             ) 
          dev.off()
        }
      } 
    }
  }
}



STATE <- "NorthDakota"
FIPS <- 38
macDir <- '/mnt/data/CDL/'
Dir <- macDir 

commodities <- c( "cultivated", "corn", "soybeans", "winterWheat", "springWheat", "durumWheat", "cotton", "pasture","water","nothing")
funcs <- c('movingWindow','incident')
maxNAPercent <- 20
x.res <- 29
y.res <- 29
windowSize <- 5


for( k in 1:length(funcs) ) {

  b <- read.csv( file = sprintf("%sCDL_Summary/CDL_FAKESEG_SUMMARY_%s_%02d.csv",Dir,funcs[k],FIPS))
  b <- b[,-1]
  names.b <- names(b)
  names.b[names.b == "NA."] <- "NA"
  names(b) <- names.b

  dir.create( sprintf("~/src/cdlTools/%s",STATE), showWarnings=F )
  plotACF( b, commodities, maxNAPercent, x.res, y.res, windowSize, sprintf("~/src/cdlTools/%s/",STATE), funcs[k] )

}
