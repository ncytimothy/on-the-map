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
        
        /* 1. Make the request */
        let _ = taskForGETMethod(Methods.StudentLocation, completionHandlerForGET: {(result, error) in
            
            /* 2. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForStudentLoc(false, nil, "Get Student Locations Failed.")
            } else {
                if let result = result?["results"] as? [[String:AnyObject]] {
                    let locations = StudentInformation.studentLocationsFromResults(result)
                    StudentLocations = locations
                    completionHandlerForStudentLoc(true, locations, nil)
                } else {
                    print("Cannot parse JSON!")
                }
            }
            
        })
        
    }
    
}
