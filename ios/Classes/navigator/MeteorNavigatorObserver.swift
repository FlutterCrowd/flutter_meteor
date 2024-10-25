//
//  MeteorNavigatorObserver.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/10/24.
//

import UIKit

class MeteorNavigatorObserver: NSObject {

    // 通用的日志输出方法，减少重复代码
    private static func logRouteAction(action: String, routeName: String) {
        print("RouteAction: \(action), RouteName: \(routeName)")
    }
    
    // Push 操作监听
    static func didPush(routeName: String) {
        logRouteAction(action: "didPush", routeName: routeName)
    }
    
    // Pop 操作监听
    static func didPop(routeName: String) {
        logRouteAction(action: "didPop", routeName: routeName)
    }
    
    // Remove 操作监听
    static func didRemove(routeName: String) {
        logRouteAction(action: "didRemove", routeName: routeName)
    }
}

