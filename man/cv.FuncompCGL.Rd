% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CV.R
\name{cv.FuncompCGL}
\alias{cv.FuncompCGL}
\title{Cross-validation for FuncompCGL.}
\usage{
cv.FuncompCGL(y, X, Zc = NULL, lam = NULL, nlam = 100, k = 4:10, ref = NULL,
              foldid, nfolds = 10, W = rep(1,times = p - length(ref)),
              trim = 0, outer_maxiter = 1e+06, keep = FALSE, ...)
}
\arguments{
\item{y}{response vector with length n.}

\item{X}{a data frame or matrix.
\itemize{
\item If \code{nrow(X)} > \eqn{n},
      \code{X} should be a data frame or matrix of the functional compositional
      predictors with \eqn{p} columns for the values of the compositional components,
      one column indicating the subject ID and one column of observed time points.
      The order of the Subject ID should be the SAME as that of \code{y}.
\item If \code{nrow(X)[1]}=\eqn{n},
      \code{X} is considered as the integrated design matrix, a
      \code{n*(k*p - length(ref))} matrix.
}}

\item{Zc}{a \eqn{n\times p_{c}}{n*p_c} design matrix of unpenalized variables.
Default is NULL.}

\item{lam}{a user supplied lambda sequence.
If \code{lam} is provided as a scaler and \code{nlam}\eqn{>1}, \code{lam} sequence is created starting from
\code{lam}. To run a single value of \code{lam}, set \code{nlam}\eqn{=1}.
The program will sort user-defined \code{lambda} sequence in decreasing order.}

\item{nlam}{the length of the \code{lam} sequence. Default is 100. No effect if \code{lam} is
provided.}

\item{k}{a vector of integer values of the degrees of freedom; default is 4:10.}

\item{ref}{reference level (baseline), either an integer between \eqn{[1,p]} or \code{NULL}.
Default value is \code{NULL}.
\itemize{
\item If \code{ref} is set to be an integer between \code{[1,p]}, the group lasso penalized \emph{log-contrast} model (with log-ratios) is fitted
with the \code{ref}-th component chosed as baseline.
\item If \code{ref} is set to be \code{NULL}, the linearly constrained group lasso penalized \emph{log-contrast} model is fitted.
}}

\item{foldid}{an optional vector of values between 1 and the sample size \code{n}, providing the fold
assignments. If supplied, \code{nfold} can be missing.}

\item{nfolds}{number of folds, default is 10. The smallest allowable value is \code{nfolds=3}.}

\item{W}{a vector of length p (the total number of groups),
or a matrix with dimension \eqn{p_{1} \times p_{1}}{p1*p1}, where
\code{p1=(p - length(ref)) * k},
or character specifying the function used to calculate weight matrix for each group.
\itemize{
\item a vector of penalization weights for the groups of coefficients. A zero weight implies no shrinkage.
\item a diagonal matrix with positive diagonal elements.
\item if character string of function name or an object of type \code{function} to compute the weights.
}}

\item{trim}{percentage to be trimmed off the prediction errors from either side; default is 0.}

\item{outer_maxiter}{maximum number of loops allowed for the augmented Lagrange method.}

\item{keep}{If \code{keep=TRUE}, fitted models in cross validation are reported.
Default is \code{keep=FALSE}.}

\item{...}{other arguments that can be passed to \code{\link{FuncompCGL}}.}
}
\value{
An object of S3 class \code{"cv.FuncompCGL"} is return, which is a list
containing:
\item{FuncompCGL.fit}{a list of length \code{length(k)},
                      with elements being the fitted \code{\link{FuncompCGL}} objects of different
                      degrees of freedom.}

\item{lam}{the sequence of \code{lam}.}

\item{Ftrim}{a list for cross validation results with trim = 0.
               \itemize{
               \item \code{cvm} the mean cross-validated error
                                - a matrix of dimension \code{length(k)*length(lam).}
               \item \code{cvsd} estimated standard error of \code{cvm}.
               \item \code{cvup} upper curve = \code{cvm + cvsd}.
               \item \code{cvlo} lower curve = \code{cvm - cvsd}.
               \item \code{lam.min} the optimal values of \code{k} and \code{lam}
                     that give minimum cross validation error \code{cvm}.
               \item \code{lam.1se} the optimal values of \code{k} and \code{lam}
                     that give cross validation error withnin 1 standard error of
                     the miminum \code{cvm}.
               }
             }

\item{Ttrim}{a list of cross validation result with \code{trim*100\%}. The structure is the
             same as that for \code{Ftrim}.}

\item{fit.preval, foldid}{\code{fit.preval} is the array of fitted models.
                          Only kept when \code{keep=TRUE}.}
}
\description{
k-fold cross-validation for FuncompCGL; produce a plot and return
optimal values of \code{lam} and \code{k}.
}
\details{
k-fold cross validation.
}
\examples{
\donttest{
## generate training and testing data
df_beta = 5
p = 30
beta_C_true = matrix(0, nrow = p, ncol = df_beta)
beta_C_true[1, ] <- c(-0.5, -0.5, -0.5 , -1, -1)
beta_C_true[2, ] <- c(0.8, 0.8,  0.7,  0.6,  0.6)
beta_C_true[3, ] <- c(-0.8, -0.8 , 0.4 , 1 , 1)
beta_C_true[4, ] <- c(0.5, 0.5, -0.6  ,-0.6, -0.6)

n_train = 50
n_test = 30
nfolds = 5
foldid <- sample(rep(seq(nfolds), length = n_train))
k_list <- c(4,5)

Data <- Fcomp_Model(n = n_train, p = p, m = 0, intercept = TRUE,
                    SNR = 4, sigma = 3, rho_X = 0.2, rho_T = 0.5,
                    df_beta = df_beta, n_T = 20, obs_spar = 1, theta.add = FALSE,
                    beta_C = as.vector(t(beta_C_true)))
arg_list <- as.list(Data$call)[-1]
arg_list$n <- n_test
Test <- do.call(Fcomp_Model, arg_list)

## cv_cgl: Constrained group lasso
cv_cgl <-  cv.FuncompCGL(y = Data$data$y, X = Data$data$Comp,
                         Zc = Data$data$Zc, intercept = Data$data$intercept,
                         k = k_list, foldid = foldid,
                         keep = TRUE)
plot(cv_cgl,k = k_list)
cv_cgl$Ftrim[c("lam.min", "lam.1se")]
beta <-  coef(cv_cgl, trim = FALSE, s = "lam.min")
k_opt <- cv_cgl$Ftrim$lam.min['df']
## plot path against L2-norm of group coefficients
plot(cv_cgl$FuncompCGL.fit[[as.character(k_opt)]])
## or plot path against L1-norm of group coefficients
plot(cv_cgl$FuncompCGL.fit[[as.character(k_opt)]], ylab = "L1")

m1 <- ifelse(is.null(ncol(Data$data$Zc)), 0, ncol(Data$data$Zc))
m1 <- m1 + Data$data$intercept
if(k_opt == df_beta) {
  plot(Data$beta, col = "red", pch = 19,
       ylim = range(c(range(Data$beta), range(beta))))
  abline(v= seq(from = 0, to = (p*df_beta), by = df_beta ))
  abline(h = 0)
  points(beta)
  if(m1 > 0) points(p*df_beta + 1:m1, tail(Data$beta, m1),
                    col = "blue", pch = 19)
} else {
  plot(beta, ylim = range(c(range(Data$beta), range(beta))) )
  abline(v= seq(from = 0, to = (p*k_opt), by = k_opt ))
  abline(h = 0, col = "red")
  if(m1 > 0) points(p*k_opt + 1:m1, tail(Data$beta, m1),
                    col = "blue", pch = 19)
}

beta_C <- matrix(beta[1:(p*k_opt)], byrow = TRUE, nrow = p)
## satisfies zero-sum constraints
cat("colSums:", colSums(beta_C))
Nonzero <- (1:p)[apply(beta_C, 1, function(x) max(abs(x)) >0)]
cat("selected groups:", Nonzero)

oldpar <- par(mfrow=c(2,1))
sseq <- Data$basis.info[, 1]
beta_curve_true <- Data$basis.info[, -1] \%*\%  t(beta_C_true)
Nonzero_true <- (1:p)[apply(beta_C_true, 1, function(x) max(abs(x)) >0)]
matplot(sseq, beta_curve_true, type = "l", ylim = range(beta_curve_true),
        ylab = "True coeffcients curves", xlab = "TIME")
abline(a = 0, b = 0, col = "grey", lwd = 2)
text(0, beta_curve_true[1, Nonzero_true], labels = Nonzero_true)

beta_curve <- splines::bs(sseq, df = k_opt, intercept = TRUE) \%*\% t(beta_C)
matplot(sseq, beta_curve, type = "l", ylim = range(beta_curve_true),
        ylab = "Estimated coefficient curves", xlab = "TIME")
abline(a = 0, b = 0, col = "grey", lwd = 2)
text(0, beta_curve[1, Nonzero], labels = Nonzero)
par(oldpar)

## plot L1-norm of the estimated coefficients for each component of the composition
plot(apply(abs(beta_C),1,sum), ylab = "L1-norm", xlab = "Component index")
## or plot L2-norm
plot(apply(abs(beta_C),1, function(x) sqrt(sum(x^2))),
     ylab = "L2-norm", xlab = "Component index")

## set a thresholding for variable selection via cross-validation model
## example 1: cut by average L2-norm for estimated coefficient curves
Curve_L2 <- colSums(beta_curve^2)
Curve_L2 <- Curve_L2 - colSums(beta_curve[c(1, nrow(beta_curve)), ]^2) / 2
Curve_L2 <- Curve_L2 * (Data$basis.info[2,1] - Data$basis.info[1,1])
Curve_L2 <- sqrt(Curve_L2)
plot(Curve_L2, xlab = "Component index", ylab = "L2-norm for coefficient curves")
cutoff <- sum(Curve_L2) / p
Nonzero_cut <- (1:p)[which(Curve_L2 >= cutoff)]
Nonzero_cut
## example 2: cut by average L2-norm for estimated coefficient vectors
cutoff <- sum(apply(beta_C, 1, function(x) norm(x, "2")))/p
Nonzero_cut2 <- (1:p)[apply(beta_C, 1, function(x, a) norm(x, "2") >= a, a = cutoff)]
## example 3: cut by average L1-norm for estimated coefficient vectors
cutoff <- sum(abs(beta_C))/p
Nonzero_cut3 <- (1:p)[apply(beta_C, 1, function(x, a) sum(abs(x)) >= a, a = cutoff)]

y_hat <- predict(cv_cgl, Data$data$Comp, Data$data$Zc, s = "lam.min")
MSE <- sum((drop(Data$data$y) - y_hat)^2) / n_train
y_hat <- predict(cv_cgl, Test$data$Comp, Test$data$Zc, s = "lam.min")
PRE <- sum((drop(Test$data$y) - y_hat)^2) / n_test
cgl_result <- list(cv.result = cv_cgl, beta = beta,
                   Nonzero = c("Original" = Nonzero, "Cut" = Nonzero_cut),
                   MSE = MSE, PRE = PRE)

## cv_naive: ignoring the zero-sum constraints
## set mu_raio = 0 to identifying without linear constraints,
## no outer_loop for Lagrange augmented multiplier
cv_naive <-  cv.FuncompCGL(y = Data$data$y, X = Data$data$Comp,
                           Zc = Data$data$Zc, intercept = Data$data$intercept,
                           k = k_list, foldid = foldid, keep = TRUE,
                           mu_ratio = 0)
plot(cv_naive, k = k_list)
beta <-  coef(cv_naive, trim = FALSE, s = "lam.min")
k_opt <- cv_naive$Ftrim$lam.min['df']
beta_C <- matrix(beta[1:(p*k_opt)], byrow = TRUE, nrow = p)
## does NOT satisfy zero-sum constraints
cat("colSums:", colSums(beta_C))
Nonzero <- (1:p)[apply(beta_C, 1, function(x) max(abs(x)) >0)]
beta_curve <- splines::bs(sseq, df = k_opt, intercept = TRUE) \%*\% t(beta_C)
Curve_L2 <- colSums(beta_curve^2) - colSums(beta_curve[c(1, nrow(beta_curve)), ]^2) / 2
Curve_L2 <- sqrt(Curve_L2 * (Data$basis.info[2,1] - Data$basis.info[1,1]))
cutoff <- sum(Curve_L2) / p
Nonzero_cut <- (1:p)[which(Curve_L2 >= cutoff)]
y_hat <- predict(cv_naive, Data$data$Comp, Data$data$Zc, s = "lam.min")
MSE <- sum((drop(Data$data$y) - y_hat)^2) / n_train
y_hat <- predict(cv_naive, Test$data$Comp, Test$data$Zc, s = "lam.min")
PRE <- sum((drop(Test$data$y) - y_hat)^2) / n_test
naive_result <- list(cv.result = cv_naive, beta = beta,
                     Nonzero = c("Original" = Nonzero, "Cut" = Nonzero_cut),
                     MSE = MSE, PRE = PRE)

## cv_base: random select a component as reference
## mu_ratio is set to 0 automatically once ref is set to a integer
ref = sample(1:p, 1)
cv_base <- cv.FuncompCGL(y = Data$data$y, X = Data$data$Comp,
                         Zc = Data$data$Zc, intercept = Data$data$intercept,
                         k = k_list, foldid = foldid, keep = TRUE,
                         ref = ref)
plot(cv_base, k = k_list)
beta <-  coef(cv_base, trim = FALSE, s = "lam.min")
k_opt <- cv_base$Ftrim$lam.min['df']
beta_C <- matrix(beta[1:(p*k_opt)], byrow = TRUE, nrow = p)
## satisfies zero-sum constraints
cat("colSums:", colSums(beta_C))
Nonzero <- (1:p)[apply(beta_C, 1, function(x) max(abs(x)) >0)]
beta_curve <- splines::bs(sseq, df = k_opt, intercept = TRUE) \%*\% t(beta_C)
Curve_L2 <- colSums(beta_curve^2) - colSums(beta_curve[c(1, nrow(beta_curve)), ]^2) / 2
Curve_L2 <- sqrt(Curve_L2 * (Data$basis.info[2,1] - Data$basis.info[1,1]))
cutoff <- sum(Curve_L2) / p
Nonzero_cut <- (1:p)[which(Curve_L2 >= cutoff)]
y_hat <- predict(cv_base, Data$data$Comp, Data$data$Zc, s = "lam.min")
MSE <- sum((drop(Data$data$y) - y_hat)^2) / n_train
y_hat <- predict(cv_base, Test$data$Comp, Test$data$Zc, s = "lam.min")
PRE <- sum((drop(Test$data$y) - y_hat)^2) / n_test
base_result <- list(cv.result = cv_base, beta = beta,
                    Nonzero = c("Original" = Nonzero, "Cut" = Nonzero_cut),
                    MSE = MSE, PRE = PRE)
}

}
\references{
Sun, Z., Xu, W., Cong, X., Li G. and Chen K. (2020) \emph{Log-contrast regression with
functional compositional predictors: linking preterm infant's gut microbiome trajectories
to neurobehavioral outcome}, \href{https://arxiv.org/abs/1808.02403}{https://arxiv.org/abs/1808.02403}
\emph{Annals of Applied Statistics}
}
\seealso{
\code{\link{FuncompCGL}} and \code{\link{GIC.FuncompCGL}},
and \code{\link[=predict.cv.FuncompCGL]{predict}}, \code{\link[=coef.cv.FuncompCGL]{coef}}
and \code{\link[=plot.cv.FuncompCGL]{plot}} methods for \code{"cv.FuncompCGL"} object.
}
\author{
Zhe Sun and Kun Chen
}
