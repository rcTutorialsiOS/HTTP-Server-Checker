//
//  ViewController.swift
//  CheckConnectionServer
//
//  Created by Ricardo Champa on 26/05/2018.
//  Copyright © 2018 rchampa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        HTTPServerChecker.sharedInstance.setCallback {
            
        }
        
    }

    func showAlert(){
        let alert = UIAlertController(title: "Server Checker", message: "Your server is up!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}

