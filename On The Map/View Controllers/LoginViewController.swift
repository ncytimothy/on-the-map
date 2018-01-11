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
    let reachability = Reachability()!
   
    

    //MARK: Outlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isReachable()
    
    }
    
    // MARK: Network Reachability
    
    func isReachable() {
        reachability.whenReachable = { _ in
            print("I love Veronica")
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
    
    private func reachableAtLogin() -> Bool {
        reachability.whenReachable = {_ in
            return true
        }
        return false
    }

    private func presentUnreachableAlert() {
        let alert = UIAlertController(title: "No internet connection", message: "Please check your internet connection settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"Unreachable\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        userDidTapView(self)
        guard (reachableAtLogin() == true) else {
            print("Network Unreachable!")
            presentUnreachableAlert()
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
        print("userDidTapView")
        resignIfFirstResponser(emailTextfield)
        resignIfFirstResponser(passwordTextfield)

    }
    
//    private func completeLogin() {
//        debugLabel.text = ""
//        let controller = storyboard?.instantiateViewController(withIdentifier: <#T##String#>)
//    }

    
    
    
    
    func getSessionID() {
        
        
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"timothy2009good@gmail.com\", \"password\": \"Tim1018@\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
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

