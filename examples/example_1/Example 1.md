#### Example 1

Say you are a student at the University of Kansas searching for deals at the various best buys in the Kansas City area as well as the Best Buy in Lawrence. To achieve this you need to visit every single one to see if they have the deal you are looking for and you would like to do this route in the shortest amount of time possible. This example shows various ways to input that data into the GUI as well as the output you would expect.



##### Input Fields and Explanations:

###### How many Intermediate Destinations do you have? (7)

The user selected "7" because that is the number of Best Buy Locations in Kansas City and Lawrence and therefore the number he would like to visit



###### What do you want to Optimize for? (Optimize for Travel Time)

The user selected "Optimize for Travel Time" because they need to minimize the time spent traveling between the various locations.



###### What Mode of Transport will you be Using? (Driving (Traffic Aware))

The user selected "Driving (Traffic Aware)" because they are trying to find the optimal driving route given the current traffic conditions



###### Origin (Daisy Hill Parking, Lawrence KS)

The user entered this as their origin because it is the place they plan to start their journey



###### 1st Intermediate (Lawrence Best Buy)

The user can enter a broad term like this because there is only one Best Buy in Lawrence, so the API knows exactly what the user is referring to.



###### 2nd Intermediate (9301 Quivira Rd, Overland Park, KS)

The user inputted the address of the store, this is best practice for stores with multiple locations in a city



###### 3rd Intermediate (Overland Park Best Buy (Metcalf Ave))

The user inputted the store with another distinguishing feature added to help the script locate the specific store the user is requesting



###### 4th Intermediate (Summit Woods Crossing)

The user inputted the shopping mall that the Lee's Summit Best Buy is located in. For scripts that cover longer distances, this is fine because it does not majorly affect the live drive time, however it is not a recommended form of input.



###### 5th Intermediate (39.0502, -94.3549)

The user inputted a set of coordinates for the Independence Best Buy Location, this is not recommended because it hurts the readability of the output file, but can be used. This is especially true for locations that can be easily found with an English word search such as this input.



###### 6th Intermediate (Northeast Best Buy Kansas City)

The user inputted a general side of town that the Best Buy is in as well as the city it is in. This is not recommended and should be double checked on google maps before use to check that it yields the desired location.



###### 7th Intermediate (Best Buy near MCI Airport)

The user inputted the location by tieing it to a nearby landmark. This approach is not recommended and should be double checked on a google maps search before being used to make sure it does not yield the wrong location, but it can be used in this script.



###### Destination ()

The user left this field blank because it is the same as the Origin. If the destination were different from the origin, it can be entered in this field