//
//  LocationOnMapViewController.swift
//  On The Map
//
//  Created by Timothy Ng on 1/20/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit
import MapKit

class LocationOnMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
    
    var userLocationString: String!
    var userMediaURL: String!
    var userLongitude: Double!
    var userLatitude: Double!
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
   
    
    
    // MARK: Outlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = userLocationString
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler:{(response, error) in performUIUpdatesOnMain {
            
            if let error = error {
                self.finishButton.isEnabled = false
                self.finishButton.alpha = 0.5
                self.presentAlert("Cannot Find Location", "Cannot find location, please try again.", "OK")
            }
            
            self.presentLoadingAlert()
            
            if let mapItems = response?.mapItems {
                if let mapItem = mapItems.first {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    self.userLongitude = mapItem.placemark.coordinate.longitude
                    self.userLatitude = mapItem.placemark.coordinate.latitude
                    annotation.title = mapItem.name
                    self.mapView.addAnnotation(annotation)
                    let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
                    self.mapView.region = region
                    self.alert.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    })
}
    
    // MARK: Actions
    
    @IBAction func pressFinish(_ sender: Any) {
        
        print("UserLocation.objectID: \(UserLocation.objectID)")
        
        if UserLocation.objectID == nil {
            ParseClient.sharedInstance().postStudentLocation(userLocationString, userMediaURL, userLatitude, userLongitude, {(success, error) in performUIUpdatesOnMain {
                
                if success {
                        print("Post Location Success!")
                        self.navigationController?.popToRootViewController(animated: true)
                } else {
                        print("Post Location Unsuccessful.")
                        self.presentAlert("Cannot Post Location", "Post location unsuccessful", "Dismiss")
                }
            }
        })
        } else {
            
            ParseClient.sharedInstance().putStudentLocation(userLocationString, userMediaURL, userLatitude, userLongitude, {(success, error) in performUIUpdatesOnMain {
                    if success {
                        print("Put Location Success!")
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.presentAlert("Cannot Update Location", "Update location unsuccessful, please try again.", "Dismiss")
                    }
                }
            })
            
        }
        
        
    }
    
    
    
    
    // MARK: MKMapViewDelegate Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}

private extension LocationOnMapViewController {
    
    // MARK: Reachability Alert Controller
    private func presentAlert(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentLoadingAlert() {
      
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
}




