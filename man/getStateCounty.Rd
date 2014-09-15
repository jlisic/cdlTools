\name{getStateCounty}
\alias{getStateCounty}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Get County Shape Files from a set of points in a given projection. 
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
getStateCounty(userPoints, userProj, countyFile, countyDir)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{userPoints}{
%%     ~~Describe \code{userPoints} here~~
}
  \item{userProj}{
%%     ~~Describe \code{userProj} here~~
}
  \item{countyFile}{
%%     ~~Describe \code{countyFile} here~~
}
  \item{countyDir}{
%%     ~~Describe \code{countyDir} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (userPoints, userProj, countyFile, countyDir) 
{
    require("prevR")
    countyShape <- readOGR(countyDir, countyFile)
    countyShape.proj <- spTransform(countyShape, CRS(userProj))
    centroid.county <- coordinates(countyShape.proj)
    xBar <- mean(userPoints[, "x"])
    yBar <- mean(userPoints[, "y"])
    countyOrder <- sort((centroid.county[, 1] - xBar)^2 + (centroid.county[, 
        2] - yBar)^2, index.return = T)$ix
    assignment <- vector(mode = "numeric", length = nrow(userPoints))
    for (i in 1:nrow(countyShape)) {
        countyIndex <- countyOrder[i]
        countyPolygon <- countyShape.proj[countyIndex, ]
        assignment[point.in.SpatialPolygons(userPoints[, "x"], 
            userPoints[, "y"], countyPolygon)] <- countyIndex
        if (is.na(table(assignment)["0"])) 
            break
    }
    targetCounties <- unique(assignment)
    if (0 \%in\% targetCounties) 
        print("Not all points assigned to counties")
    return(as.data.frame(countyShape)[targetCounties, ])
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
