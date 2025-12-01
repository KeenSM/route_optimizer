function output = maps_search_to_coords(mapsSearchMatrix, apiKey)
    %The purpose of this function is to convert a column array of google
    %maps searches into a matrix of coordinates with the searches next
    %to them. This function relies on the google Geocoding API and if
    %multiple results are found it automatically pulls the top result. The
    %inputs for this function are a string column array of the users google
    %maps searches and the maps API key. It outputs the inputted column
    %array with the lat and long of each location in column 2 and 3
    %respectively. This creates a 3xL matrix.

    %Finding the number of inputs given by the user
    numOfInputs = size(mapsSearchMatrix, 1);
    
    %If the destination is left blank, it is updated to be the same as the origin
    if mapsSearchMatrix(numOfInputs) == ""
        mapsSearchMatrix(numOfInputs) = mapsSearchMatrix(1);
    end

    %Making search strings ready to be used by replacing spaces with "%20"
    apiReadyMapsSearchMatrix = replace(mapsSearchMatrix, ' ', '%20');
    
    %Finding the lat and long of each search by Pinging the Geocoding API
    coordinatesMatrix = zeros(numOfInputs, 2);
    for i = 1:numOfInputs
        latAndLong = webread(sprintf("https://maps.googleapis.com/maps/api/geocode/json?key=%s&address=%s", apiKey, apiReadyMapsSearchMatrix(i)));
        
        %Removing an API Error associated with certain searches
        if size(latAndLong.results,1) > 1
            coordinatesMatrix(i, :) = [latAndLong.results{1,1}.geometry.location.lat, latAndLong.results{1,1}.geometry.location.lng];
        else
            coordinatesMatrix(i, :) = [latAndLong.results(1).geometry.location.lat, latAndLong.results(1).geometry.location.lng];
        end
    end

    %Adding the search column to the output
    output = [mapsSearchMatrix, coordinatesMatrix];
end