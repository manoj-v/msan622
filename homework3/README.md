Homework [3]:  Multivariate Data Visualization
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
shiny::runGitHub('msan622', 'manoj-v', subdir='homework3')
```
This will start the `shiny` app. See below for details on how to interact with the visualization.


## Discussion ##

### Technique 1: [TYPE] ###

![heatmap](heatmap.png)

[DISCUSSION]

### Technique 2: [TYPE] ###

![scatterplot](smplot.png)

[DISCUSSION]

### Technique 3: [TYPE] ###

![parallelcoordinates](pcplot.png)

[DISCUSSION]

### Interactivity ###

I combined `fluidPage` along with `navbarPage` and `tabPanel` to get a `Shiny` app which would resize as per the screen resolutions of the user. Using the `fluidRow` and `column` options i was able to get a clean and consistent layout across all the three visualizations.  
The main page contains 3 tabs, one for the current heatmap, one for scatter plot matrix and also for a parallel coordinates plot. The user can click on the respective tabs to navigate to the respective plots. In each of these pages, there are various controls for sorting the data in differet orders, different sort levels, different color schemes and also controls for selecting a partial list of variables to be visualized.
![tab1](tab1.png)
  The first tab contains the heatmap, the user can sort the data at different levels, by default the data is displayed after sorting first by the area(top row) and then by population (bottom row). On the heatmap, one can see that as different order settings are chosen, heatmap transitions smoothly. Color scheme is chosen such a way that the highest values in each of the categories are highlighted completely differently (for example, in the default view, area of Alaska (AK) is highlighted in green color and the next largest state Texas (TX) is colored differently) and intensity of the colors indicate how different or similar other states are. 
![tab2](tab2.png)
  The second tab contains the scatter plot matrix. The user can select the variables to be visualized in the scatter plot and also choose to plot the densities either by region or by division to which the state belongs to. The user can also visualize by selecting only a subset of the data based on the region the state belongs to.
![tab3](tab3.png)
  Similar to the second tab, the controls are kept consistent, the user can choose which variables are to be plotted and also can subset based on the region and also visualize the data based on either the region or its division. 