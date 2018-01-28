//
//  StudentStorage.swift
//  On The Map
//
//  Created by Timothy Ng on 1/27/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation

public var userUniqueKey: String = ""
var UserLocation = StudentInformation(dictionary: [:])

class SharedData {
    
    static let sharedInstance = SharedData()
    var StudentLocations = [StudentInformation]()
    private init() {}
    
}
