# pixel_editor_app

This app specialises in giving users the ability to create their own pixel art

## For Developers

In order to understand how flutter works, and specifically how this project's code works research these topics beforehand:
* Cubits for state management
* Stateful and Stateless Widgets

### How this code is structured ###

To access the source code, it is in the "lib" folder and broken up into 3 parts:
* Cubit -> 
This folder holds all of the cubits that the widgets use. This includes data of the current color selected, which grids are created, which images have been imported etc.

* Tools ->
This folder holds the code for the ToolBar's buttons. They all inherit from an "mixin" called "CustomToolBar.dart" where they all must implement the function "ToolBarButton" inn their build function. This makes sure all of the buttons look and work identically.

* Root ->
This is the root of the "lib" folder. All fils here don't belong in a specific folder. These files include "main.dart" where the program runs and "CreateGird.dart" which is the code that handles the grid and its user interactions.

### Specific file use cases ###

* ColorWheelPopUp -> Displays the color wheel
* CustomToolBar -> The widget that displays all of the button/tools
* ExportForm/GridForm -> Identical forms that handle exporting grids and creating grids respectively
* ImageWrapper -> All images are placed in this widget, this allows for the image to be moved, selected and resized

