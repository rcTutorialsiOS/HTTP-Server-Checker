//
//  HTTPServerChecker.swift
//  CheckConnectionServer
//
//  Created by Ricardo Champa on 26/05/2018.
//  Copyright © 2018 rchampa. All rights reserved.
//

import UIKit

class HTTPServerChecker {
    
    //use filter "_debug" in console
    var debug = false
    private var isUp = true
//    private var successful_connections : AtomicCounter;
    
    private var timer : Timer?
    private let myserver = "https://www.apple.com/retail?query="
    private let foreverUpServer = URL(string: "https://www.google.es")
    private var optionalHandler: ((_ error: Error?) -> Void)?
    private var session: URLSession
    
    static let sharedInstance = HTTPServerChecker()
    private init() {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 2
        session = URLSession(configuration: conf, delegate: nil, delegateQueue: OperationQueue())
//        successful_connections = AtomicCounter(value: 1)
    }
    
    func start(){
        timer = Timer.scheduledTimer(timeInterval: 3, target: self,   selector: (#selector(HTTPServerChecker.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func destroy(){
        timer?.invalidate()
    }
    
    @objc private func updateTimer() {
        pingToServer()
    }
    
    private func pingToServer() {
        
//        let x = self.successful_connections.incrementAndGet()
//        if x > 10 && x % 5 != 0 {
//            print("_degug: ac \(x)")
//            return
//        }
        
        let url = URL(string: myserver+UUID().uuidString)
        if self.debug {
            print("_degug: " + (url?.absoluteString)!)
        }
        
        let task = session.dataTask(with: url!) { (data, response, optional_error) in
            if let httpResponse = response as? HTTPURLResponse {
                
                //server switchs from DOWN to UP
                if !self.isUp {
                    self.isUp = true
//                    self.successful_connections.value = 0
                    print("_degug: TRANSITION UP")
                    if let handler = self.optionalHandler {
                        DispatchQueue.main.async{
                            handler(nil)
                        }
                    }
                }
                
                
                if self.debug {
                    print("_degug: myserver \(httpResponse.statusCode)")
                }
                
                return
                
            }
            if let error = optional_error {
                
                //server switchs from UP to DOWN
                if self.isUp {
                    self.isUp = false
                    print("_degug: TRANSITION DOWN")
                    if let handler = self.optionalHandler {
                        DispatchQueue.main.async{
                            handler(error)
                        }
                    }
                }
                
                if self.debug {
                    print("_degug: myserver \(error.localizedDescription)")
                }
            }
        }
       
        task.resume()
    }
    
    func setCallback(handler: @escaping (_ error:Error?) -> Void) {
        self.optionalHandler = handler
    }
    
    //is not tested, could fail
    func isMyServerUp() -> Bool {
        return self.isUp
    }
    
}
