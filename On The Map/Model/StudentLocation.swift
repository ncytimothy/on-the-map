//
//  StudentLocation.swift
//  On The Map
//
//  Created by Timothy Ng on 1/13/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation
public struct StudentInformation {
        var uniqueKey: String
        var firstName: String
        var lastName: String
        var latitude: Double
        var longitude: Double
        var mediuaURL: String
    
        init(dictionary: [String:AnyObject]) {
            uniqueKey = dictionary["uniqueKey"] as! String
            firstName =  dictionary["firstName"] as! String
            lastName = dictionary["lastName"] as! String
            latitude = dictionary["latitude"] as! Double
            longitude = dictionary["longitude"] as! Double
            mediuaURL = dictionary["mediaURL"] as! String
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

