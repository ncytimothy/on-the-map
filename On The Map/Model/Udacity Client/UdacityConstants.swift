//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Timothy Ng on 1/6/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

extension UdacityClient {

    // MARK: Constants
    
    struct Constants {
        
        // MARK: URLs
        struct Udacity {
            static let ApiScheme = "https"
            static let ApiHost = "www.udacity.com"
            static let ApiPath = "/api"
            static let SignUp = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
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
    
    // MARK: Alert Controller
    struct Alert {
        static let NoInternetTitle = "No internet connection"
        static let NoInternetMessage = "Please check your internet connection settings."
        static let OK = "OK"
        static let EmptyFieldTitle = "Whoops!"
        static let EmptyFieldMessage = "Empty Email or Password"
        static let Dismiss = "Dismiss"
        static let InvalidTitle = "Invalid Login"
        static let InvalidMessage = "Invalid email or password"
        static let TryAgain = "Try Again"
        
    }
    
}



