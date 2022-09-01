# Jiujitsu-ELO

I want to know who the top jiujitsu competitor of all time is (as of 2016)! In addition, I want to identify a list of the top 20 competitors (who wouldn't want to do this?).

Toward that end, I used a dataset that contained $\sim 9000$ matches between a total of $\sim 2400$ unique competitors. I fit a bespoke penalized conditional logistic regression model to this data to obtain an "ELO" rating for each competitor, giving a ranking of all competitors in the dataset.

The algorithm for fitting the penalized conditional logistic regression model maximizes the penalized log-likelihood (a ridge penalty is included). This maximization is done via gradient ascent. The code includes components written in R and C++

## ELO background

We assume that each person has a skill value $\eta$; when 2 people ($i$ and $j$) compete, we model the outcome as a coin flip with probability of person $i$ winning as

$$
P(i\textrm{ wins}) = \frac{e^{\eta_i}}{e^{\eta_i} + e^{\eta_j}}
$$

This is a vast simplification as it ignores that "skill" is time-varying; and that certain people may have styles that work better against some people than others (this would necessitate a low rank model). It also ignores that jiujitsu competitors are separated into weight classes, and there is relatively little competition across weight classes (so possibly we should have run a stratified analysis). However, this can still be useful for roughly ranking competitors.

Our goal is to estimate the $\eta$-value for each person in the dataset.

Because we have a large number of competitors, some of whom had very few matches, we used a [ridge] penalized maximum likelihood approach --- this can be thought as placing a gaussian prior on the distribution of $\eta$, where the variance of that prior is inversely related to the penalty parameter, and estimating using the posterior mode.

More details for fitting this model can be found [here](https://github.com/nrs02004/Jiujitsu-ELO/blob/main/writeup/cond-logit.pdf)

## The ranking

We begin by giving the top 20 competitors according to our "best" ranking: where a prior on $\eta$ was used with std deviation $\sigma \approx 0.4$. This choice was somewhat arbitrary (the ranking was relatively stable for sufficiently small $\sigma$). Ideally we would identify the optimal $\sigma$ by using some type of split-sample validation.

| rank|competitor        |  eta|
|----:|:-----------------|----:|
|    1|Rodolfo Vieira    | 2.34|
|    2|Marcus Almeida    | 2.32|
|    3|Rafael Mendes     | 2.13|
|    4|Leandro Lo        | 2.13|
|    5|Roger Gracie      | 2.05|
|    6|Andre Galvao      | 1.83|
|    7|Rubens Charles    | 1.72|
|    8|Felipe Pena       | 1.71|
|    9|Alexandre Ribeiro | 1.69|
|   10|Bernardo Faria    | 1.62|
|   11|Marcelo Garcia    | 1.61|
|   12|Keenan Cornelius  | 1.58|
|   13|Ronaldo Souza     | 1.52|
|   14|Paulo Miyao       | 1.48|
|   15|Michael Langhi    | 1.41|
|   16|Braulio Estima    | 1.33|
|   17|Yuri Simoes       | 1.26|
|   18|Joao Miyao        | 1.25|
|   19|Lucas Lepri       | 1.24|
|   20|Claudio Calasans  | 1.24|

This ranking seems, at least, reasonable. It is hard to compare across weight classes, but it is encouraging to see Rafael Mendes, Cobrinha (Rubens Charles), and Marcelo Garcia near the top of this list. It is also no surprise to see Rodolfo Vieira, Buchecha (Marcus Almeida), Leandro Lo, and Roger Gracie taking 4 of those 5 top spots. As an aside, we can see a potential issue with the model straight away: It predicts that Rodolfo Vieira and Marcus Almeida should have an equal chance of winning, when in fact Rodolfo's record there was 1 win and 5 losses. This may be a particularly poor matchup for Rodolfo despite his skill (though a simple size of 6 obviously is no more than vaguely suggestive).


We also consider the ranks given by the nearly unpenalized model (or equivalently using an improper prior). We get the following ranking (of the top 20 competitors)

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

We first note that we have replicated participants with slightly different spellings of their names (eg. "V.Honorio" vs "Victor Honorio"). This only seems to be a problem for the competitors generally considered to be less prominent. Ideally we would fix this though. We also have some odd people in this top list (perhaps as much as 50\% of the list are names unknown to most jiujitsu practicioners). This issue is due to having some fighters who have never really competed at the top level (or have only very few matches there), but have performed very well in their generally quite small subset of matches against largely non-professionals. While these competitors are potentially of interest, they should likely not make the top of the list without additional evidence.

## Ranks varying with regularization

We see above that ranks vary with regularization. We will now look at if we vary the prior variance (or equivalently, the regularization parameter) more smoothly.

<img src="/output/changes-in-ranking.png" alt="drawing" width="1000"/>
