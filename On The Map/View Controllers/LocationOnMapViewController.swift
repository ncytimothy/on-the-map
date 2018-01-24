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
    var userLink: URL!
    var userLongitude: Double!
    var userLatitude: Double!
    
    
    // MARK: Outlet
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = userLocationString
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler:{(response, error) in
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
                }
            }
        })
    }
    @IBAction func pressFinish(_ sender: Any) {
        
        
        
        
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




