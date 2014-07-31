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
The inputs are 800*800 image matrix in points file. Just run "python sample_selector.py". There will be a image file called sample.png generated. The ordered points will be saved in sample file.
