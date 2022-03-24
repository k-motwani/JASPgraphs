# JASPgraphs

[![R build status](https://github.com/jasp-stats/jaspGraphs/workflows/R-CMD-check/badge.svg)](https://github.com/jasp-stats/jaspGraphs/actions)
[![Documentation](https://img.shields.io/badge/doc-latest-blue.svg)](https://vandenman.github.io/jaspGraphs)


## Overview
--------
	EDIT 2022-01-17: to make seamless with jonathon-love/jsq, changing all instances of jaspGraphs to JASPgraphs (reversing name change from 2020 in jasp-stats repos)
--------
**JASPgraphs contains selective functions that extend ggplot2 for creating plots for JASP.**

## Typical workflow

For almost all plots, the idea is that you only use two functions of JASPgraphs: `geom_rangeframe()`, and `themeJaspRaw()`.

Assuming you created some ggplot2 object called `plot`, you can do:
```r
plot +
  JASPgraphs::geom_rangeframe() + # add lines on the x-axis and y-axis
  JASPgraphs::themeJaspRaw()      # add the JASP theme
```

## Installation
JASPgraphs is only available through GitHub, so you need to use some package that supports that (e.g., `remotes`, `renv`, `pak`, etc.)
```r
remotes::install_github("k-motwani/JASPgraphs")
```
