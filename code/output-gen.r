## analysis-script.r should be run first, to create all the objects that we use here

library(tidyr)
library(dplyr)
library(colorspace)
library(knitr)

## Creates a data table with each row corresponding to a competitor; and each column corresponding to a fitted eta for each of our penalty parameter values
fitted.vals <- data.frame(name = key$name)
for(i in 1:length(fits)){
  fitted.vals <- fitted.vals %>% mutate("eta.{i}" := fits[[i]]$full.obj$eta[key[["id"]]])
}

## Creates a vector of names of competitors whom any of the models has ranked in the top 10
top.people <- c()
for(i in 1:length(fits)){
  top.people <- union(top.people, fits[[i]]$ranks[1:10])
}

## Pulls eta values of the "top competitors"
top.etas <- fitted.vals %>% filter(name %in% top.people)
rank.unreg <- data.frame(name = fits[[1]]$ranks) %>% filter(name %in% top.people)
rank.unreg$ranks <- 1:nrow(rank.unreg)
dat.plot <- left_join(top.etas, rank.unreg)

## The next several lines create a plot that shows how the estimated eta-values of the top competitors change with the value of the penalty parameter
colfunc <- colorRampPalette(c("red", "blue"))
spectrum <- colfunc(nrow(rank.unreg))

pdf("../output/changes-in-ranking.pdf", width = 10, height = 8)
plot(0,0, type = "n", xlim = c(-7,4), ylim = c(0,8), xlab = "Amount of Regularization", ylab = "Estimated ELO (skill)")
for(i in 1:nrow(dat.plot)){
  etas_i <- dat.plot %>% select(-name, -ranks) %>% slice(i)
  lines(log(0.001+lambdas),etas_i, col = adjust_transparency(spectrum[dat.plot$ranks[i]], 0.7), lwd = 3)
}
dev.off()

## We now look at the list of top competitors for a single penalty parameter
pen.index <- 1 ## index of the penalty parameter value (lambda-value) to use
num.use <- 20 ## number of top competitors to list
table.dat <- data.frame( rank=1:num.use, competitor = fits[[pen.index]]$ranks[1:num.use], eta = round(fits[[pen.index]]$eta[1:num.use],2))
kable(table.dat)



