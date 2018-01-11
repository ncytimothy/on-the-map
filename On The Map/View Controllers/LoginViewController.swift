//
//  LoginViewController.swift
//  On The Map
//
//  Created by Timothy Ng on 1/6/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var reachability = Reachability()!
   
    // MARK: Outlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugLabel.text = ""
        isReachable()
    
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        
        userDidTapView(self)
    
        guard (reachability.connection != .none) else {
            print("No internet connection!")
            return
        }
        
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty {
            debugLabel.text = "Username or Password Empty."
            let alert = UIAlertController(title: "Whoops!", message: "Empty Email or Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .default, handler: { _ in NSLog("The \"Dismiss\" alert occured.")}))
           self.present(alert, animated: true, completion: nil)
            
        } else {
            setUIEnabled(false)
        
            OTMClient.sharedInstance().authenticateWithViewController(self, emailTextfield.text!, passwordTextfield.text!) { (success, errorString) in
                
                if success {
                    print("Login Success!")
                }
            
            
        }
    }
        
       
}
    
    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponser(emailTextfield)
        resignIfFirstResponser(passwordTextfield)

    }
    
//    private func completeLogin() {
//        debugLabel.text = ""
//        let controller = storyboard?.instantiateViewController(withIdentifier: <#T##String#>)
//    }

}
    
// MARK: - LoginViewController (UITextFieldDelegate)
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resignIfFirstResponser(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
}

// MARK: - LoginViewController (Configure UI)
private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        emailTextfield.isEnabled = enabled
        passwordTextfield.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugLabel.text = ""
        debugLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
        
    }
}

// MARK: - LoginViewController (Network Reachability)
private extension LoginViewController {
    
    // MARK: Network Reachability
    
    // MARK: Check reachability at viewWillAppear
    func isReachable() {
     
        reachability.whenReachable = { _ in
           print("Network reachable")
        }
        
        reachability.whenUnreachable = { _ in
            self.presentUnreachableAlert()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    // MARK: Check reachability at Login
//    private func reachableAtLogin() -> Bool {
//        reachability.whenReachable = { _ in
//            print("Network reachable")
//        }
//
//        reachability.whenUnreachable = { _ in
//            self.presentUnreachableAlert()
//        }
//
//        do {
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
//    }
    
    // MARK: Reachability Alert Controller
    private func presentUnreachableAlert() {
        let alert = UIAlertController(title: "No internet connection", message: "Please check your internet connection settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"Unreachable\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

