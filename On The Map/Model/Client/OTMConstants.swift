//
//  OTMConstants.swift
//  On The Map
//
//  Created by Timothy Ng on 1/6/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

extension OTMClient {

    // MARK: Constants
    
    struct Constants {
        
        // MARK: URLs
        struct Udacity {
            static let ApiScheme = "https"
            static let ApiHost = "www.udacity.com"
            static let ApiPath = "/api"
        }
    }
    
    // MARK: Methods
    struct Methods {
        static let AuthenticationSessionNew = "/session"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSONResponseKeys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusCode = "status"
        static let Error = "error"
        static let Session = "session"
        static let SessionID = "id"
        
    }
    
}



