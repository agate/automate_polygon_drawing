##Purpose
----------
This script is used to select ordered sample points from polygons, which could be used to re-construct ploygons in the map.
##Pre-requisite
----------
1. Install python. Run "brew install python". Both python and pip(package manager of python) should beinstalled)
2. Install numpy. Run "pip install numpy"
3. Install pillow. Run "pip install pillow"

##How to Run
----------
Run:
python sample_selector.py input_file interval
input_file is the file path of output of step image_to_polygen. The program will travel over the polygon and pick a sample point every interval points.
