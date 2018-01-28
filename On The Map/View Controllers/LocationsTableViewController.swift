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
    
    // MARK: Properties
    let activityIndicator = UIActivityIndicatorView()
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    // MARK: Outlet
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableView()
    }
    
  
    
    // MARK: Actions
    @IBAction func pressRefresh(_ sender: Any) {
        self.presentLoadingAlert()
        updateTableView()
    }
    
    @IBAction func pressAdd(_ sender: Any) {
        if UserLocation.objectID != nil {
            presentAlertWithCancel("", "User " + "\"\(UserLocation.firstName!)" + " " + "\(UserLocation.lastName!)\"" + " Has Already Posted a Student Location. Would You Like to Overwrite Their Location?" , "Overwrite")
        }
        
        let addLocationVC = storyboard?.instantiateViewController(withIdentifier: "addLocationVC") as! AddLocationViewController
        self.navigationController?.pushViewController(addLocationVC, animated: true)
    }
    
    @IBAction func pressLogout(_ sender: Any) {
        
        showIndicator()
        UdacityClient.sharedInstance().logoutSession(completionHandlerForLogout: {(success, error) in performUIUpdatesOnMain {
            
            if success {
                print("Logout Success!")
                self.dismissIndicator()
                
            } else {
                print("Cannot logout!")
                self.presentAlert("Cannot Logout", "Logout unsuccessful. Please try again.", "OK")
                self.dismissIndicator()
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    func updateTableView() {
        ParseClient.sharedInstance().getStudentLocations({(success, result, errorString) in performUIUpdatesOnMain {
            
            if success {
                self.tableView.reloadData()
                self.alert.dismiss(animated: true, completion: nil)
            }
            
            if let error = errorString {
                self.alert.dismiss(animated: true, completion: {() in
                    self.presentAlert("Failed to download", "We've failed to find student's locations. Try again later", "OK")
                    print("Cannot update data")
                })
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
            if url.scheme != "https" {
                presentAlert("", "Invalid URL", "Dismiss")
            } else { UIApplication.shared.open(url) }
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

// MARK: - LocationsTableViewController (Configure UI and Alert Controller)
private extension LocationsTableViewController {
    
    // MARK: Activity Indicator
    func showIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func dismissIndicator() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: Alert Controller
    private func presentAlert(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Alert Controller with Cancel
    private func presentAlertWithCancel(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            let addLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "addLocationVC") as! AddLocationViewController
            self.navigationController?.pushViewController(addLocationVC, animated: true)
            NSLog("The \"\(title)\" alert occured.")
        }))
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        })
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    private func presentLoadingAlert() {
        
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating()
            
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)
        
    }
    
}
