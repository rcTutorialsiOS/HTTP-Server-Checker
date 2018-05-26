//
//  HTTPServerChecker.swift
//  CheckConnectionServer
//
//  Created by Ricardo Champa on 26/05/2018.
//  Copyright © 2018 rchampa. All rights reserved.
//

import UIKit

class HTTPServerChecker {
    
    private var isUp : Bool = true
    
    private var timer : Timer?
    private let myserver = URL(string: "https://www.apple.com")
    private let foreverUpServer = URL(string: "https://www.google.es")
    private var optionalHandler: (() -> Void)?
    
    static let sharedInstance = HTTPServerChecker()
    private init() {}
    
    func start(){
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self,   selector: (#selector(HTTPServerChecker.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func destroy(){
        timer?.invalidate()
    }
    
    @objc private func updateTimer() {
        pingToServer()
    }
    
    private func pingToServer() {
        
        let task = URLSession.shared.dataTask(with: myserver!) {(data, response, optional_error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("_degug: myserver \(httpResponse.statusCode)")
                if let handler = self.optionalHandler {
                    handler()
                }
            }
            if let error = optional_error {
                print("_degug: myserver \(error.localizedDescription)")
            }
        }
       
        task.resume()
    }
    
    func setCallback(handler: @escaping () -> Void) {
        self.optionalHandler = handler
    }
    
    //is not tested, could fail 
    func isMyServerUp() -> Bool {
        return self.isUp
    }
    
}
