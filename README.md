# Jiujitsu-ELO

In this project, I...
1) Develop R code for fitting a penalized conditional logistic regression model
2) Apply this model to Brazilian Jiujitsu (BJJ) competition data (through 2016) to identify rankings for competitors

The algorithm for fitting the penalized conditional logistic regression model maximizes the penalized log-likelihood (a ridge penalty is included). This maximization is done via gradient ascent. The code includes components written in R and C++

## ELO background

We assume that each person has a skill value $\eta$; when 2 people ($i$ and $j$) compete, we model the outcome as a coin flip with probability of person $i$ winning as
\[
P(i\textrm{ wins}) = \frac{e^{\eta_i}}{e^{\eta_i} + e^{\eta_j}}
\]
This is a vast simplification as it ignores that "skill" is time-varying; and that certain people may have styles that work better against some people than others (this would necessitate a low rank model). It also ignores that jiujitsu competitors are separated into weight classes, and there is relatively little competition across weight classes (so possibly we should have run a stratified analysis)

Our goal is to estimate the $\eta$-value for each person in the dataset.

Because we have a large number of competitors, some of whom had very few matches, we used a [ridge] penalized maximum likelihood approach --- this can be thought as placing a gaussian prior on the distribution of $\eta$, where the variance of that prior is inversely related to the penalty parameter, and estimating using the posterior mode.
