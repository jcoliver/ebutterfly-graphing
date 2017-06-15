# Code for graphs corresponding to e-butterfly paper

This repository includes the data and R code for creating the graphs that appeared in the following paper:

Prudic et al. 2017. eButterfly: Leveraging Massive Online Citizen Science for Butterfly Conservation. Insects **8**(2): 53. doi: [doi:10.3390/insects8020053](https://dx.doi.org/10.3390/insects8020053).

## Data
All data files are in `data` directory
+ `danaus-plexippus-data.csv` : Observations of _Danaus plexippus_ submitted to eButterfly
+ `observation-data-clean-04.csv` : Observations submitted to eButterfly
+ `submission-data.csv` : Number of observations and checklists submitted to eButterfly from January 2012 through December 2016
+ `vanessa-atalanta-data.csv` : Observations of _Vanessa atalanta_ submitted to eButterfly

## R Scripts
+ figure-1.R 
  + Data Source: data/submission-data.csv
  + Description: average number of eButterfly checklists submitted per month since 2012.
  + Output: output/figure-1.pdf
+ figure-2.R
  + Data Source: data/observation-data-clean-04.csv
  + Description: Heatmap of eButterfly observations.
  + Output: output/figure-2.pdf
+ figure-3.R
  + Data Source: data/vanessa-atalanta-data.csv
  + Description: Observations of _Vanessa atalanta_ on three successive days in April 2012.
  + Output: output/figure-3.pdf
+ figure-4.R
  + Data Source: data/danaus-plexippus-data.csv
  + Description: Observations of _Danaus plexippus_ during three successive months of 2012.
  + Output: output/figure-4.pdf
+ figure-3-ggmap.R
  + Data Source: data/vanessa-atalanta-data.csv
  + Description: Observations of _Vanessa atalanta_ on three successive days in April 2012.
  + Output: output/figure-3-ggmap.pdf
  + Note: effectively the same as figure-3.R, but uses the `ggmap` package instead of `raster` for graphics. This product of this script was not used in the manuscript.
+ figure-4-ggmap.R
  + Data Source: data/danaus-plexippus-data.csv
  + Description: Observations of _Danaus plexippus_ during three successive months of 2012.
  + Output: output/figure-4-ggmap.pdf
  + Note: effectively the same as figure-4.R, but uses the `ggmap` package instead of `raster` for graphics. This product of this script was not used in the manuscript.
