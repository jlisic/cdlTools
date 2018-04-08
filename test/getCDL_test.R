library(cdlTools)
z <- getCDL('iowa',c(2006,2015),ssl.verifypeer = FALSE)

zz <- createComparableCDL(z,baseIndex=1,progress="text")


