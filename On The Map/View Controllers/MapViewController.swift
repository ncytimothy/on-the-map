//
//  MapViewController.swift
//  On The Map
//
//  Created by Timothy Ng on 1/12/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
   
    
    // MARK: Properties
    let activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UdacityClient.sharedInstance().getPublicUserData(completionHandlerForPublicUserData: {(success, error) in
            
                if success {
                    print("Get User Public Data Success!")
                }
            })
        
        ParseClient.sharedInstance().getUserLocation({(success, result, errorString) in
        
            if success {
                print("Success in Getting User Location")
            } else {
                print("User Location not found!")
            }
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentLoadingAlert()
        
        ParseClient.sharedInstance().getStudentLocations({(success, result, errorString) in performUIUpdatesOnMain {
            
            if success {
                self.reloadMapView()
                self.alert.dismiss(animated: true, completion: nil)
            }
            
            if let error = errorString {
                self.dismiss(animated: true, completion: {() in
                    self.presentAlert("Failed to download", "We've failed to find student's locations. Try again later", "OK")
                    print("Cannot update data")
                })
            }
        }
    })
}
    
    

    
    func reloadMapView() {
    
        print("reloadMapView called")
        
        if !annotations.isEmpty {
            mapView.removeAnnotations(annotations)
            annotations.removeAll()
        }
        
        let locations = StudentLocations
        
        for information in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            
            if let latitude = information.latitude, let longitude = information.longitude {
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = information.firstName!
                let last = information.lastName!
                let mediaURL = information.mediaURL!
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
                
            }
            
        }
        
        // When the array is complete, we add the annotations to the map.
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(self.annotations)
        }
    }

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseId = "pin"
    
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight)
            }
            else {
                pinView!.annotation = annotation
            }
            return pinView
    }
    
   
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
 
    
    // MARK: Actions
    
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
    
    @IBAction func addPressed(_ sender: Any) {
        
        print("UserLocation.objectID: \(UserLocation.objectID)")
        
        if UserLocation.objectID != nil {
            presentAlertWithCancel("", "User " + "\"\(UserLocation.firstName!)" + " " + "\(UserLocation.lastName!)\"" + " Has Already Posted a Student Location. Would You Like to Overwrite Their Location?" , "Overwrite")
        }
        
        let addLocationVC = storyboard?.instantiateViewController(withIdentifier: "addLocationVC") as! AddLocationViewController
        self.navigationController?.pushViewController(addLocationVC, animated: true)
        
    }
    
    
    
    @IBAction func refreshPressed(_ sender: Any) {
        print("refreshPressed!")
        
        presentLoadingAlert()
        
        ParseClient.sharedInstance().getStudentLocations({(success, result, errorString) in performUIUpdatesOnMain {
            
            if success {
                self.reloadMapView()
                self.dismiss(animated: true, completion: nil)
            } else {
                self.presentAlert("Failed to download", "We've failed to find student's locations. Try again later", "OK")
                }
            }
        })
    }
}

// MARK: - MapViewController (UIActivityIndicator)
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

// MARK: - MapViewController (Configure UI and Alert Controller)
private extension MapViewController {
    
    
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
        loadingIndicator.startAnimating();
    
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
}




