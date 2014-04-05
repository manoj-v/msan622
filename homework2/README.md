Homework 2: Interactivity
==============================

| **Name**  | MANOJ VENKATESH  |
|----------:|:-------------|
| **Email** | mvenkatesh@dons.usfca.edu |

## Instructions ##

The following packages must be installed prior to running this code:

- `ggplot2`
- `shiny`
- `scales`

To run this code, please enter the following commands in R:

```
library(shiny)
shiny::runGitHub('msan622', 'manoj-v', subdir='homework2')
```
This will start the `shiny` app. See below for details on how to interact with the visualization.

## Discussion ##

#### Data ####
I cleaned up the data by applying filters for budgets (non-zero budget) and also removed entries without any 'mpaa' ratings, using the subset function. 

#### UI ####

I have made the following tweaks on top of the basic template:

* I have kept the layout as per the specifications of the sample layout

* Two sliders are used to change the size and transparency of the points or circles in my case.

* Initially i had planned to give different shapes for the different genres of movies, but decided against it because i found that there would be too much clutter and having differnt shapes neither added any visual appeal nor any usability.

* Made the background color to be black, so that the colors of the points are displayed in contrast becuase the colors in some of the palette selections are very light compared and are barely visible in the presence of a white background.
