\name{fips}
\alias{fips}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Function to construct a raster list from multiple years of CDL data.
  %%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
fips(x, level="STATE", to)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
    Vector of either character or numeric values.  State abreviations are converted to numeric fips.  Numeric fips are converted to State abreviations.  Fips in character format are converted to State aberviations.
  }
  \item{level}{
  "STATE" or "COUNTY" are supported, it sets evaluation of fips at either the state or county level.  Default is "state".
  }
  \item{to}{
  "FIPS" or "ABBREVIATION" are supported, it sets evaluation of fips at either the state or county level.  Default is "state".
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
  
  # get state fips for California 
  fips("CA")

  # get state abreviation for California 
  fips(6)

  # get state abreviation for California and Indiana 
  fips( c( "06", "18") ) 

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
