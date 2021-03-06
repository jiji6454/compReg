# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

ALM_GMD <- function(y, Z, Zc, Zc_proj, beta, lambda, pf, dfmax, pfmax, A, b, group_index, inner_maxiter, outer_maxiter, inner_eps, outer_eps, mu_ratio, u_ini, tol) {
    .Call(`_Compack_ALM_GMD`, y, Z, Zc, Zc_proj, beta, lambda, pf, dfmax, pfmax, A, b, group_index, inner_maxiter, outer_maxiter, inner_eps, outer_eps, mu_ratio, u_ini, tol)
}

ALM_CD <- function(y, Z, Zc, Zc_proj, beta, lambda, pf, b, A, dfmax, pfmax, inner_maxiter, outer_maxiter, inner_eps, outer_eps, mu_ratio, u_ini, tol) {
    .Call(`_Compack_ALM_CD`, y, Z, Zc, Zc_proj, beta, lambda, pf, b, A, dfmax, pfmax, inner_maxiter, outer_maxiter, inner_eps, outer_eps, mu_ratio, u_ini, tol)
}

ALM_CD_comp <- function(y, Z, Zc, Zc_proj, beta, lambda, pf, dfmax, pfmax, inner_maxiter, outer_maxiter, inner_eps, outer_eps, mu_ratio, u_ini, tol) {
    .Call(`_Compack_ALM_CD_comp`, y, Z, Zc, Zc_proj, beta, lambda, pf, dfmax, pfmax, inner_maxiter, outer_maxiter, inner_eps, outer_eps, mu_ratio, u_ini, tol)
}

# Register entry points for exported C++ functions
methods::setLoadAction(function(ns) {
    .Call('_Compack_RcppExport_registerCCallable', PACKAGE = 'Compack')
})
