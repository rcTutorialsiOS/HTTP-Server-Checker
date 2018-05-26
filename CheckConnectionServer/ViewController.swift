//
//  ViewController.swift
//  CheckConnectionServer
//
//  Created by Ricardo Champa on 26/05/2018.
//  Copyright © 2018 rchampa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ledView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ledView.backgroundColor = UIColor.green
        
        HTTPServerChecker.sharedInstance.setCallback { [weak self] (optional_error : Error?) in
         
            if let error = optional_error {
                print("server down: \(error.localizedDescription)")
//                self?.showAlert(message: "server down")
                self?.ledView.backgroundColor = UIColor.red
            }
            else{
//                self?.showAlert(message: "server up")
                print("server up: ")
                self?.ledView.backgroundColor = UIColor.green
            }
        }
        
    }

    func showAlert(message:String){
        let alert = UIAlertController(title: "Server Checker", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}

