\name{powcor.shrink}
\alias{powcor.shrink}


\title{Fast Computation of the Power of the Shrinkage Correlation Matrix}
\description{
  The function \code{powcor.shrink} efficiently computes the \code{alpha}-th power
  of the shrinkage correlation matrix produced by \code{\link{cor.shrink}}.
}
\usage{
powcor.shrink(x, alpha, lambda, w, collapse=FALSE, verbose=TRUE)
}
\arguments{
  \item{x}{a data matrix}
  \item{alpha}{exponent}
  \item{lambda}{the correlation shrinkage intensity (range 0-1).
                If \code{lambda} is not specified (the default) it is estimated
		using an analytic formula from Sch\"afer and Strimmer (2005) 
		- see \code{\link{cor.shrink}}.  
		For \code{lambda=0} the empirical correlations are recovered.}
  \item{w}{optional: weights for each data point - if not specified uniform weights are assumed
            (\code{w = rep(1/n, n)} with \code{n = nrow(x)}).}	
  \item{collapse}{return vector instead of matrix if estimated or specified \code{lambda} equals 1.} 
  \item{verbose}{output status while computing (default: TRUE)}
}
\details{
  This function employs the following identity to compute the matrix power of the correlation
  matrix.

  Apart from a scaling factor the shrinkage correlation matrix computed 
   by \code{\link{cor.shrink}}  takes
  on the form

    \deqn{Z = I_p + V M V' .}   

  Note that \code{Z} is of size \code{p} times \code{p}
  whereas \code{M} is a matrix of size \code{m} times \code{m}, where \code{m} is the rank of
  the matrix \code{Z}.  In order to calculate the \code{alpha}-th power of \code{Z}
  the identity

    \deqn{Z^\alpha = I_p - V (I_m -(I_m + M)^\alpha) V'}

  requires only the computation of the \code{alpha}-th power of the  matrix
  \eqn{I_m + M}.  This trick enables substantial computational savings when the number
  of samples is much smaller than the number of observations.
   
   Note that the above identity is related but not identical to the Woodbury matrix
   identity for inversion of a matrix.
   For \eqn{alpha=-1} the above identity reduces to

    \deqn{Z^{-1} = I_p - V (I_m -(I_m + M)^{-1}) V' ,}

   whereas the Woodbury matrix identity equals

    \deqn{Z^{-1} = I_p - V (I_m + M^{-1})^{-1} V' .}

}
\value{
  \code{powcor.shrink} returns a matrix containing the  output from \code{\link{cor.shrink}} 
  taken to the power \code{alpha}. 
    
}
\author{
  Korbinian Strimmer (\url{http://strimmerlab.org}).
  
}

\seealso{\code{\link{invcor.shrink}}, \code{\link{cor.shrink}}, \code{\link{mpower}}.}

\examples{
\dontrun{

# load corpcor library
library("corpcor")

# generate data matrix
p = 2000
n = 10
X = matrix(rnorm(n*p), nrow = n, ncol = p)

lambda = 0.23  # some arbitrary lambda

### computing the inverse ###
# slow
system.time(
  (W1 = solve(cor.shrink(X, lambda=lambda)))
)

# very fast
system.time(
  (W2 = powcor.shrink(X, alpha=-1, lambda=lambda))
)

# no difference
sum((W1-W2)^2)

### computing the square root ###

system.time(
  (W1 = mpower(cor.shrink(X, lambda=lambda), alpha=0.5))
)

# very fast
system.time(
  (W2 = powcor.shrink(X, alpha=0.5, lambda=lambda))
)

# no difference
sum((W1-W2)^2)


### computing an arbitrary power (alpha=1.23) ###

system.time(
  (W1 = mpower(cor.shrink(X, lambda=lambda), alpha=1.23))
)

# very fast
system.time(
  (W2 = powcor.shrink(X, alpha=1.23, lambda=lambda))
)

# no difference
sum((W1-W2)^2)

}
}
\keyword{multivariate}