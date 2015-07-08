\name{recoder}
\alias{recoder}
\title{
Simple and Handy Recoder
}
\description{
A flexible function for recoding a variable. It can be used for anything from simple explicit recoding to piecewise-defined transformations.
}
\usage{
recoder(var, recode, other = NULL, na = NA, as.what = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{var}{
\code{var} is a variable (vector) being recoded.
}
  \item{recode}{
\code{recode} contains the instructions for how the recoding is done. Each instruction is in the form of \code{condition: newvalue} and instrunctions must be separated by semicolons (\code{;}). 
}
  \item{other}{
  When \code{other=NULL}, elements that do not satisfy any of the coditions in the instructions given by \code{recode} will by defaul remain unchanger, otherwise they will be changed to \code{other}
}
  \item{na}{
  When \code{na=NULL}, \code{NA} values will not be changed in the vector, otherwise, they will be changed to \code{na}.

}
  \item{as.what}{
  if \code{as.what} is specified, the final vector is forced to be of the given type. For example, it will be made a factor if \code{as.what= "factor"} is specified.
}
}
\details{
\code{recode} contains the instructions for how the recoding is done. Each instruction is in the form of \code{condition: newvalue} and instrunctions must be separated by semicolons (\code{;}). 
E.g., \code{1:2; 2:-1; 3:0} will change all ones to two, twos to negative one, and threes to zero. Instruction can include compound conditions and functions for newvalue expressed in terms of \code{$}. For example, "\code{<0:0;} \code{>2:4;} \code{>=0 & <=2 : $^2}" will give zero for all the values below 0, 4 for all the values above 2, and squared values for anything between 0 and 2.

The input can be other types beside numeric. For characters and factors, it is important that the form \code{"old":"new"} includes quotations around both the left-hand side and the right-hand side.

When the input is a factor, recoding works as expected, but new levels cannot be assigned. In order to assign new levels, the input vector should be made into something else (e.g., a character) and then the argument \code{as.what} could be set to \code{"factor"} to get a factor as the end result.
}

\value{
The recoded vector is returned.
}
\author{
Ali Sanaei
}

\seealso{
\code{\link{cut}}, \code{\link[car]{recode}} 
} 


\examples{
u = rnorm(1000)
u.2 = recoder(u,'<-2: -2; >2 : 2' ,other = 0)
plot(u,u.2)

# use a function of 'x' for assigning new values based on old values
u.3 = recoder(u,'<-2: -2; >2 : 2; >=-2 & <=2 : $^3/4') 
# NOTE: instructions in recode are executed from left to right
# So u.3 and u.4 are the same
u.4 = recoder(u,'<-2: -2; >=-2 : $^3/4;  >2 : 2')
plot(u, u.3)

# another example of a piecewise defined function
x = runif(1000,-1,10)
y = recoder(x,'>0 & <1: sqrt($); >=1 : 1+log($)' ,other=NA) 
plot(y~x)
table(is.na(y))

# we can also create other types of variables
k = rpois(n = 10000, lambda = 3)
evodd = recoder(k \%\% 2, '0: "even"; 1: "odd" ')
table(evodd)

# the output could also be made a factor, etc., using "as.what" argument
evodd.factor = recoder(k \%\% 2, '0: "even"; 1: "odd" ', as.what='factor')

# characters are recoded similarly
str = c('a','b','x','z',NA) 
str2 = recoder(str, '"x":"c"; "z":"d" ')
str3 = recoder(str, '"a":1; "b":2; "x":3; "z":4 ')
print(str3) #note that this is still not numeric
num3 = recoder(str, '"a":1; "b":2; "x":3; "z":4 ', as.what='numeric')
print(num3)

# when input is a factor, the levels are fixed
f1 = factor( c('a','b','x','z',NA)  )
f2 = recoder( f1, '"x":"a"; "z":"b" ')

\dontrun{
f3 = recoder(f1, '"x":"c"; "z":"d" ') # "c" and "d" are not recognized
}
f3 = recoder( as.character(f1), '"x":"c"; "z":"d" ' , as.what= "factor")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{recode}
