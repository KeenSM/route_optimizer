clear, clc

%Please read the attached README.MD for instructions and warnings on use.

%Hard coded variables (Add your API Key Here)
apiKey = '';
maxNumOfAttempts = 500000000;

%Adding subdirectories
addpath('apps/');
addpath('user_functions/');
addpath('apps/referenced_files');



% PULLING USER INPUT_______________________________________________________
%Loading the input popup
inputApp = input_app;

%Waiting while the user inputs data into popups
while isvalid(inputApp)
    pause(.1)
end

%loading data from input popup
load('input.mat');

tic

%Checking that the loaded data is new
currentTime = datetime('now', 'TimeZone', 'UTC', 'Format', 'yyyyMMdd.hhmmss');
if currentTime > inputTime + .0001
    warningFig = uifigure('Position',[100 100 500 250]);
    uialert(warningFig, ["Input Screen was Closed by User"; "Program Terminated"],'Error: Input Screen Exited', 'CloseFcn', @(~, ~)close(warningFig))
    return;
end
clear currentTime, clear inputTime

%Calculating the number of inputs
numOfInputs = numOfIntermediates + 2;



% CALCULATING THE DATA MATRIX______________________________________________
%Converting the search inputs to a list of coordinates
coordinatesMatrix = maps_search_to_coords(mapsSearchMatrix, apiKey);

%Preallocating the data matrix 
dataMatrix = zeros(numOfInputs);

%Checking what is being optimized
if optimizeForDistance == true
    %Repeating for every position in the matrix
    for originNum = 1:numOfInputs
        for destinationNum = 1:numOfInputs
            %Skipping an iteration if it is the same destination and origin
            if destinationNum == originNum
                continue
            end
            %Pulling the travel distance with a user function and writing it to
            %the data matrix
            travelDistance = coords_to_travel_distance(coordinatesMatrix, originNum, destinationNum, selectedModeOfTransport, apiKey);
            dataMatrix(destinationNum, originNum) = travelDistance;
        end
    end
else
    %Repeating for every position in the matrix
    for originNum = 1:numOfInputs
        for destinationNum = 1:numOfInputs
            %Skipping an iteration if it is the same destination and origin
            if destinationNum == originNum
                continue
            end
            %Pulling the travel time with a user function and writing it to
            %the data matrix
            travelTime = coords_to_travel_time(coordinatesMatrix, originNum, destinationNum, selectedModeOfTransport, apiKey);
            dataMatrix(destinationNum, originNum) = travelTime;
        end
    end
end
clear originNum, clear destinationNum, clear travelTime, clear travelDistance



% FINDING THE OPTIMAL ROUTE________________________________________________
%Running an optimization and memory allocation if the number of
%intermediates is higher than 8
if numOfIntermediates > 8
    %Finding the two locations with the shortest value between them
    dataMatrix(dataMatrix == 0) = Inf;
    [firstClosestLocationNum, secondClosestLocationNum] = find(dataMatrix == min(dataMatrix, [], "all"));
    
    %Defining variables referenced later
    index = 1:numOfInputs;
    possibleRouteNum = 1;

    %Defines the list of permutations per each first value in the list
    %(memory allocation)
    possibleRoutes = zeros((factorial(numOfIntermediates-1) * 2), numOfInputs);
    for firstValue = 2:numOfIntermediates + 1
        %Removing first value from the permutation list
        listOfIntermediates = 2:numOfIntermediates+1;
        listOfIntermediates(listOfIntermediates == firstValue) = [];

        %Generating the list permutations without the first value
        permutations = perms(listOfIntermediates);

        %Adding the origin, first value and destination to the list of permutations
        firstValueColumnArray = repmat(firstValue, size(permutations, 1), 1);
        permutations = [ones(size(permutations, 1), 1), firstValueColumnArray, permutations, ones(size(permutations, 1), 1) * numOfInputs];
        
        %Testing if each permutation contains the two locations with the
        %lowest value next to each other
        for permNum = 1:size(permutations, 1)
            if abs(sum(index.*(permutations(permNum, :) == firstClosestLocationNum(1)) - index.*(permutations(permNum, :) == secondClosestLocationNum(1)))) == 1
                possibleRoutes(possibleRouteNum, :) = permutations(permNum, :);
                possibleRouteNum = possibleRouteNum + 1;
            end
        end 
    end

    %Condition to stop an error if one of the closest locations is the
    %destination or origin
    if possibleRouteNum < size(possibleRoutes, 1)
        possibleRoutes = possibleRoutes(1:possibleRouteNum-1, :);
    end
else
    %Generating list of permutations if the # of intermediates is 8 or less
    possibleRoutes = [ones(factorial(numOfIntermediates), 1), perms(2:numOfIntermediates + 1), repmat(numOfInputs, factorial(numOfIntermediates), 1)];
end
clear firstClosestLocationNum, clear secondClosestLocationNum, clear listOfIntermediates, clear index
clear possibleRouteNum, clear permNum, clear firstValueColumnArray, clear firstValue, clear permutations

