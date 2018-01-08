//
//  OTMConstants.swift
//  On The Map
//
//  Created by Timothy Ng on 1/6/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit

// MARK: - Constants

struct Constants {
    
    struct Udacity {
        static let ApiScheme = "https"
        static let ApiHost = "udacity.com"
        static let ApiPath = "/api"
    }
}

struct Methods {
    static let AuthenticationSessionNew = "/session"
}

struct User {
    static var username: String? = nil
    static var password: String? = nil
}
