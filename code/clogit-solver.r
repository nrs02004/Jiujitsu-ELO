library(inline)
library(Rcpp)

### winners: an m-vector of winner indices ordered by match number
### losers: an m-vector of loser indices ordered by match number

### maxit --- the number of iterations to run for (without much regularization it can take a lot of iterations...). At some point I will implement a convergence criteria, but for now it just runs exactly "maxit" iterations.

### step_size --- the size of a step to take. If things explode it means the step-size is too big.

### regularized by lambda*ridge

clogit_solver <- function(winners, losers, step_size = 0.001, maxit = 100, lambda = 1){
    wl <- matrix(as.numeric(as.factor(c(winners,losers))),ncol = 2)
    winners <- wl[,1]
    losers <- wl[,2]

    m <- length(unique(c(winners,losers)))
    eta <- rep(0,m)

    for(i in 1:maxit){

        probs <- calc_prob(exp(eta), winners, losers)
        grad <- calc_grad(winners, losers, probs, m)
        eta <- eta + (grad - 2*lambda*eta) * step_size

    }
    return(list("eta"=eta,"probs"=probs))
}





## Takes in winners, losers, exp_eta
calc_prob_cxx ='
        Rcpp::IntegerVector c_w(winners);
        Rcpp::IntegerVector c_l(losers);
        Rcpp::NumericVector c_exp_eta(exp_eta);

        std::vector<double> probs(c_w.size(),0);

        for(int i = 0; i < c_w.size(); i++){ //Cycling over matches
          probs[i] = c_exp_eta[c_w[i]-1] / (c_exp_eta[c_w[i]-1] + c_exp_eta[c_l[i]-1]);
        }
        return Rcpp::wrap( probs );'

## Takes in winners, losers, probs, nGrad
calc_grad_cxx ='
        Rcpp::IntegerVector c_w(winners);
        Rcpp::IntegerVector c_l(losers);
        Rcpp::NumericVector c_probs(probs);
        int c_nGrad = as<int>(nGrad);

        std::vector<double> grad(c_nGrad,0);

        for(int i = 0; i < c_w.size(); i++){ //Cycling over matches
          grad[c_w[i]-1] += 1 - c_probs[i];
          grad[c_l[i]-1] += c_probs[i] - 1;
        }
        return Rcpp::wrap( grad );'




calc_prob = cxxfunction(signature(exp_eta= "numeric",
                                  winners = "numeric",
                                  losers = "numeric"),
                        plugin="Rcpp",
                        body=calc_prob_cxx)

calc_grad = cxxfunction(signature(winners = "numeric",
                                  losers = "numeric",
                                  probs= "numeric",
                                  nGrad = "numeric"),
                        plugin="Rcpp",
                        body=calc_grad_cxx)
