//
//  LocationsTableView.swift
//  On The Map
//
//  Created by Timothy Ng on 1/14/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation
import UIKit

class LocationsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell") as! UITableViewCell
        let information = StudentLocations[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = information.firstName
        
        return cell
    
    }
    
    
    
    
    
    
}
