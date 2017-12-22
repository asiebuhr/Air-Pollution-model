# Air-Pollution-model
A lab assignment I had while on exchange at the University of Auckland. I recreated the assignment in R; originally the calculations were done entirely in Excel, with the write-up being done in Microsoft Word.

# The Project

## Intro
This project dealt with modelling air pollution in "streetscapes" (canyons created through man-made means, such as a road between buildings), modelled by Johnson *et al*. (1976). The air pollutant considered in this project was carbon monoxide, or CO. Therefore a model is required to allow prediction of CO concentrations in city street canyons as a function of significant variables.

## Data

Data were given for two sites: Vercoe and Te Rapa, both located in New Zealand. We used Vercoe data, attached to this Github, as the observed "raw" data, and fit a model to the data available. We then tested the model empirically to data at Te Rapa.

## Johnson *et al* model

Johnson *et al* modeled data as such:

C<sub>p</sub> = a * (N * S<sup>-0.75</sup>)
