library(tidyverse)
library(readr)
library(stats)
library(broom)
library(reshape2)
library(magrittr)

N <- co_data$`Traffic Flow T (cars h-1)`
S <- co_data$`Vehicle Speed S (miles h-1)`
wind <- co_data$`Wind Speed u (m s-1)`
CO <- co_data$`[CO] Observed (ppm)`

# Vercoe site CO concentrations during the day
ggplot(co_data, aes(x = Time, y = CO)) +
  geom_point() + 
  geom_smooth(se = FALSE)

# Vercoe traffic flow throughout the day
ggplot(co_data, aes(x = Time, y = N)) +
  geom_smooth(se = F)

#Vercoe wind speed throughout the day
ggplot(co_data, aes(x = Time, y = wind)) +
  geom_smooth(se = F)

# let's find a linear relationship between X and CO
# concentrations

# the lab assignment shows that
# X = [(N*S^(-.75))/(u+.5)] where CO predicted is:
# CO.p = aX + B
# we need a column for X

# plot CO vs X
co_data <- mutate(co_data, 
                  X = (N*S^(-.75))/(wind + 0.5))

ggplot(co_data, aes(x = X, y = CO)) +
  geom_point() +
  geom_smooth(method = "lm", se = F)

# run a regression using X to predict CO

lmfit <- lm(CO ~ X, co_data)
tidy(lmfit)

fit.fx <- function(a) {
  lmfit$coefficients[2]*a + lmfit$coefficients[1]
}
# pull coefficients to create predicted CO column
co_data <- mutate(co_data,
          CO.p = fit.fx(X)
)

# plot a predicted vs observed scatterplot
ggplot(data = co_data) +
  geom_point(mapping = aes(x = CO.p, y = CO)) + # predicted
  geom_abline(slope = 1, intercept = 0)

# it fits the data okay. let's plot observed vs. residuals
# create column of residuals:

co_data = mutate(co_data,
                 co.resid = CO.p - CO)

co_data %>%
  ggplot + 
  geom_point(mapping = aes(x = CO, y = co.resid)) +
  geom_hline(yintercept = 0)

# lots of variation between predicted and observed values

# shown with residuals over time:

ggplot(co_data, aes(x = Time, y = co.resid)) +
  geom_line(group = 1) +
  geom_hline(yintercept = 0)

CO.p <- co_data$CO.p

# most significant departure is ~ -1.5

# rmse = root-mean-squared-error
# rel.rmse = relative root mean squared error
rmse <- function(diff) {
  sqrt(mean(diff^2))
}

diff <- CO.p - CO

# take different statistical measures to compare to empirical data
# rmse = root-mean-squared-error

mae <- sum(abs(diff))/25
mae
## 0.4894338
rmse.V <- rmse(diff)
rmse.V
## 0.6375908
rel.rmse.V <- rmse.V/mean(CO)
rel.rmse.V
## 0.1927952
Obs.Mean.V <- mean(CO)
Obs.Mean.V
## 3.307088
Prd.Mean.V <- mean(CO.p)
Prd.Mean.V
## 3.307088
Obs.stdev.V <- sd(CO)
Obs.stdev.V
## 1.140716
Prd.stdev.V <- sd(CO.p)
Prd.stdev.V
## 0.9368947
# upload Vercoe data to allow for validation

# create stand-ins for variables

tr.u <- te_rapa$`Wind Speed u (m s-1)`
tr.N <- te_rapa$`Traffic Flow N (cars h-1)`
tr.S <- te_rapa$`Vehicle Speed S (miles h-1)`
tr.CO <- te_rapa$`[CO] Observed (ppm)`
tr.time <- te_rapa$Time

te_rapa <- te_rapa %>%
  mutate(tr.X = (tr.N * (tr.S^(-.75)))/(tr.u + .5),
         tr.CO.p = fit.fx(tr.X))

# let's plot predicted vs observed values
te_rapa %>% ggplot +
  geom_point(mapping = aes(x = tr.CO.p, y = tr.CO)) +
  geom_abline(slope = 1, intercept = 0)

# this model has a bias - it is underpredicting
# let's analyse both by plotting them on a time series

ggplot(data = te_rapa) +
  geom_line(mapping = aes(x = tr.time, y = tr.CO.p, colour = "Predicted")) +
  geom_line(mapping = aes(x = tr.time, y = tr.CO, colour = "Observed"))

# our model overpredicts compared to the observed values, but follows
# the same trends as well

# let's plot observed versus residual:

te_rapa = te_rapa %>% 
  mutate(tr.resid = tr.CO - tr.CO.p) 


te_rapa %>% 
  ggplot(aes(tr.CO, tr.resid)) +
  geom_point() +
  geom_hline(yintercept = 0)

# in the conceptualised model, there is .5 constant
# in the denominator of X. Let's plot it without it.

te_rapa = te_rapa %>%
  mutate(
    tr.X.mod = (tr.N * tr.S ^ (-.75)) / tr.u
  )

te_rapa %>% ggplot +
  geom_line(mapping = aes(x = tr.time, y = tr.X.mod, colour = "Modified")) +
  geom_line(mapping = aes(x = tr.time, y = tr.CO.p, colour = "Fitted Model"))
              
# allows the X variable to fit the observed data better, certainly

tr.CO.p <- te_rapa$tr.CO.p
tr.diff <- tr.CO.p - tr.CO

tr.mae <- sum(abs(tr.diff))/60
tr.mae
## 2.195435
tr.rmse <- rmse(tr.diff)
tr.rmse
## 2.922238
tr.rel.rmse <- tr.rmse/mean(tr.CO)
tr.rel.rmse
## 0.4890638
tr.Prd.Mean <- mean(tr.CO.p)
tr.Prd.Mean
## 7.816954
tr.Obs.Mean <- mean(tr.CO)
tr.Obs.Mean
## 5.975167
tr.Obs.stdev <- sd(tr.CO)
tr.Obs.stdev
## 2.488134
tr.Prd.stdev <- sd(tr.CO.p)
tr.Prd.stdev
## 3.983838

eval_Parameters <- tibble(
  "Location", "Mean Absolute Error",  "Root-Mean-Squared-Error", "Relative Root-Mean-Squared-Error", "Observed Mean", "Predicted Mean", "Observed SD", "Predicted SD",
  "Vercoe", mae, rmse.V, rel.rmse.V, Obs.Mean.V, Prd.Mean.V, Obs.stdev.V, Prd.stdev.V,
  "Te Rapa", tr.mae, tr.rmse, tr.rel.rmse, tr.Obs.Mean, tr.Prd.Mean, tr.Obs.stdev, tr.Prd.stdev
)

table(eval_Parameters)

# when you compare the relative root mean squared errors, you can see that, although there is bias,
# there is less variation in the Vercoe model compared to the Te Rapa model, which shows that it can 
# be used as a benchmark for the model but shouldn't represent Te Rapa. Maybe if it had more observation
# there'd be less variation in Vercoe. Perhaps the model could also take into account the width of the canyon
# as well has the depth of the canyon/height of the buildings. Shorter width would allow air pollution
# to pass through quicker as well as shorter buildings, with the opposite being true of longer width
# and taller builidings.

