### **Route Optimizer README**

#### **What is the Route Optimizer?**

The Route Optimizer is an open source software developed to find the optimal travel time or travel distance between an origin and destination with up to 12 intermediate destinations. The script allows the user to select driving (traffic aware or traffic unaware), biking or walking as a mode of transport. Traffic aware pulls live traffic data, while traffic unaware bases it on the average travel time. The script relies on the google maps API to find an accurate travel time or travel distance between the various locations based on the route a user would reasonably take. Examples of how this script can be used can be found in the "examples" folder attached to this directory.



#### Warnings

The Route Optimizer is tested to work on computers with 16gb of memory or higher, proceed with caution if using a computer with less than 16gb of memory.

The "traffic aware drive time" mode uses a different google API that takes significantly longer to access, for larger requests this can mean multiple minutes waiting for the travel time to every location to fill out.

On older computers, a 12 intermediate location request can take multiple minutes to solve the minimum route. Please be patient if running on older hardware.

The script is tested to work on MacOS Sequoia and Windows 11, proceed with caution if using a computer running a different OS.

If a specific store is called in a location box that has multiple locations in the specified city the top result that would appear on google maps will be populated. If a different location is desired more detail should be added, such as "The Home Depot, Kansas City (Johnson Dr.)" instead of "The Home Depot, Kansas City"

This script requires wifi to properly run. Verify your wifi connection before running the script.



#### Instructions for Use

1. Follow the installation and setup guide to prepare the script for use.
2. Read all warnings contained above before use.
3. Hit the run button and wait for the GUI to popup.
4. It is suggested that you fill out the left side fields first, from top to bottom.
5. Fill in all location fields that appear on the GUI after selecting the number of intermediate destinations you have. You may leave the destination field blank if it is the same as the origin. The location fields can be filled with any input that would typically go into a google maps search. Typical inputs are usually: addresses, cities, specific stores, or coordinates.
6. Hit the continue button. (any issues will pop up in the form of an error warning).
7. Wait for the message "The program was successfully executed" to be displayed in the command window.
8. Open the output.txt file to find the information on the optimal route.



#### **Project Status**

Status: [Released]

Current Version: [1.0.1]

Last Editor: Schledorn-Mott, K.

Last Edited Date: 2025.11.25



#### **Author**

The project was developed by Keen Schledorn-Mott and was initially released on 2025.11.20



#### **Installation and Setup Guide**

This project was developed for MATLAB R2024b and should be run on that version or a later version.

Download the route_optimizer.zip file and extract it. Open the route_optimizer.m file file in MATLAB and add a google API key to the apiKey variable at the top of the script. 



#### Changelog

The entire changelog is documented in the CHANGELOG.md included in the zip file.



#### **Known Problems**

There are no known problems with this software as of 2025.11.20



#### **License**

The Route Optimizer is free and open-source software licensed under the GNU General Public License v3.0

See LICENSE.txt for more information
