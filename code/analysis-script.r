## This is the main script to run to recreate the analysis
## It first pulls in the "solver" and the data;
### then reformats the data a bit;
### then applies the solver for a sequence of penalty-parameter values


source("clogit-solver.r")
data <- readRDS("../data/BJJ_top_bouts.Rds")

fights <- data[,1:3]

### removing draws
ind.keep <- which(fights[,3] != "draw")
bouts <- fights[ind.keep,]

### recoding win/loss as 0/1
ind.win <- which(bouts[,3] == "win")
bouts[ind.win,3] <- 1
bouts[-ind.win,3] <- 0

### turning names into keys
fighters <- unique(c(bouts[,1],bouts[,2]))
key <- data.frame("name" = fighters, "id" = 1:length(fighters))
bouts[,1] <- key[ match(bouts[,1], key[["name"]] ), "id"]
bouts[,2] <- key[ match(bouts[,2], key[["name"]] ), "id"]


### Reording fights so that winner comes before loser
bouts.reorder <- matrix(as.numeric(apply(bouts, 1, function(x){if(x[3] == 1){x[c(1,2)]} else {x[c(2,1)]}})), ncol = 2, byrow=TRUE)

### Breaking up into separate vector of winners and losers
winners <- bouts.reorder[,1]
losers <- bouts.reorder[,2]

lambdas <- c(0,exp(seq(from = log(0.1), to = log(50), length.out = 50)))

### Fitting our conditional logistic regression (with ridge penalty)
fits <- list()
for(i in 1:length(lambdas)){
  fits[[i]] <- list()
  fit <- clogit_solver(winners, losers, step_size = 0.001, maxit = 10000, lambda = lambdas[i])
  
  ## Ordering by eta value
  ord <- order(fit$eta, decreasing = TRUE)
  names.ord <- key[match(ord, key[["id"]]), "name"]
  eta.ord <- fit$eta[ord]
  
  ## storing ordered output
  fits[[i]]$full.obj <- fit
  fits[[i]]$ranks <- names.ord
  fits[[i]]$eta <- eta.ord
}

## Generate the output (you might want to run through this script line-by-line)
source("output-gen.r")
