//
//  MeteorNavigatorObserver.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/10/24.
//

import Foundation

class MeteorNavigatorObserver: NSObject {

    // 通用的日志输出方法，减少重复代码
    private static func logRouteAction(action: String, routeName: String) {
        MeteorLog.debug("RouteAction: \(action), RouteName: \(routeName)")
    }
    
    // Push 操作监听
    static func didPush(routeName: String, fromRouteName: String?) {
//        logRouteAction(action: "didPush", routeName: routeName)
        
//        let message: [String: Any?] = [
//            "event": "didPush",
//            "route": routeName,
//            "previousRoute": fromRouteName,
//        ]
//        for provider in MeteorEngineManager.allEngineChannelProvider() {
//            provider.observerChannel.sendMessage(message)
//        }
    }
    
    // Pop 操作监听
    static func didPop(routeName: String, fromRouteName: String?) {
//        logRouteAction(action: "didPop", routeName: routeName)
//        let message: [String: Any?] = [
//            "event": "didPop",
//            "route": routeName,
//            "previousRoute": fromRouteName,
//        ]
//        for provider in MeteorEngineManager.allEngineChannelProvider() {
//            provider.observerChannel.sendMessage(message)
//        }
    }
    
    // Remove 操作监听
    static func didRemove(routeName: String, fromRouteName: String) {
//        logRouteAction(action: "didRemove", routeName: routeName)
//        let message: [String: Any?] = [
//            "event": "didRemove",
//            "route": routeName,
//            "previousRoute": fromRouteName,
//        ]
//        for provider in MeteorEngineManager.allEngineChannelProvider() {
//            provider.observerChannel.sendMessage(message)
//        }
    }
    
    static func didRplace(routeName: String, fromRouteName: String) {
//        logRouteAction(action: "didRplace", routeName: routeName)
//        let message: [String: Any?] = [
//            "event": "didRplace",
//            "route": routeName,
//            "previousRoute": fromRouteName,
//        ]
//        for provider in MeteorEngineManager.allEngineChannelProvider() {
//            provider.observerChannel.sendMessage(message)
//        }
    }
    
}

