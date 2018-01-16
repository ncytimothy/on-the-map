//
//  StudentLocation.swift
//  On The Map
//
//  Created by Timothy Ng on 1/13/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation

public var userUniqueKey: String = ""

public struct StudentInformation {
        var firstName: String
        var lastName: String
        var latitude: Double
        var longitude: Double
        var mediaURL: String
    
        init(dictionary: [String:AnyObject]) {
            firstName =  dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
            lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
            latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
            longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
            mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        }
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> 
        [StudentInformation] {
        
            var locations = [StudentInformation]()
            
            for result in results {
                locations.append(StudentInformation(dictionary: result))
            }
        
            return locations
    }
    
}
    
var StudentLocations = [StudentInformation]()

