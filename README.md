# Jiujitsu-ELO

In this project, I...
1) Develop R code for fitting a penalized conditional logistic regression model
2) Apply this model to Brazilian Jiujitsu (BJJ) competition data (through 2016) to identify rankings for competitors

The algorithm for fitting the penalized conditional logistic regression model maximizes the penalized log-likelihood (a ridge penalty is included). This maximization is done via gradient ascent. The code includes components written in R and C++

# ELO background
We assume that each person has a skill value $\eta$; when 2 people ($i$ and $j$) compete, we model the outcome as a coin flip with probability of person $i$ winning as
\[
P(i\textrm{ wins}) = \frac{e^{\eta_i}}{e^{\eta_i} + e^{\eta_j}}
\]
This is a vast simplification as it ignores that "skill" is time-varying; and that certain people may have styles that work better against some people than others (this would necessitate a low rank model).

Our goal is to estimate the $\eta$-value for each person in the dataset.
