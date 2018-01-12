//
//  MapViewController.swift
//  On The Map
//
//  Created by Timothy Ng on 1/12/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController {
    
    // MARK: Properties
    let activityIndicator = UIActivityIndicatorView()
    
    @IBAction func pressLogout(_ sender: Any) {
        
        showIndicator()
        
        UdacityClient.sharedInstance().logoutSession(completionHandlerForLogout: {(success, sessionID, error) in performUIUpdatesOnMain {
            
            if success {
                print("Logout Success!")
                self.dismissIndicator()
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Cannot logout!")
            }
            
            }
        })
        
    }
}

// MARK: - LoginViewController (UIActivityIndicator)
private extension MapViewController {
    
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
    
}

