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
    var parsedLocations: [[String:AnyObject]] = []
    
    // MARK: Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        
        ParseClient.sharedInstance().getStudentLocations({(success, result, errorString) in performUIUpdatesOnMain {
            
            if success {
                self.reloadMapView()
            } else {
                self.presentAlert("Failed to download", "We've failed to find student's locations. Try again later", "OK")
            }
        }
    })
}
    
    func reloadMapView() {
        let locations = StudentLocations
        var annotations = [MKPointAnnotation]()
        for information in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            
            let lat = CLLocationDegrees(information.latitude )
            let long = CLLocationDegrees(information.longitude)

            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            let first = information.firstName
            let last = information.lastName
            let mediaURL = information.mediuaURL

            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
            
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
 
   
        
        // SAMPLE JSON DATA
//        let locations = hardCodedLocationData()
//        var annotations = [MKPointAnnotation]()
//        print("locations: \(locations)")
//
//
//        for dictionary in locations {
//
//            // Notice that the float values are being used to create CLLocationDegree values.
//            // This is a version of the Double type.
//            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
//            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
//
//            // The lat and long are used to create a CLLocationCoordinates2D instance.
//            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//
//            let first = dictionary["firstName"] as! String
//            let last = dictionary["lastName"] as! String
//            let mediaURL = dictionary["mediaURL"] as! String
//
//            // Here we create the annotation and set its coordiate, title, and subtitle properties
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = "\(first) \(last)"
//            annotation.subtitle = mediaURL
//
//            // Finally we place the annotation in an array of annotations.
//            annotations.append(annotation)
//
//        }
//
//        // When the array is complete, we add the annotations to the map.
//        self.mapView.addAnnotations(annotations)
        
    
    
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
    
    // MARK: Action
    
    @IBAction func pressLogout(_ sender: Any) {
        
        showIndicator()
        
        UdacityClient.sharedInstance().logoutSession(completionHandlerForLogout: {(success, sessionID, error) in performUIUpdatesOnMain {
            
            if success {
                print("Logout Success!")
                self.dismissIndicator()
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Cannot logout!")
                self.presentAlert("Cannot Logout", "Logout unsuccessful. Please try again.", "OK")
                self.dismissIndicator()
                return
            }
        }
    })
  }
    
    @IBAction func refreshPressed(_ sender: Any) {
        ParseClient.sharedInstance().getStudentLocations({(success, result, errorString) in performUIUpdatesOnMain {
            
            if success {
//                self.reloadMapView()
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
    
    
    // MARK: Reachability Alert Controller
    private func presentAlert(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}




