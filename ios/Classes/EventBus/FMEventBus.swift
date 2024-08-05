//
//  FMEventBus.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/8/5.
//

import UIKit

typealias FMEventBusListener = ([String: Any?]?) -> Void

class FMEventBus: NSObject {
    
    
    
    
    static private var listeners = [String: [FMEventBusListener]]()

    static func addListener(eventName: String, listener: @escaping FMEventBusListener) {
        listeners[eventName, default: []].append(listener)
    }

    static func removeListener(eventName: String, listener: @escaping FMEventBusListener) {
        listeners[eventName]?.removeAll { $0 as AnyObject === listener as AnyObject }
    }

    static func commit(eventName: String, data: [String: Any?]?) {
        listeners[eventName]?.forEach { $0(data) }
    }

}
