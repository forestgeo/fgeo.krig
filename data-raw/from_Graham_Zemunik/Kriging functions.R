##################################
# Kriging functionality for CTFS
#
# At the top level, simply calling the function GetKrigedSoil will calculate
# a "best" semivariogram to use and krige the soil data without any other input

##################
# GetKrigedSoil
#
# Kriges the soil data from "df.soil" using soil variable "var",
# following the methodology of the John et al. (2007) paper.
#
# By default the best kriging parameters found via the geoR variogram
# function are used, but specified parameters can by used via the
# "krigeParams" argument
# geoR has two main kriging functions: ksLine and krige.conv. The 
# argument "useKsLine" specifies whether to use the ksline function or not.
#
# Parameters:
#   df.soil: the data frame with the points, coords specified in the
#            columns gx, gy.
#   var: the variable/column in df.soil to krige
#   gridSize: points are kriged to the centre points of a grid of this size
#   krigeParams: if you want to pass specified kriging parameters; see
#                GetAutomatedKrigeParams for each parameter
#   xSize: X size/length of the plot
#   ySize: Y size/length of the plot
#   breaks: breaks/intervals used to calculate the semivariogram, which only
#           happens if krigeParams=NULL (default)
#   useKsLine: see above
#
# Returns a list with the following items:
#   df: data frame of kriged values (column z) at each grid point (x, y)
#   df.poly: data frame of the polynomial surface fitted to the raw data
#   lambda: the "lambda" value used in the Box-Cox transform of the raw data
#   vg: the variogram parameters used for the kriging
#   vm: minimum loss value returned from the geoR variofit function
GetKrigedSoil <- function( df.soil, var="P", gridSize=20, 
                           krigeParams=NULL, xSize=1000, ySize=500,
                           breaks=ExpList( 2, 320, 30 ),
                           useKsLine=T )
{
  df <- df.soil[ , c("gx", "gy", var) ]
  names( df )[ 3 ] <- "z"
  
  # This follows a similar methodology to the John 2007 paper:
  # 1. the data is transformed based on the optimal boxcox transform
  # 2. a polynomial regression curve is fitted - a second order
  #    polynomial is used
  # 3. the residuals from the polynomial fit are kriged: two steps, a)
  #    get a variogram, b) do the kriging
  # 4. the kriged values are added to the polynomial fit and they
  #    are backtranformed as required
  
  # The lambda for the box-cox transform is restricted to 0, 0.5 and 1.
  # Data with 0's in there are handled by the addition of a small constant
  # in the regression
  bc <- BoxCoxTransformSoil( df )
  df <- bc$df
  
  polyfit <- GetPolynomialFit( df, gridSize=gridSize, xSize=xSize, ySize=ySize )
  
  # Get the variogram parameters
  # If a polynomial fit was possible then the parameters come from 
  # the residuals of the polynomial fit
  # Otherwise, the raw data is used (a failure to fit the polynomial
  # most likely indicates that no trend exists, so trend removal isn't
  # necessary)
  if ( is.null(polyfit$mod) ) {
    df.krig <- df
  } else {
    df.krig <- cbind( polyfit$df.orig[,c("gx","gy")], z=resid( polyfit$mod ) )
  }
  
  require( geoR )
  geod <- as.geodata( df.krig )
  if ( is.null( krigeParams ) ) {
    params <- GetAutomatedKrigeParams( geod, breaks=breaks )
  } else {
    params <- krigeParams
    if ( !("kappa" %in% names(params)) ) params$kappa <- 0
  }
  
  # Do the kriging
  if ( useKsLine ) {
    krig <- ksline( geod, locations=polyfit$df.interpolated[,c("gx","gy")],
                    cov.pars=c(params$sill, params$range), cov.model=params$model,
                    nugget=params$nugget, kappa=params$kappa, lambda=1 )
  } else {
    krig <- krige.conv( geod, locations=polyfit$df.interpolated[,c("gx","gy")],
                        krige=krige.control(cov.pars=c(params$sill, params$range), cov.model=params$model,
                                            nugget=params$nugget, kappa=params$kappa, lambda=1, aniso.pars=NULL) )
  }
  # Add the kriged results to the trend if necessary
  df.pred <- polyfit$df.interpolated
  if ( is.null(polyfit$mod) ) {
    df.pred$z <- krig$predict
  } else {
    df.pred$z <- df.pred$z + krig$predict
  }
  
  # Back transform (if required)
  df.pred <- InvBoxCoxTransformSoil( df.pred, bc$lambda, bc$delta )
  
  names( df.pred ) <- c( "x", "y", "z" )
  
  # Return all useful data
  return( list( df=df.pred, df.poly=polyfit$df.interpolated,
                lambda=bc$lambda, vg=params$vg, vm=params$minVM ) )
}

###############
# ExpList
#
# Returns a list of n values which exponentially
# increases from first to last
ExpList <- function( first, last, n )
{
  v <- vector()
  m <- 1 / (n - 1)
  quotient <- (last / first)^m
  
  v[1] <- first
  for ( i in 2:n ) v[i] <- v[i - 1] * quotient
  
  v
}

