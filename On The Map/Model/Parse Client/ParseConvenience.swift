//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Timothy Ng on 1/12/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    func getStudentLocations(_ completionHandlerForStudentLoc: @escaping (_ success: Bool, _ result: [StudentInformation]?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters */
        let parameters = [ParseClient.ParameterKeys.Limit: ParseClient.ParameterValues.LimitValue as AnyObject, ParseClient.ParameterKeys.Order: ParseClient.ParameterValues.LatestOrderValue] as [String:AnyObject]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.StudentLocation, parameters, completionHandlerForGET: {(result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForStudentLoc(false, nil, "Get Student Locations Failed.")
            } else {
                if let result = result?["results"] as? [[String:AnyObject]] {
//                    print("result: \(result)")
                    let locations = StudentInformation.studentLocationsFromResults(result)
                    StudentLocations = locations
                    completionHandlerForStudentLoc(true, locations, nil)
                } else {
                    print("Cannot parse JSON!")
                }
            }
        })
    }
    
    func getUserLocation(_ completionHandlerForUserLocation: @escaping (_ success: Bool, _ result: StudentInformation?, _ errorString: String?) -> Void) {
        
        /* 1. Specify the parameters */
        let parameters = [ParseClient.ParameterKeys.Where: "{\"\(ParseClient.ParameterValues.UniqueKey)\":\"\(userUniqueKey)\"}"] as [String:AnyObject]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.StudentLocation, parameters, completionHandlerForGET: {(result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForUserLocation(false, nil, "Get User Location Failed.")
            } else {
                
                guard let result = result?["results"] as? [[String:AnyObject]], !result.isEmpty else {
                    print("User Location not found!")
                    return
                }
                
                if let userLocation = StudentInformation.userLocationFromResults(result) {
                    UserLocation = userLocation
                    completionHandlerForUserLocation(true, userLocation, nil)
                }                
            }
        })
    }
    
    func postStudentLocation(_ mapString: String, _ mediaURL: String, _ latitude: Double, _ longtitude: Double, _ completionHandlerForPostStudentLocation: @escaping (_ success: Bool,  _ error: NSError?) -> Void) {
        
        /* 1. Specify the HTTP body */
        let jsonBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(userUniqueKey)\", \"\(JSONBodyKeys.FirstName)\": \"\(UserLocation.firstName)\", \"\(JSONBodyKeys.LastName)\": \"\(UserLocation.lastName)\",\"\(JSONBodyKeys.MapString)\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"\(JSONBodyKeys.Latitude)\": \(latitude), \"longitude\": \(longtitude)}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(Methods.StudentLocation, jsonBody: jsonBody, completionHandlerForPOST: {(result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPostStudentLocation(false, NSError(domain: "postStudentLocation error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Your request returned an error: \(error)"]))
            } else {
                
                if let objectID = result?[ParseClient.JSONResponseKeys.ObjectID] as? String {
                    UserLocation.objectID = objectID
                    completionHandlerForPostStudentLocation(true, nil)
                } else {
                    completionHandlerForPostStudentLocation(false, NSError(domain: "postStudentLocation error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse as JSON: postStudentLocation"]))
                }
                
            }
        })
    }
    
    func putStudentLocation(_ mapString: String, _ mediaURL: String, _ latitude: Double, _ longitude: Double, _ completionHandlerForPutStudentLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        /* 1. Specify the HTTP Body */
//        let jsonBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(userUniqueKey)\", \"\(JSONBodyKeys.FirstName)\": \"\(UserLocation.firstName)\", \"\(JSONBodyKeys.LastName)\": \"\(UserLocation.lastName)\",\"\(JSONBodyKeys.MapString)\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\", \"\(JSONBodyKeys.Latitude)\": \(latitude), \"\(JSONBodyKeys.Longitude)\": \(longtitude)}"
        
        let latitude = String(latitude)
        let longitude = String(longitude)
        
        let jsonBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(UserLocation.uniqueKey!)\", \"\(JSONBodyKeys.FirstName)\": \"\(UserLocation.firstName!)\", \"\(JSONBodyKeys.LastName)\": \"\(UserLocation.lastName!)\",\"\(JSONBodyKeys.MapString)\": \"\(mapString)\", \"\(JSONBodyKeys.MediaURL)\": \"\(mediaURL)\",\"\(JSONBodyKeys.Latitude)\": \(latitude), \"longitude\": \(longitude)}"

        /* 2. Make the request */
        let _ = taskForPUTMethod("\(Methods.StudentLocation)"+"/\(UserLocation.objectID!)", jsonBody: jsonBody, completionHandlerForPOST: {(result, error) in
            
            /* 3. Send the desire value(s) to completion handler */
            if let error = error {
                completionHandlerForPutStudentLocation(false, NSError(domain: "putStudentLocation error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Your request returned an error: \(error)"]))
            } else {
                completionHandlerForPutStudentLocation(true, nil)
            }
        })
    }
    
}
