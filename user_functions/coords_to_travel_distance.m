function output = coords_to_travel_distance(coordinatesMatrix, originNum, destinationNum, selectedModeOfTransport, apiKey)
    %The purpose of this function is to interface with the google maps API
    %to convert an inputted origin and destinations coordinates to a travel
    %distance. It takes an input of the coordinates matrix (a 3xL matrix
    %with labels (not used) in the first column, latitude in the 2nd and
    %longitude in the 3rd), the origin number, the destination number, the
    %selected mode of transport (using the legacy distance matrix api
    %format) as a string and the API key. It outputs the distance as a
    %double in miles. 

    %Defining the origin and destination latitude and longitude
    originLat = coordinatesMatrix(originNum, 2);
    originLng = coordinatesMatrix(originNum, 3);
    destLat = coordinatesMatrix(destinationNum, 2);
    destLng = coordinatesMatrix(destinationNum, 3);

    %Ping the API to get a response in meters
    url = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=%s&key=%s';
    response = webread(sprintf(url, originLat, originLng, destLat, destLng, selectedModeOfTransport, apiKey));
        
    %Converting the response to miles
    output = response.rows.elements.distance.value/1609.3445;
end