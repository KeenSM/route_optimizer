function output = coords_to_travel_time(coordinatesMatrix, originNum, destinationNum, selectedModeOfTransport, apiKey)
    %The purpose of this function is to interface with the google maps API
    %to convert an inputted origin and destinations coordinates to a travel
    %time. It takes an input of the coordinates matrix (a 3xL matrix
    %with labels (not used) in the first column, latitude in the 2nd and
    %longitude in the 3rd), the origin number, the destination number, the
    %selected mode of transport (using the legacy distance matrix api
    %format or "DRIVE" to call the traffic aware and more modern: Routes API) as a string and the API key. It outputs the Travel time as a
    %double in seconds.

    %Defining the origin and destination latitude and longitude
    originLat = coordinatesMatrix(originNum, 2);
    originLng = coordinatesMatrix(originNum, 3);
    destLat = coordinatesMatrix(destinationNum, 2);
    destLng = coordinatesMatrix(destinationNum, 3);

    %Checking if the user would like traffic aware or unaware
    if selectedModeOfTransport == "DRIVE" %(Traffic aware condition)
        url = 'https://routes.googleapis.com/distanceMatrix/v2:computeRouteMatrix';
        
        %Defining the origin lat and long in the google format
        origin = {struct( ...
            "waypoint", struct( ...
                "location", struct( ...
                    "latLng", struct( ...
                        "latitude", originLat, "longitude", originLng))))};
        
        %Defining the destination lat and long in the google format
        destination = {struct( ...
            "waypoint", struct( ...
                "location", struct( ...
                    "latLng", struct( ...
                        "latitude", destLat, "longitude", destLng))))};
        
        
        %Building request for the google Routes API
        body = struct("origins", {origin}, "destinations", {destination}, "travelMode", selectedModeOfTransport, "routingPreference", "TRAFFIC_AWARE");
        
        %Defining input/output type and api key
        options = weboptions('MediaType', 'application/json','HeaderFields', { ...
                                'X-Goog-Api-Key', apiKey; 'X-Goog-FieldMask', 'duration'}, ...
                             'Timeout', 20);
        
        %Pinging google API to get response in seconds
        response = webwrite(url, body, options);
        
        %Pulling output from struct and converting it to a double
        output = str2double(replace(response.duration, 's', ''));

    else %(Traffic unaware condition)

        %Ping the Distance Matrix API to get a response in seconds
        url = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=%s&key=%s';
        response = webread(sprintf(url, originLat, originLng, destLat, destLng, selectedModeOfTransport, apiKey));
        
        %Pulling output from struct
        output = response.rows.elements.duration.value;
    end
end