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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableView()
    }
    
    // MARK: Action
    @IBAction func pressRefresh(_ sender: Any) {
        updateTableView()
    }
    
    
    func updateTableView() {
        ParseClient.sharedInstance().getStudentLocations({(success, result, errorString) in performUIUpdatesOnMain {
            
            self.presentLoadingAlert()
            
            if success {
                self.tableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Cannot update data")
            }
        }
    })
}
    
    
    // MARK: UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell") as! LocationsTableViewCell
        let information = StudentLocations[(indexPath as NSIndexPath).row]
        
        if let firstName = information.firstName, let lastName = information.lastName {
            cell.nameLabel?.text = firstName + " " + lastName
            cell.urlLabel?.text = information.mediaURL
        }
       
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let information = StudentLocations[(indexPath as NSIndexPath).row]
        if let mediaURL = information.mediaURL, let url = URL(string: mediaURL) {
            UIApplication.shared.open(url)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

// MARK: - LocationsTableViewController (Configure UI and Alert Controller)
private extension LocationsTableViewController {
    
    // MARK: Reachability Alert Controller
    private func presentAlert(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentLoadingAlert() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
}
