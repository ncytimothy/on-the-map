//
//  ParseConstants.swift
//  On The Map
//
//  Created by Timothy Ng on 1/12/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

extension ParseClient {

    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        struct Parse {
            static let ApiScheme = "https"
            static let ApiHost = "parse.udacity.com"
            static let ParsePath = "/parse/classes"
        }
    }
    
    // MARK: Methods
    struct Methods {
        static let StudentLocation = "/StudentLocation?limit=100"
    }
    
    // MARK: API Key
    struct APIKeys {
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct HTTPHeader {
        static let ParseHeader = "X-Parse-Application-Id"
        static let RESTHeader = "X-Parse-REST-API-Key"
    }
    
}
