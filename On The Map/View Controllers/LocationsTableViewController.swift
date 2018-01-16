//
//  LocationsTableView.swift
//  On The Map
//
//  Created by Timothy Ng on 1/14/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation
import UIKit

class LocationsTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell") as! LocationsTableViewCell
        let information = StudentLocations[(indexPath as NSIndexPath).row]
        
        cell.nameLabel?.text = information.firstName + " " + information.lastName
        cell.urlLabel?.text = information.mediaURL
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let information = StudentLocations[(indexPath as NSIndexPath).row]
        if let url = URL(string: information.mediaURL) {
            UIApplication.shared.open(url)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
