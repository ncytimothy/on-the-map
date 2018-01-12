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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    
    
    
    // MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isReachable()
    
    }
    
    // MARK: Actions
    @IBAction func signUpPressed(_ sender: Any) {
        
        if let link = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated") {
            UIApplication.shared.open(link)
        }
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        userDidTapView(self)
        
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty {
            presentAlert(UdacityClient.Alert.EmptyFieldTitle, UdacityClient.Alert.EmptyFieldMessage, UdacityClient.Alert.Dismiss)
            
        } else {
            setUIEnabled(false)
            
            /* Is internet connection available? */
            guard (reachability.connection != .none) else {
                print("No internet")
                presentAlert(UdacityClient.Alert.NoInternetTitle, UdacityClient.Alert.NoInternetMessage, UdacityClient.Alert.OK)
                return
            }
            
            UdacityClient.sharedInstance().authenticateWithViewController(self, emailTextfield.text!, passwordTextfield.text!) { (success, errorString) in performUIUpdatesOnMain {
            
                    if success {
                        print("Login Success!")
                    } else {
                        self.presentAlert(UdacityClient.Alert.InvalidTitle, UdacityClient.Alert.InvalidMessage, UdacityClient.Alert.TryAgain)
                        self.loginButton.alpha = 1.0
                    }
                }
            }
        }
}
    
    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponser(emailTextfield)
        resignIfFirstResponser(passwordTextfield)

    }
    
//    private func completeLogin() {
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
            self.presentAlert(UdacityClient.Alert.NoInternetTitle, UdacityClient.Alert.NoInternetMessage, UdacityClient.Alert.OK)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    // MARK: Reachability Alert Controller
    private func presentAlert(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        setUIEnabled(true)
    }
}

// MARK: - LoginViewController (Invalid Login Credentials Alert Controller)
private extension LoginViewController {
    
  
    
}


