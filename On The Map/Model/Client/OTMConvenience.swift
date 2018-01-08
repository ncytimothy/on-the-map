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
    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        postSession() { (success, sessionID, errorString) in
            
            
            
        }
        
    }
    
    private func postSession(_ completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
    
        /* 1. Specify the HTTP body */
        let jsonBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
        
        
       
    
    }
    
    
    func display() {
        print("\(User.username)")
        print("\(User.password)")
    }
    
}
