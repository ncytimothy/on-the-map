//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Timothy Ng on 1/16/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var cancelBarItem: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = cancelBarItem
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func pressCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
}
