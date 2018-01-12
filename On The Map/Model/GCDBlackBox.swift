//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Timothy Ng on 1/11/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping() -> Void) {
    
    DispatchQueue.main.async {
        updates()
    }
}
