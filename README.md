
# deminR

[![Travis Build Status](https://travis-ci.org/DivadNojnarg/deminR.svg?branch=master)](https://travis-ci.org/DivadNojnarg/deminR)
[![CRAN status](https://www.r-pkg.org/badges/version/deminR)](https://CRAN.R-project.org/package=deminR)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)


## Installation

You can install the devel version of deminR from [github](https://github.com/DivadNojnarg/deminR) with:

``` r
remotes::install_github("DivadNojnarg/deminR")
```

## Getting Started

Welcome screen             |  Main tab                 | Game win                   |  Game fail
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](man/figures/readme_welcome.png)  |  ![](man/figures/readme_grid.png)  |  ![](man/figures/readme_win.png)  |  ![](man/figures/readme_fail.png)

Game options             |  Game parameters           |  Scores list                |  Dynamic chat
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](man/figures/readme_options.png)  |  ![](man/figures/readme_params.png)  |  ![](man/figures/readme_scores.png)  |  ![](man/figures/readme_chat.png)

Theme light               |  Theme light               |  Theme light
:-------------------------:|:-------------------------:|:-------------------------:
![](man/figures/readme_light_1.png)  |  ![](man/figures/readme_light_2.png)  |  ![](man/figures/readme_light_3.png)


## Example

Once installed, you may play the deminR as shown below:

``` r
library(deminR)
## basic example code
run_app()
```

## TO DO
- [x] add new reactiveValue in r to know the current device (David)
- [ ] double click or long press for mobile? (Discuss)...
- [x] group_by devices (Gab) 
- [ ] maybe add other data ... (Gab + David)
- [x] Finish help section (Gab)
- [x] UI issue: chip in navbar not properly aligned in some cases (if timer > 100s, if user name lenght...)
- [ ] optimize UI (Gab + David)