##############
# GetAutomatedKrigeParams
# 
# Uses the geoR function variofit, with a range of variogram models, to
# find the "best" variogram parameters for the given geodata object
#
# Returns a list of the best fitted variogram parameters:
#   nugget, sill, range, kappa, model
#   and the minimum fit error, minVM, and the variogram, vg
GetAutomatedKrigeParams <- function( geod, trend="cte", breaks=ExpList( 2, 320, 30 ) )
{
  require(geoR)
  
  # The default breaks argument is set to have more points where the curve
  # rises the most and exponentially fewer at large distances
  # This means that the curve fitting is not overly biased by points
  # beyond the effective maximum range
  
  # Several different models are tested; the one with the lowest least
  # squares error is chosen
  vg <- variog( geod, breaks=breaks, pairs.min=5, trend=trend )
  varModels <- c( "exponential", "circular", "cauchy", "gaussian" ) #, "wave" )
  minValue <- NULL
  minVM <- NULL
  startRange <- max( breaks ) / 2
  initialVal <- max( vg$v ) / 2
  for ( i in 1:length(varModels) ) {
    vm <- variofit( vg, ini.cov.pars=c( initialVal, startRange ), 
                    nugget=initialVal, cov.model=varModels[i] )
    if ( is.null(minValue) || vm$value < minValue ) {
      minValue <- vm$value
      minVM <- vm
    }
  }
  return( list( nugget=minVM$nugget, sill=minVM$cov.pars[1], 
                range=minVM$cov.pars[2], kappa=minVM$kappa, model=minVM$cov.model,
                minVM=minVM, vg=vg ) )
}

################
# GetPolynomialFit
#
# Given a data frame, df, with columns specifying the x, y coordinates
# and a quantity at each coord, a 2D polynomial surface is fitted to the
# df and the values at grid location (specified by gridSize) are interpolated
# using nls.
# Returns a list of the original df, the interpolated values at each grid point,
#         and the nls model, if the nls fit succeeded
# No interpolated locations are returned if nls failed to model the surface,
# in which case the model attribute is set to NULL
GetPolynomialFit <- function( df, gridSize=20, xSize=1000, ySize=500 )
{
  # The data frame is assumed to be x, y, z
  names(df) <- c("gx", "gy", "z")
  
  model <- NULL
  tryCatch( model <- nls( z ~ PolynomialSurfaceOrder2(gx, gy, a, b, c, d, e, f ), 
                          data=df, start=list(a=0.1, b=0.1, c=0.1, d=0.1, e=0.1, f=0.1), 
                          trace=F, control=nls.control(maxiter=200,minFactor=1/4096) ),
            error = function(e) {} )
  
  halfGrid <- gridSize/2
  df.locations <- expand.grid( gx=seq( halfGrid, xSize-halfGrid, by=gridSize ),
                               gy=seq( halfGrid, ySize-halfGrid, by=gridSize ) )
  if ( !is.null(model) ) df.locations$z <- predict( model, newdata=df.locations )
  
  return( list( df.orig=df, df.interpolated=df.locations, mod=model ) )
}

################
# PolynomialSurfaceOrder2
#
# Returns a polynomial 2nd order surface (x,y) defined by the parameters a to f
PolynomialSurfaceOrder2 <- function( x, y, a, b, c, d, e, f )
{ 
  a + b*x + c*y + d*x*y + e*x^2 + f*y^2
}

# BoxCoxTransformSoil
# Finds the optimal Box-Cox transform parameters for the data in data
# frame, df, with columns specifying the x, y coordinates
# and a quantity at each coord, whilst restricting the lambda value
# to 0, 0.5 and 1. Only data >=0 can be transformed. Values = 0 are
# handled by adding a small value, delta, which if used is returned
# as the delta argument.
# Returns a list of the original df, the delta value 
#         and the the delta value
#
BoxCoxTransformSoil <- function( df )
{
  lambda <- 1
  delta <- 0
  
  if ( ncol(df) >= 3 ) {
    # Sanity checking and enforcement of the structure
    if ( !identical( names(df)[1:3], c("gx", "gy", "z") ) ) {
      names(df)[1:3] <- c("gx", "gy", "z")
    }
    
    require(MASS)
    if ( min( df$z ) >= 0 ) { # boxcox will complain about -ve values
      if ( min( df$z ) == 0 ) {
        # add a small amount to allow transforms to work
        delta = 0.00001
        df$z <- df$z + delta
      }
      bc <- boxcox( z ~ gx + gy, data=df, lambda=c(0, 0.5, 1), plotit=F)
      lambda <- bc$x[ which( bc$y == max(bc$y) ) ]
      lambda <- round( lambda / 0.5 ) * 0.5  # Get lambda in multiples of 0.5
      if ( lambda == 0 ) {
        df$z <- log( df$z )
      } else if ( lambda == 0.5 ) df$z <- sqrt( df$z )
    }
  }
  # Return the data and the parameters
  list( df=df, lambda=lambda, delta=delta )
}

# InvBoxCoxTransformSoil
# Performed the inverse of the Box-Cox transform given the data, df, 
# the lambda value and and delta added to the data
# Return the df with the transformed data, from the z column
InvBoxCoxTransformSoil <- function( df, lambda, delta )
{
  if ( lambda == 0 ) {
    df$z <- exp( df$z )
  } else if ( lambda == 0.5 ) df$z <- df$z ^ 2
  # Take away the delta offset
  df$z <- df$z - delta
  
  df
}

