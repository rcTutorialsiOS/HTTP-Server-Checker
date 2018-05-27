//
//  AtomicCounter.swift
//  CheckConnectionServer
//
//  Created by Ricardo Champa on 27/05/2018.
//  Copyright © 2018 rchampa. All rights reserved.
//

import UIKit

class AtomicCounter {
    private let lock = DispatchSemaphore(value: 1)
    private var _value: Int
    
    public init(value initialValue: Int = 0) {
        _value = initialValue
    }
    
    public var value: Int {
        get {
            lock.wait()
            defer { lock.signal() }
            return _value
        }
        set {
            lock.wait()
            defer { lock.signal() }
            _value = newValue
        }
    }
    
    public func decrementAndGet() -> Int {
        lock.wait()
        defer { lock.signal() }
        _value -= 1
        return _value
    }
    
    public func incrementAndGet() -> Int {
        lock.wait()
        defer { lock.signal() }
        _value += 1
        return _value
    }
}
