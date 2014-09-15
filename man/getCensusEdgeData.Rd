\name{getCensusEdgeData}
\alias{getCensusEdgeData}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Get U.S. Census Edge Data
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
getCensusEdgeData(states, counties, location)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{states}{
%%     ~~Describe \code{states} here~~
}
  \item{counties}{
%%     ~~Describe \code{counties} here~~
}
  \item{location}{
%%     ~~Describe \code{location} here~~
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
function (states, counties, location) 
{
    removeFlag <- F
    if (length(states) != length(counties)) {
        print("states and counties do not have same length")
        return(NA)
    }
    if (missing(location)) {
        removeFlag <- T
        urls <- list()
        censusFtp <- "http://www2.census.gov/geo/tiger/TIGER2012/EDGES/"
        for (i in 1:length(states)) {
            urls[i] <- sprintf("\%stl_2012_\%02d\%03d_edges.zip", 
                censusFtp, states[i], counties[i])
        }
        tiger.zip.files <- download.files(urls)
        location <- tempdir()
        for (i in 1:length(states)) {
            if (tiger.zip.files$status[i] == 0) {
                unzip(tiger.zip.files$filenames[[i]], exdir = location)
                unlink(tiger.zip.files$filenames[[i]])
            }
        }
    }
    result <- list()
    for (i in 1:length(states)) {
        result[i] <- readOGR(location, sprintf("tl_2012_\%02d\%03d_edges", 
            states[i], counties[i]))
        if (removeFlag) {
            unlink(sprintf("\%s/tl_2012_\%02d\%03d_edges.*", location, 
                states[i], counties[i]))
        }
    }
    return(result)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
