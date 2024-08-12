//
//  FMEventBus.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/8/5.
//

import UIKit
import Flutter

typealias MeteorEventBusListener = ([String: Any?]?) -> Void

class MeteorEventBus: NSObject {
      

    static private var listeners = [String: [MeteorEventBusListener]]()

    
    static func addListener(eventName: String, listener: @escaping MeteorEventBusListener) {
        listeners[eventName, default: []].append(listener)
    }

    static func removeListener(eventName: String, listener: @escaping MeteorEventBusListener) {
        listeners[eventName]?.removeAll { $0 as AnyObject === listener as AnyObject }
    }

    static func commit(eventName: String, data: [String: Any?]?) {
        
        // 通知原生的 listeners
        listeners[eventName]?.forEach { $0(data) }
        
        // 遍历多引擎Channel
        var message = [String: Any?]()
        message["eventName"] = eventName
        message["data"] = data
        
        FlutterMeteorPlugin.channelHolderList.allObjects.forEach {  provider in
            provider.eventBusChannel.sendMessage(message)
        }
    }

    // 处理从flutter端收到的消息
    static func receiveMessageFromFlutter(message: Any?) {
        if let map = message as? [String: Any?]? {
            if let eventName = map?["eventName"] as? String {
                commit(eventName: eventName, data: map?["data"] as? [String : Any?])
            }
        }
    }
}
