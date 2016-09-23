## Control charts Shiny app

A Shiny app to plot control charts from a given .csv file. Depends also on a package not on CRAN at the moment but available on my Github: [chartconstants](https://github.com/mick001/chartconstants).

Please note this is a test app developed in a couple hours, if you spot any bug or encounter difficulties, please let me know.

## Implemented charts
Currently the following charts are available:

- Charts for variables: xbar-s, s.

## .csv file format
The .csv file should have the following format:

    var_1,var_2,...,var_n
    2.3,5.2,...,9.0
    3.4,8.1,...,1.4
    .
    .
    .

The number of variables in the .csv can be arbitrary.

For each variable, the measurements are assumed to be consecutive and **not** grouped. For instance, if you select a group of size 2 and use the previous .csv file, the grouping will be performed as follows:

    group_id,var_1,var_2,...,var_n
    1,2.3,5.2,...,9.0
    1,3.4,8.1,...,1.4
    2,.
    2,.
    3,.
    3,
    .
    .
    .

## Example of use
Simply load a .csv file, select the type of chart to be plotted, group size and variable to be used. By default, the *mtcars dataset* is used.

Check [this link]() to use the app.

## License
See the LICENSE file for license rights and limitations (GPL 3.0).
