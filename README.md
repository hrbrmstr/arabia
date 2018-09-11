
# arabia

Tools to Read ‘Lowrance’ Binary Track Files

## Description

Lowrance’ (<http://www.lowrance.com/>) chart plotters use an ugly but
straightforward binary format to encode their tracks. Tools are provided
to read ‘SL2’ files (and, very likely ‘SLG’ and ‘SL3’ files, too).

## What’s Inside The Tin

The following functions are implemented:

  - `read_sl2`: Read Lowrance binary track files

## Installation

``` r
devtools::install_git("https://gitlab.com/hrbrmstr/arabia")
```

## Usage

``` r
library(arabia)
library(tidyverse)

# current verison
packageVersion("arabia")
```

    ## [1] '0.1.0'

### Give it a go

``` r
(xdf <- read_sl2(system.file("exdat", "example.sl2", package="arabia")))
```

    ## Format: sl2

    ## Block size: downscan

    ## .............

    ## # A tibble: 1,308 x 22
    ##    channel   upperLimit lowerLimit frequency waterDepth keelDepth speedGps temperature lng_enc lat_enc speedWater track
    ##    <chr>          <dbl>      <dbl> <chr>          <dbl>     <dbl>    <dbl>       <dbl>   <int>   <int>      <dbl> <dbl>
    ##  1 Secondary          0       13.3 200 KHz         2.62     0.328      0.5        15.8 4433307 7003054        0.5  4.97
    ##  2 DSI (Dow…          0       13.4 200 KHz         2.62     0.328      0.5        15.8 4433307 7003054        0.5  4.97
    ##  3 Primary            0       13.3 200 KHz         2.62     0.328      0.5        15.9 4433307 7003054        0.5  4.97
    ##  4 Secondary          0       13.3 200 KHz         2.62     0.328      0.5        15.9 4433307 7003054        0.5  4.97
    ##  5 DSI (Dow…          0       13.4 200 KHz         2.59     0.328      0          15.8 4433307 7003054        0    4.97
    ##  6 Secondary          0       13.3 200 KHz         2.59     0.328      0          15.8 4433307 7003054        0    4.97
    ##  7 Secondary          0       13.3 200 KHz         2.52     0.328      0          15.9 4433307 7003054        0    4.97
    ##  8 DSI (Dow…          0       13.4 200 KHz         2.52     0.328      0          15.9 4433307 7003054        0    4.97
    ##  9 Primary            0       13.3 200 KHz         2.52     0.328      0          15.8 4433307 7003054        0    4.97
    ## 10 DSI (Dow…          0       13.4 200 KHz         2.52     0.328      0          15.8 4433307 7003054        0    4.97
    ## # ... with 1,298 more rows, and 10 more variables: altitude <dbl>, heading <dbl>, timeOffset <int>, headingValid <lgl>,
    ## #   altitudeValid <lgl>, gpsSpeedValid <lgl>, waterTempValid <lgl>, positionValid <lgl>, waterSpeedValid <lgl>,
    ## #   trackValid <lgl>

``` r
glimpse(xdf)
```

    ## Observations: 1,308
    ## Variables: 22
    ## $ channel         <chr> "Secondary", "DSI (Downscan)", "Primary", "Secondary", "DSI (Downscan)", "Secondary", "Seco...
    ## $ upperLimit      <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    ## $ lowerLimit      <dbl> 13.3, 13.4, 13.3, 13.3, 13.4, 13.3, 13.3, 13.4, 13.3, 13.4, 13.3, 13.4, 13.3, 13.4, 13.3, 1...
    ## $ frequency       <chr> "200 KHz", "200 KHz", "200 KHz", "200 KHz", "200 KHz", "200 KHz", "200 KHz", "200 KHz", "20...
    ## $ waterDepth      <dbl> 2.620, 2.620, 2.620, 2.620, 2.586, 2.586, 2.516, 2.516, 2.516, 2.516, 2.516, 2.516, 2.516, ...
    ## $ keelDepth       <dbl> 0.328084, 0.328084, 0.328084, 0.328084, 0.328084, 0.328084, 0.328084, 0.328084, 0.328084, 0...
    ## $ speedGps        <dbl> 0.5, 0.5, 0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0...
    ## $ temperature     <dbl> 15.84112, 15.84112, 15.86293, 15.86293, 15.79128, 15.79128, 15.86293, 15.86293, 15.81620, 1...
    ## $ lng_enc         <int> 4433307, 4433307, 4433307, 4433307, 4433307, 4433307, 4433307, 4433307, 4433307, 4433307, 4...
    ## $ lat_enc         <int> 7003054, 7003054, 7003054, 7003054, 7003054, 7003054, 7003054, 7003054, 7003054, 7003054, 7...
    ## $ speedWater      <dbl> 0.5, 0.5, 0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0...
    ## $ track           <dbl> 4.974188, 4.974188, 4.974188, 4.974188, 4.974188, 4.974188, 4.974188, 4.974188, 4.974188, 4...
    ## $ altitude        <dbl> 324.7375, 324.7375, 324.7375, 324.7375, 324.8687, 324.8687, 324.8687, 324.8687, 324.8687, 3...
    ## $ heading         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    ## $ timeOffset      <int> 1317703, 1317706, 1318036, 1318905, 1318946, 1318982, 1319130, 1319140, 1319216, 1319222, 1...
    ## $ headingValid    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, ...
    ## $ altitudeValid   <lgl> TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FAL...
    ## $ gpsSpeedValid   <lgl> TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FAL...
    ## $ waterTempValid  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, ...
    ## $ positionValid   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, ...
    ## $ waterSpeedValid <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, ...
    ## $ trackValid      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, ...
