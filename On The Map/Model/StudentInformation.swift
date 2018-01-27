//
//  StudentInformation.swift
//  On The Map
//
//  Created by Timothy Ng on 1/13/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation

public struct StudentInformation {
        var firstName: String? = LocationConstants.FirstName
        var lastName: String? = LocationConstants.LastName
        var latitude: Double? = LocationConstants.Latitude
        var longitude: Double? = LocationConstants.Longitude
        var mediaURL: String? = LocationConstants.MediaURL
        var objectID: String? = LocationConstants.ObjectID
        var uniqueKey: String? = LocationConstants.UniqueKey
        var mapString: String? = LocationConstants.MapString
    
        init(dictionary: [String:AnyObject]) {
            firstName =  dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
            lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
            latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
            longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
            mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
            objectID = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String
            uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
            mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        }
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> 
        [StudentInformation] {
        
            var locations = [StudentInformation]()
            
            for result in results {
                locations.append(StudentInformation(dictionary: result))
            }
        
            return locations
    }
    
    static func userLocationFromResults(_ results: [[String:AnyObject]]) -> StudentInformation? {
        
        var userLocations = results
        var userLocation: StudentInformation?
        
        if let lastestLocation = userLocations.popLast() {
            userLocation = StudentInformation(dictionary: lastestLocation)
        }
        
        return userLocation

    }
}


