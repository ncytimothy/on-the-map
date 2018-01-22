//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Timothy Ng on 1/8/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UdacityClient (Convenience Resource Methods)

extension UdacityClient {
    
    // MARK: Authentication Methods
    /*
     AUTHENTICATION FLOW:
     
     1. Post a new login session
     2. Get the session ID
     
     */
    
    
    func authenticateWithViewController(_ hostViewController: UIViewController, _ username: String, _ password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        postSession(username, password) { (success, errorString) in
            
            if success {
                completionHandlerForAuth(success, nil)
            } else {
                completionHandlerForAuth(success, "Error processing...")
            }
            
        }
    }
    
    
    private func postSession(_ username: String, _ password: String, completionHandlerForSession: @escaping (_ success: Bool,_ error: NSError?) -> Void) {
    
        /* 1. Specify the HTTP body */
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"

        /* 2. Make the request */

        let _ = taskForPOSTMethod(Methods.AuthenticationSessionNew, jsonBody: jsonBody, completionHandlerForPOST: {(result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForSession(false, NSError(domain: "postSession error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Your request returned an error: \(error)"]))
            } else {
                
                if let account = result?[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject], let uniqueKey = account[UdacityClient.JSONResponseKeys.UniqueKey] as? String {
                    print("uniqueKey: \(uniqueKey)")
                    userUniqueKey = uniqueKey
                    completionHandlerForSession(true, nil)
                } else {
                    completionHandlerForSession(false, NSError(domain: "postSession parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse as JSON: postSession"]))
                }
            }

        })
    }
    
    // MARK: Logout Session Methods
    func logoutSession(completionHandlerForLogout: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
       
        /* 1. Make the request */
        let _ = taskForDELETEMethod(Methods.AuthenticationSessionNew, completionHandlerForDELETE: {(result, error) in
            
            /* 2. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLogout(false, NSError(domain: "logoutSession Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Your request returned an error: \(error)"]))
            } else { completionHandlerForLogout(true, nil) }
        })
    }
}
