\name{getCDLURL.fips}
\alias{getCDLURL.fips}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  GEt CDL URLs by fips.
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
getCDLURL.fips(x, years)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
}
  \item{years}{
%%     ~~Describe \code{years} here~~
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
function (x, years) 
{
    cdl.url.list <- list()
    for (year in years) {
        htmlResult <- unlist(strsplit(a <- getURL(sprintf("http://nassgeodata.gmu.edu:8080/axis2/services/CDLService/GetCDLFile?year=\%d&fips=\%02d", 
            year, x)), "<(/|)returnURL>"))
        if (length(htmlResult) != 3) {
            targetGeoTif <- NA
        }
        else {
            targetGeoTif <- htmlResult[2]
        }
        names(targetGeoTif) <- year
        cdl.url.list[[sprintf("\%s", year)]] <- targetGeoTif
    }
    return(cdl.url.list)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
