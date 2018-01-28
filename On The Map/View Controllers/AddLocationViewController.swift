//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Timothy Ng on 1/16/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var cancelBarItem: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var locationTextfield: UITextField!
    
    @IBOutlet weak var websiteTextfield: UITextField!
    
    // MARK: Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.isHidden = true
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = cancelBarItem
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Action
    
    @IBAction func pressCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponder(locationTextfield)
        resignIfFirstResponder(websiteTextfield)
    }
    
  
    @IBAction func pressFindLocation(_ sender: Any) {
        
        let locationOnMapVC = storyboard?.instantiateViewController(withIdentifier: "LocationOnMap") as! LocationOnMapViewController
        
        
        if locationTextfield.text!.isEmpty {
            presentAlert("Location Not Found", "Must enter a location", "Dismiss")
        } else {
           locationOnMapVC.userLocationString = locationTextfield.text
        }
        
        if websiteTextfield.text!.isEmpty {
            presentAlert("Location Not Found", "Invalid Link", "Dismiss")
        } else {
            if let websiteString = websiteTextfield?.text, let websiteURL = URL(string: websiteString) {
                if websiteURL.scheme != "https" {
                    presentAlert("Invalid Link", "Links must be in \"https://\"", "Dismiss")
                } else {
                    locationOnMapVC.userMediaURL = websiteString
                }
            }
        }
        
        self.navigationController?.pushViewController(locationOnMapVC, animated: true)
    }
}

// MARK: - AddLocationViewController (UITextFieldDelegate)
extension AddLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
}

// MARK: - AddLocationsViewController (Configure UI and Alert Controller)
private extension AddLocationViewController {
    
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
