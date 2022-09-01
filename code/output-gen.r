library(tidyr)
library(dplyr)
library(colorspace)
library(knitr)

fitted.vals <- data.frame(name = key$name)
for(i in 1:length(fits)){
  fitted.vals <- fitted.vals %>% mutate("eta.{i}" := fits[[i]]$full.obj$eta[key[["id"]]])
}

top.people <- c()
for(i in 1:length(fits)){
  top.people <- union(top.people, fits[[i]]$ranks[1:10])
}

top.etas <- fitted.vals %>% filter(name %in% top.people)
rank.unreg <- data.frame(name = fits[[1]]$ranks) %>% filter(name %in% top.people)
rank.unreg$ranks <- 1:nrow(rank.unreg)

dat.plot <- left_join(top.etas, rank.unreg)

colfunc <- colorRampPalette(c("red", "blue"))
spectrum <- colfunc(nrow(rank.unreg))


plot(0,0, type = "n", xlim = c(-7,4), ylim = c(0,8), xlab = "Amount of Regularization", ylab = "Estimated ELO (skill)")
for(i in 1:nrow(dat.plot)){
  etas_i <- dat.plot %>% select(-name, -ranks) %>% slice(i)
  lines(log(0.001+lambdas),etas_i, col = adjust_transparency(spectrum[dat.plot$ranks[i]], 0.7), lwd = 3)
}

num.use <- 20
table.dat <- data.frame( rank=1:num.use, competitor = fits[[1]]$ranks[1:num.use], eta = round(fits[[1]]$eta[1:num.use],2))

kable(table.dat)



