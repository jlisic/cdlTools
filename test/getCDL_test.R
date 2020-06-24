library(cdlTools)
library(rgdal)


data(stateNames)

for( state in stateNames$STATENAME) {
  cat(sprintf("*** %s ***\n", state))
  tic(sprintf("*** %s ***\n", state))
  getCDL(state,2006:2018,location="/Volumes/data/CDL/CDL/",ssl.verifypeer = FALSE)
  toc()
}
#zz <- createComparableCDL(z,baseIndex=1,progress="text")


