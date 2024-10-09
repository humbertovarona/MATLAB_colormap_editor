# MATLAB_colormap_editor

Generate random colormaps for MATLAB

# Colormap Editor for MATLAB

This MATLAB script provides a graphical user interface (GUI) for creating, editing, importing, exporting, and visualizing colormaps. It's a useful tool for customizing colormaps for your data visualizations in MATLAB.

## Features

- **Create Custom Colormaps**: Build your own colormaps by adding, editing, or deleting colors.
- **Import and Export Colormaps**: Load colormaps from `.mat` files or import them from the MATLAB workspace. Export your customized colormaps to `.mat` files or to the workspace.
- **Adjust Colormap Size**: Choose from predefined sizes (2, 4, 8, 16, 32, 64, 128, 256 colors).
- **Random Colormap Generation**: Generate random colormaps to explore different visualizations.
- **Interactive Color Editing**: Click on the palette or table to edit individual colors using a color picker.
- **Real-Time Visualization**: View the colormap as you edit it for instant feedback.

## Requirements

- **MATLAB R2014b** or later (due to the use of graphics features introduced in R2014b).
- No additional toolboxes required.

## Installation

1. Download the `colormap_editor.m` file.
2. Save the file in a directory that is in your MATLAB path or add the directory to the path using `addpath`.

## Usage

### Launch the Colormap Editor

Run the following command in the MATLAB Command Window:

```matlab
colormap_editor
```

This will open the editor's graphical interface.

### Interface Description

The GUI contains the following components:
- Colormap Size Dropdown: Select the number of colors in the colormap.
- Action Buttons:
    - Add Color: Add a new color to the colormap.
    - Delete Color: Delete the selected color.
    - Random Colormap: Generate a colormap with random colors.
    - Import Colormap: Load a colormap from a .mat file.
    - Export Colormap: Save the current colormap to a .mat file.
    - Import from Workspace: Load a colormap from a workspace variable.
    - Export to Workspace: Save the current colormap to the workspace.
- Color Table: Displays the indices and RGB values of the colors.
- Color Palette: Visualizes the colormap for interactive editing.

### Select Colormap Size
- Use the dropdown menu in the top-left corner to select the desired size.
- Available sizes are: 2, 4, 8, 16, 32, 64, 128, and 256 colors.

### Add a New Color
- Click on Add Color.
- Select a color in the color picker that appears and click OK.
- The color will be added to the end of the colormap.

### Delete a Color
- Select a color in the Color Table or the Color Palette.
- Click on Delete Color.
- The selected color will be removed.

### Edit a Color
- Click on a color in the Color Table or the Color Palette.
- The color picker will open with the current color.
- Choose a new color and click OK.
- The color in the colormap will be updated.

### Generate a Random Colormap
- Click on Random Colormap.
- The current colormap will be filled with random colors.

### Import a Colormap from a File
- Click on Import Colormap.
- Select a .mat file that contains a cmap variable.
- Click Open.
- The colormap will be loaded and displayed.

### Export the Colormap to a File
- Click on Export Colormap.
- Specify the name and location of the .mat file.
- Click Save.
- The current colormap will be saved to the file.

### Import from Workspace
- Click on Import from Workspace.
- Enter the name of the variable that contains the colormap.
- If the variable is valid, the colormap will be loaded.

### Export to Workspace
- Click on Export to Workspace.
- Enter the name for the colormap variable.
- The current colormap will be saved to the workspace with that name.

### Example Usage

After creating and customizing a colormap:

```matlab
% Run the editor
colormap_editor

% Once satisfied with the colormap, export it to the workspace
% and apply it to a plot
colormap_name = 'myCustomColormap';
myColormap = evalin('base', colormap_name);

% Apply the colormap to a plot
surf(peaks);
colormap(myColormap);
colorbar;
```

### Additional Notes

- Color Interpolation: When changing the size of the colormap, colors are adjusted via interpolation to maintain smooth transitions.
- Color Selection: You can select and edit colors directly from the visual palette or the table.

## License

CC0 1.0 Universal (CC0 1.0) Public Domain Dedication

This script is dedicated to the public domain under the CC0 1.0 Universal license. You can copy, modify, distribute, and perform the work, even for commercial purposes, all without asking permission.
