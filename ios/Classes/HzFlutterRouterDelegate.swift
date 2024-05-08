//
//  HzFlutterRouterDelegate.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import Flutter

public protocol HzFlutterRouterDelegate {

    var  methodChannel: FlutterMethodChannel? { get }
    func flutterPop()
    func flutterPopUntilName(routerName:String?)
    func flutterPopToRoot()
    
}


public extension HzFlutterRouterDelegate {
    
    func flutterPop() {
        methodChannel?.invokeMethod("pop", arguments: nil)
    }
    
    func flutterPopUntilName(routerName: String?) {
        var arguments = Dictionary<String, Any?>.init()
        arguments["routerName"] = routerName
        methodChannel?.invokeMethod("pop", arguments: arguments)
    }
    
    func flutterPopToRoot() {
        methodChannel?.invokeMethod("popToRoot", arguments: nil)
    }
    
    
}
