# Air-Pollution-model
A lab assignment I had while on exchange at the University of Auckland. I recreated the assignment in R; originally the calculations were done entirely in Excel, with the write-up being done in Microsoft Word.

# The Project

## Intro
This project dealt with modelling air pollution in "streetscapes" (canyons created through man-made means, such as a road between buildings), modelled by Johnson *et al*. (1976). The air pollutant considered in this project was carbon monoxide, or CO. Therefore a model is required to allow prediction of CO concentrations in city street canyons as a function of significant variables.

## Data

Data were given for two sites: Vercoe and Te Rapa, both located in New Zealand. We used Vercoe data, attached to this Github, as the observed "raw" data, and fit a model to the data available. We then tested the model empirically to data at Te Rapa.

## Johnson *et al* model

Johnson *et al* modeled data as such:

C<sub>p</sub> = *a* * ((N * S<sup>-0.75</sup>) / (u + 0.5)) + *b*

where *X* = ((N * S<sup>-0.75</sup>) / (u + 0.5)) to give us

C<sub>p</sub> = *aX* + *b*.

1. N = traffic flow (vehicles.h<sup>-1</sup>)
2. S = average vehicle speed (miles.h<sup>-1</sup>)
3  C<sub>p</sub> = carbon monoxide concentrations (ppm)
4. u = wind speed at rooftop (m.s<sup>-1</sup>)

*X* has no theoretical basis - it is merely the best model fit.

## Process

I created a regression of the model at Vercoe, giving me the parameters:

1. *a* = 0.02302795
2. *b* = 0.38417282

Based on all observed values of *N*, *S*, * *C<sub>p</sub>*, and *u*, I predicted CO concentrations on the values of *X* that I calculated. Calculations are available in the data folder for Vercoe under co_data.

I fit these parameters to calculated values of X at the site in Te Rapa, also under the data folder.

![Alt text](https://raw.githubusercontent.com/asiebuhr/Air-Pollution-model/master/graphs/CO.pred.jpeg)
