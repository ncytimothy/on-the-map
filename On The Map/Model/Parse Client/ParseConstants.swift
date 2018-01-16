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
        
        static let LimitValue = "100"
        static let LatestOrderValue = "-updatedAt"
        
        // MARK: URLs
        struct Parse {
            static let ApiScheme = "https"
            static let ApiHost = "parse.udacity.com"
            static let ParsePath = "/parse/classes"
            
        }
    }
    
    // MARK: Parameters Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Order = "order"
    }
    
    
    // MARK: Methods
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
    
    // MARK: API Key
    struct APIKeys {
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // MARK: HTTPHeader
    struct HTTPHeader {
        static let ParseHeader = "X-Parse-Application-Id"
        static let RESTHeader = "X-Parse-REST-API-Key"
    }
    
    // MARK: JSONResponseKeys
    struct JSONResponseKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaURL = "mediaURL"
    }
}
