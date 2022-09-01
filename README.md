# Jiujitsu-ELO

In this project, I...
1) Develop R code for fitting a penalized conditional logistic regression model
2) Apply this model to Brazilian Jiujitsu (BJJ) competition data (through 2016) to identify rankings for competitors

The algorithm for fitting the penalized conditional logistic regression model maximizes the penalized log-likelihood (a ridge penalty is included). This maximization is done via gradient ascent. The code includes components written in R and C++

## ELO background

We assume that each person has a skill value $\eta$; when 2 people ($i$ and $j$) compete, we model the outcome as a coin flip with probability of person $i$ winning as

$$
P(i\textrm{ wins}) = \frac{e^{\eta_i}}{e^{\eta_i} + e^{\eta_j}}
$$

This is a vast simplification as it ignores that "skill" is time-varying; and that certain people may have styles that work better against some people than others (this would necessitate a low rank model). It also ignores that jiujitsu competitors are separated into weight classes, and there is relatively little competition across weight classes (so possibly we should have run a stratified analysis). However, this can still be useful for roughly ranking competitors.

Our goal is to estimate the $\eta$-value for each person in the dataset.

Because we have a large number of competitors, some of whom had very few matches, we used a [ridge] penalized maximum likelihood approach --- this can be thought as placing a gaussian prior on the distribution of $\eta$, where the variance of that prior is inversely related to the penalty parameter, and estimating using the posterior mode.

## The ranking

We begin by giving the ranking when




For the unpenalized model (or equivalently using an improper prior), we get the following ranking (of the top 20 competitors)

| rank|competitor         |  eta|
|----:|:------------------|----:|
|    1|Ricardo Arona      | 7.21|
|    2|Marcus Almeida     | 7.17|
|    3|Rodolfo Vieira     | 7.06|
|    4|Victor Honorio     | 6.99|
|    5|Roger Gracie       | 6.87|
|    6|Olav Einemo        | 6.67|
|    7|Yago de Souza      | 6.63|
|    8|Yago Souza         | 6.47|
|    9|Ronaldo Souza      | 6.41|
|   10|Rickson Gracie     | 6.36|
|   11|Alex. Cacareco     | 6.36|
|   12|Vitor Viana        | 6.31|
|   13|Mark Kerr          | 6.30|
|   14|V. Honorio         | 6.26|
|   15|Diogo Gamonal      | 6.22|
|   16|Rafael Mendes      | 5.97|
|   17|Leandro Lo         | 5.90|
|   18|Felipe Pena        | 5.83|
|   19|Abdurahman Bilarov | 5.79|
|   20|Andre Galvao       | 5.68|

We first note that we have replicated participants with slightly different spellings of their names (eg. "V.Honorio" vs "Victor Honorio"). Ideally we woudl fix this. We also have some odd people in this top list (perhaps as much as 50\% of the list are names unknown to most jiujitsu practicioners)
