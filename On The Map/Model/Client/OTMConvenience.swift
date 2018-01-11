//
//  OTMConvenience.swift
//  On The Map
//
//  Created by Timothy Ng on 1/8/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation
import UIKit

// MARK: - OTMClient (Convenience Resource Methods)

extension OTMClient {
    
    // MARK: Authentication Methods
    /*
     AUTHENTICATION FLOW:
     
     1. Post a new login session
     2. Get the session ID
     
     */
    
    
    
    func authenticateWithViewController(_ hostViewController: UIViewController, _ username: String, _ password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        postSession(username, password) { (success, sessionID, errorString) in
            
            if success {
                print("sessionID: \(sessionID)")
            }
            
        }
        
    }
    
    private func postSession(_ username: String, _ password: String, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: NSError?) -> Void) {
        
        print("username: \(username)")
        print("password: \(password)")
        
//        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil { // Handle error…
//                return
//            }
////            let range = Range(5..<data!.count)
////            let newData = data?.subdata(in: range) /* subset response data! */
//            print(String(data: data!, encoding: .utf8)!)
//        }
//        task.resume()
    
        /* 1. Specify the HTTP body */
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"

        /* 2. Make the request */

        let _ = taskForPOSTMethod(Methods.AuthenticationSessionNew, jsonBody: jsonBody, completionHandlerForPOST: {(result, error) in
            
            print("result: \(result)")

            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForSession(false, nil, NSError(domain: "postSession error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Your request returned an error: \(error)"]))
            } else {
                if let session = result?[OTMClient.JSONResponseKeys.Session] as? [String:AnyObject], let sessionID = session[OTMClient.JSONResponseKeys.SessionID] as? String {
                    print("sessionID: \(sessionID)")
                    completionHandlerForSession(true, sessionID, nil)
                } else {
                    completionHandlerForSession(false, nil, NSError(domain: "postSession parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse postSession"]))
                }
            }

        })
    }
}