%Testing every route
minRouteValue = inf;
for testNum = 1:size(possibleRoutes, 1)
    %Selecting a route to test
    selectedRoute = possibleRoutes(testNum, :);

    %Preallocating Route Values matrix
    selectedRouteValues = zeros(1, numOfInputs - 1);

    %Finding the value of the legs of the journey
    for stopNum = 1:numOfInputs - 1
        selectedRouteValues(stopNum) = dataMatrix(selectedRoute(stopNum + 1), selectedRoute(stopNum));
    end
    
    %Finding the total value of the route
    totalRouteValue = sum(selectedRouteValues);

    %Saving the value if it is the new minimum
    if totalRouteValue < minRouteValue
        minRouteValue = totalRouteValue;
        minRouteNum = testNum;
        minRoute = selectedRoute;
        minRouteValueArray = selectedRouteValues;
    end

    %Break condition if to many attempts are executed
    if testNum == maxNumOfAttempts
        break
    end
end
clear testNum, clear selectedRoute, clear selectedRouteValues, clear totalRouteValue, clear stopNum



% DISPLAYING RESULTS TO THE USER___________________________________________
%Reindexing addresses in the order of the minimum route
outputSearches = strings(numOfInputs, 1);
for i = 1:numOfInputs
    outputSearches(i) = coordinatesMatrix(minRoute(i),1);
end

%Formatting the total result based on the type of optimization performed
if optimizeForDistance == true
    numOfLeadingZeros = floor(log10(minRouteValue)) + 1;
    if numOfLeadingZeros < 1
        numOfLeadingZeros = 1;
    end
    outputValue = sprintf("%.2f Miles", minRouteValue);
else
    numOfLeadingZeros = floor(log10(floor(minRouteValue/3600))) + 1;
    if numOfLeadingZeros < 1
        numOfLeadingZeros = 1;
    end
    outputValue = sprintf("%.0f Hour(s) %02.0f Minutes(s)", floor(minRouteValue/3600), rem(minRouteValue/60, 60));
end

%Formatting the individual segments output
routeSegmentsFormatted = strings(numOfInputs - 1, 1);
routeValuesFormatted = strings(numOfInputs  - 1, 1);
for i = 1:numOfInputs - 1
    %Formatting the segment being printed
    routeSegmentsFormatted(i) = sprintf("%s to %s", outputSearches(i), outputSearches(i+1));
    
    %Formatting each legs result based on the type of optimization performed
    if optimizeForDistance == true
        routeValuesFormatted(i) = sprintf("%0*.2f Miles", numOfLeadingZeros + 3, minRouteValueArray(i));
    else
        routeValuesFormatted(i) = sprintf("%0*.0f Hour(s) %02.0f Minutes(s)", numOfLeadingZeros, floor(minRouteValueArray(i)/3600), rem(minRouteValueArray(i)/60, 60));
    end
end
clear i

%Formatting the travel type
switch selectedModeOfTransport
    case "DRIVE"
        outputTravelType = "Driving (Traffic Aware)";
    case "driving"
        outputTravelType = "Driving (Traffic Unaware)";
    case "walking"
        outputTravelType = "Walking";
    case "bicycling"
        outputTravelType = "Biking";
end

%Pulling current date and time
date = string(datetime('now', 'Format', "MM/dd/yyyy"));
time = string(datetime('now', 'Format', "HH:mm:ss"));

%Creating/overriding current output and opening to write new data
outputFileId = fopen('output.txt', 'w');

%Defining a field width (to center justify the text)
minOutputSpacing = 24;
fieldWidth = max([strlength(routeSegmentsFormatted); minOutputSpacing]);

%Centering header
header = sprintf("Route from %s to %s generated on %s at %s", outputSearches(1), outputSearches(numOfInputs), date, time);
if strlength(header) > fieldWidth * 2
    fieldWidth = round(strlength(header)/ 2);
    centeredHeader = sprintf(header + "\n\n");
else
    centeringWidth = round(fieldWidth - strlength(header) / 2) - 1;
    centeredHeader = sprintf("%*s%s%-*s\n\n", centeringWidth, " ", header, centeringWidth, " ");
end

%Printing Header
fprintf(outputFileId, centeredHeader);

%Printing (and centering) new data
fprintf(outputFileId, "%*s %-.2f Second(s)\n", fieldWidth + 1, "Calculation Time:", toc);
fprintf(outputFileId, "%*s #%-.0f\n", fieldWidth + 1, "Route Number:", minRouteNum);
fprintf(outputFileId, "%*s %-s\n", fieldWidth + 1, "Mode of Transportation:", outputTravelType);
fprintf(outputFileId, "%*s %-s\n\n", fieldWidth + 1, "The Entire Route is:", outputValue);

%Printing route segments
for i = 1:numOfInputs - 1
    fprintf(outputFileId, "%*s: %-s\n", fieldWidth, routeSegmentsFormatted(i), routeValuesFormatted(i));
end
clear i, clear fieldWidth, clear centeringWidth, clear routeValuesFormatted, clear routeSegmentsFormatted 
clear numOfLeadingZeros, clear centeredHeader, clear header

%Closing the file
fclose(outputFileId);

%Printing a command window message upon completion
disp("The program was successfully executed")