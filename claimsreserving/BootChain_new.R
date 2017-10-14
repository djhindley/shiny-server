## Author: Markus Gesmann
## Copyright: Markus Gesmann, markus.gesmann@gmail.com
## Date:19/10/2008
## Amended by David Hindley 12 Sept 2017 to add in Progress bar for shiny app.
## The original code is part of ChainLadder package. 
## The code below is subject to the same license as that package - that is GNU General Public License Version 3.
## If you do not already have a copy of this license, write to 
## the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA or see http://www.gnu.org/licenses/
BootChainLadder2 <- function(Triangle, R = 1, process.distr=c("gamma", "od.pois"),Progbar){
  if(missing(Progbar)) {Progbar=FALSE}
  if(Progbar==TRUE) {withProgress(message = 'Running bootstrap', value = 0, {  ##put all code in withProgress if this option is selected
  
  if(!'matrix' %in% class(Triangle))
    Triangle <- as.matrix(Triangle)
  
  process.distr <- match.arg(process.distr)
  weights <- 1/Triangle
  
  triangle <- Triangle
  if(nrow(triangle) != ncol(triangle))
    stop("Number of origin periods has to be equal or greater then the number of development periods.\n")
  
  triangle <- checkTriangle(Triangle)
  output.triangle <- triangle
  
  m <- dim(triangle)[1]
  n <- dim(triangle)[2]
  origins <- c((m-n+1):m)
  
  ## Obtain the standard chain-ladder development factors from cumulative data.
  
  triangle <- array(triangle, dim=c(m,n,1))
  weights <-  array(weights, dim=c(m,n,1))
  inc.triangle <- getIncremental(triangle)
  Latest <- getDiagonal(triangle,m)
  
  ## Obtain cumulative fitted values for the past triangle by backwards
  ## recursion, starting with the observed cumulative paid to date in the latest
  ## diagonal
  
  dfs <- getIndivDFs(triangle)
  avDFs <- getAvDFs(dfs, 1/weights)
  ultDFs <- getUltDFs(avDFs)
  ults <- getUltimates(Latest, ultDFs)
  ## Obtain incremental fitted values, m^ ij, for the past triangle by differencing.
  exp.inc.triangle <- getIncremental(getExpected(ults, 1/ultDFs))
  ## exp.inc.triangle[is.na(inc.triangle[,,1])] <- NA
  exp.inc.triangle[is.na(inc.triangle[origins,,1])] <- NA
  ## Calculate the unscaled Pearson residuals for the past triangle using:
  inc.triangle <- inc.triangle[origins,,]
  dim(inc.triangle) <- c(n,n,1)
  unscaled.residuals  <- (inc.triangle - exp.inc.triangle)/sqrt(abs(exp.inc.triangle))
  
  ## Calculate the Pearson scale parameter
  nobs  <- 0.5 * n * (n + 1)
  scale.factor <- (nobs - 2*n+1)
  scale.phi <- sum(unscaled.residuals^2,na.rm=TRUE)/scale.factor
  ## Adjust the Pearson residuals using
  adj.resids <- unscaled.residuals * sqrt(nobs/scale.factor)
  
  
  ## Sample incremental claims
  ## Resample the adjusted residuals with replacement, creating a new
  ## past triangle of residuals.
  inc_ind<-23
  incProgress(1/inc_ind, detail="Sample from residuals") #1
  simClaims <- randomClaims(exp.inc.triangle, adj.resids, R)
  incProgress(1/inc_ind,detail="Apply CL to each simulation") #2
  ## Fit the standard chain-ladder model to the pseudo-cumulative data.
  ## Project to form a future triangle of cumulative payments.
  
  ## Perform chain ladder projection
  simCum <- makeCumulative(simClaims)
  incProgress(1/inc_ind) #3
  simLatest <- getDiagonal(simCum,nrow(simCum))
  incProgress(1/inc_ind) #4
  simDFs <- getIndivDFs(simCum)
  incProgress(1/inc_ind) #5
  simWghts <- simCum
  incProgress(1/inc_ind) #6
  simAvDFs <- getAvDFs(simDFs, simWghts)
  incProgress(1/inc_ind) #7
  simUltDFs <- getUltDFs(simAvDFs)
  incProgress(1/inc_ind) #8
  simUlts <- getUltimates(simLatest, simUltDFs)
  ## Get expected future claims
  ## Obtain the corresponding future triangle of incremental payments by
  ## differencing, to be used as the mean when simulating from the process
  ## distribution.
  incProgress(1/inc_ind,detail="Get expected future inc claims") #9
  simExp <- getIncremental(getExpected(simUlts, 1/simUltDFs))
  simExp[!is.na(simClaims)] <- NA
  processTriangle <-array(NA,c(n,n,R))
      if(process.distr=="gamma")
    {
      incProgress(1/inc_ind, detail="Adding Gamma process error") #10
      processTriangle[!is.na(simExp)] <- sign(simExp[!is.na(simExp)])*rgamma(length(simExp[!is.na(simExp)]), shape=abs(simExp[!is.na(simExp)]/scale.phi), scale=scale.phi)
    
    }
    
    if(process.distr=="od.pois"){
    incProgress(1/inc_ind, detail="Adding ODP process error") #11
  
    processTriangle <-  apply(simExp,c(1,2,3), function(x)
      ifelse(is.na(x), NA, sign(x)*rpois.od(1, abs(x), scale.phi)))
  }
  ##if(process.distr=="od.nbionm")
  ##  processTriangle <-  apply(simExp,c(1,2,3), function(x)
  ##          ifelse(is.na(x), NA, sign(x)*rnbinom.od(1, mu=abs(x), size=sqrt(1+abs(x)),d=scale.phi)))
  
  incProgress(1/inc_ind, detail="Process error added") #12
  processTriangle[is.na(processTriangle)] <- 0
  incProgress(1/inc_ind, detail="Collate results") # 13
  simExp[is.na(simExp)] <- 0
  IBNR.Triangles <- processTriangle
  incProgress(1/inc_ind) #14
  IBNR <- makeCumulative(IBNR.Triangles)[,n,]
  incProgress(1/inc_ind) #15
  dim(IBNR)<-c(n,1,R)
  incProgress(1/inc_ind) #16
  ParamDist <- makeCumulative(simExp)[,n,]
  incProgress(1/inc_ind) #17
  dim(ParamDist)<-c(n,1,R)
  incProgress(1/inc_ind) #18
  # Giuseppe Crupi
  # Generate and process Next Year triangle for one year re-reserving approach (Solvency 2 purpose)
  
  NYCost<-getNYCost(triangle[origins,,,drop=F],IBNR.Triangles,R)
  NYParamDist<-getNYCost(triangle[origins,,,drop=F],simExp,R)
  
  if(m>n){
    IBNR <- apply(IBNR, 3, function(x) c(rep(0, m-n),x))
    dim(IBNR) <- c(m,1,R)
    
    NYCost <- apply(NYCost, 3, function(x) c(rep(0, m-n),x))
    dim(NYCost) <- c(m,1,R)
    
    ParamDist <- apply(ParamDist, 3, function(x) c(rep(0, m-n),x))
    dim(ParamDist) <- c(m,1,R)
    
    NYParamDist <- apply(NYParamDist, 3, function(x) c(rep(0, m-n),x))
    dim(NYParamDist) <- c(m,1,R)
    
    IBNR.Triangles <- apply(IBNR.Triangles,3, function(x) rbind(matrix(0,m-n,n),x))
    dim(IBNR.Triangles) <- c(m,n,R)
    
    simClaims <- apply(simClaims,3, function(x) rbind(matrix(0,m-n,n),x))
    dim(simClaims) <- c(m,n,R)
  }
  incProgress(1/inc_ind,detail="Calc totals") #19
  IBNR.Totals <- apply(IBNR.Triangles,3,sum)
  incProgress(1/inc_ind) #20
  residuals <- adj.resids
  incProgress(1/inc_ind,detail="Return results") #21
  
  output <- list( call=match.call(expand.dots = FALSE),
                  Triangle=output.triangle,
                  f=as.vector(avDFs),
                  simClaims=simClaims,
                  IBNR.ByOrigin=IBNR,
                  IBNR.Triangles=IBNR.Triangles,
                  IBNR.Totals = IBNR.Totals,
                  ParamDist.ByOrigin=ParamDist,
                  NYCost.ByOrigin = NYCost,
                  NYParamDist.ByOrigin=NYParamDist,
                  #NYIBNR.ByOrigin = NYIBNR,
                  ChainLadder.Residuals=residuals,
                  process.distr=process.distr,
                  R=R)
  incProgress(1/inc_ind) #22
  class(output) <- c("BootChainLadder", class(output))
  return(output)
  setProgress(1,detail="Finished")
  }) #end with Progress bar
} #end of if statement for progress bar option
  ############now code if no progress bar selected
else {
  if(!'matrix' %in% class(Triangle))
    Triangle <- as.matrix(Triangle)
  
  process.distr <- match.arg(process.distr)
  weights <- 1/Triangle
  
  triangle <- Triangle
  if(nrow(triangle) != ncol(triangle))
    stop("Number of origin periods has to be equal or greater then the number of development periods.\n")
  
  triangle <- checkTriangle(Triangle)
  output.triangle <- triangle
  
  m <- dim(triangle)[1]
  n <- dim(triangle)[2]
  origins <- c((m-n+1):m)
  
  ## Obtain the standard chain-ladder development factors from cumulative data.
  
  triangle <- array(triangle, dim=c(m,n,1))
  weights <-  array(weights, dim=c(m,n,1))
  inc.triangle <- getIncremental(triangle)
  Latest <- getDiagonal(triangle,m)
  
  ## Obtain cumulative fitted values for the past triangle by backwards
  ## recursion, starting with the observed cumulative paid to date in the latest
  ## diagonal
  
  dfs <- getIndivDFs(triangle)
  avDFs <- getAvDFs(dfs, 1/weights)
  ultDFs <- getUltDFs(avDFs)
  ults <- getUltimates(Latest, ultDFs)
  ## Obtain incremental fitted values, m^ ij, for the past triangle by differencing.
  exp.inc.triangle <- getIncremental(getExpected(ults, 1/ultDFs))
  ## exp.inc.triangle[is.na(inc.triangle[,,1])] <- NA
  exp.inc.triangle[is.na(inc.triangle[origins,,1])] <- NA
  ## Calculate the unscaled Pearson residuals for the past triangle using:
  inc.triangle <- inc.triangle[origins,,]
  dim(inc.triangle) <- c(n,n,1)
  unscaled.residuals  <- (inc.triangle - exp.inc.triangle)/sqrt(abs(exp.inc.triangle))
  
  ## Calculate the Pearson scale parameter
  nobs  <- 0.5 * n * (n + 1)
  scale.factor <- (nobs - 2*n+1)
  scale.phi <- sum(unscaled.residuals^2,na.rm=TRUE)/scale.factor
  ## Adjust the Pearson residuals using
  adj.resids <- unscaled.residuals * sqrt(nobs/scale.factor)
  
  
  ## Sample incremental claims
  ## Resample the adjusted residuals with replacement, creating a new
  ## past triangle of residuals.
  
  simClaims <- randomClaims(exp.inc.triangle, adj.resids, R)
  ## Fit the standard chain-ladder model to the pseudo-cumulative data.
  ## Project to form a future triangle of cumulative payments.
  
  ## Perform chain ladder projection
  simCum <- makeCumulative(simClaims)
  
  simLatest <- getDiagonal(simCum,nrow(simCum))
  
  simDFs <- getIndivDFs(simCum)
  
  simWghts <- simCum
  
  simAvDFs <- getAvDFs(simDFs, simWghts)
  
  simUltDFs <- getUltDFs(simAvDFs)
  
  simUlts <- getUltimates(simLatest, simUltDFs)
  ## Get expected future claims
  ## Obtain the corresponding future triangle of incremental payments by
  ## differencing, to be used as the mean when simulating from the process
  ## distribution.
  
  simExp <- getIncremental(getExpected(simUlts, 1/simUltDFs))
  simExp[!is.na(simClaims)] <- NA
  processTriangle <-array(NA,c(n,n,R))
  if(process.distr=="gamma")
  {
    
    processTriangle[!is.na(simExp)] <- sign(simExp[!is.na(simExp)])*rgamma(length(simExp[!is.na(simExp)]), shape=abs(simExp[!is.na(simExp)]/scale.phi), scale=scale.phi)
    
  }
  
  if(process.distr=="od.pois"){
    
    
    processTriangle <-  apply(simExp,c(1,2,3), function(x)
      ifelse(is.na(x), NA, sign(x)*rpois.od(1, abs(x), scale.phi)))
  }
  ##if(process.distr=="od.nbionm")
  ##  processTriangle <-  apply(simExp,c(1,2,3), function(x)
  ##          ifelse(is.na(x), NA, sign(x)*rnbinom.od(1, mu=abs(x), size=sqrt(1+abs(x)),d=scale.phi)))
  
  
  processTriangle[is.na(processTriangle)] <- 0
  
  simExp[is.na(simExp)] <- 0
  IBNR.Triangles <- processTriangle
  
  IBNR <- makeCumulative(IBNR.Triangles)[,n,]
  
  dim(IBNR)<-c(n,1,R)
  
  ParamDist <- makeCumulative(simExp)[,n,]
  
  dim(ParamDist)<-c(n,1,R)
  
  # Giuseppe Crupi
  # Generate and process Next Year triangle for one year re-reserving approach (Solvency 2 purpose)
  
  NYCost<-getNYCost(triangle[origins,,,drop=F],IBNR.Triangles,R)
  NYParamDist<-getNYCost(triangle[origins,,,drop=F],simExp,R)
  
  if(m>n){
    IBNR <- apply(IBNR, 3, function(x) c(rep(0, m-n),x))
    dim(IBNR) <- c(m,1,R)
    
    NYCost <- apply(NYCost, 3, function(x) c(rep(0, m-n),x))
    dim(NYCost) <- c(m,1,R)
    
    ParamDist <- apply(ParamDist, 3, function(x) c(rep(0, m-n),x))
    dim(ParamDist) <- c(m,1,R)
    
    NYParamDist <- apply(NYParamDist, 3, function(x) c(rep(0, m-n),x))
    dim(NYParamDist) <- c(m,1,R)
    
    IBNR.Triangles <- apply(IBNR.Triangles,3, function(x) rbind(matrix(0,m-n,n),x))
    dim(IBNR.Triangles) <- c(m,n,R)
    
    simClaims <- apply(simClaims,3, function(x) rbind(matrix(0,m-n,n),x))
    dim(simClaims) <- c(m,n,R)
  }
  
  IBNR.Totals <- apply(IBNR.Triangles,3,sum)
  
  residuals <- adj.resids
  
  
  output <- list( call=match.call(expand.dots = FALSE),
                  Triangle=output.triangle,
                  f=as.vector(avDFs),
                  simClaims=simClaims,
                  IBNR.ByOrigin=IBNR,
                  IBNR.Triangles=IBNR.Triangles,
                  IBNR.Totals = IBNR.Totals,
                  ParamDist.ByOrigin=ParamDist,
                  NYCost.ByOrigin = NYCost,
                  NYParamDist.ByOrigin=NYParamDist,
                  #NYIBNR.ByOrigin = NYIBNR,
                  ChainLadder.Residuals=residuals,
                  process.distr=process.distr,
                  R=R)
  
  class(output) <- c("BootChainLadder", class(output))
  return(output)
} ################################end of code without progress bar    
    
    
    } # end of function
