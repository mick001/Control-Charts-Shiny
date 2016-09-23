## Control charts Shiny app

A Shiny app to plot control charts from a given .csv file. Depends also on a package not on CRAN at the moment but available on my Github: [chartconstants](https://github.com/mick001/chartconstants).

## Implemented charts
Currently the following charts are available:

- Charts for variables: xbar-s, s.

## .csv file format
The .csv file should have the following format:

    var1,var2,...
    2.3,5.2,...
    3.4,8.1,...
    .
    .
    .

## Example of use
Simply load a .csv file, select the type of chart to be plotted, group size and variable to be used. By default, the *mtcars dataset* is used.

## License
See the LICENSE file for license rights and limitations (GPL 3.0).
