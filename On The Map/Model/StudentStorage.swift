//
//  StudentStorage.swift
//  On The Map
//
//  Created by Timothy Ng on 1/27/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation

public var userUniqueKey: String = ""
var StudentLocations = [StudentInformation]()
var UserLocation = StudentInformation(dictionary: [:])

func sharedInstance() -> StudentInformation {
    struct Singleton {
        static var sharedInstance = StudentInformation(dictionary: [:])
    }
    return Singleton.sharedInstance
}

