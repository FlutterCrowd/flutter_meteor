//
//  HzRouterDelegate.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import Flutter


public typealias FlutterMeteorRouterCallBack = (_ response: Any?) -> Void

public struct FMMeteorOptions {
    public var withNewEngine: Bool = false
    public var newEngineOpaque: Bool = false
    public var arguments: Dictionary<String, Any>?
    public var callBack: FlutterMeteorRouterCallBack?
    public init(arguments: Dictionary<String, Any>? = nil, callBack: FlutterMeteorRouterCallBack? = nil) {
        self.arguments = arguments
        self.callBack = callBack
    }
}

public protocol FlutterMeteorDelegate {
        
    func present(routeName: String, options: FMMeteorOptions?)
    
    func push(routeName: String, options: FMMeteorOptions?)
     
    func pop(options: FMMeteorOptions?)
    
    func popUntil(untilRouteName: String, options: FMMeteorOptions?)
     
    func popToRoot(options: FMMeteorOptions?)
     
    func dismiss(options: FMMeteorOptions?)
    
    /// push 到指定页面并替换当前页面
    ///
    /// @parma toPage 要跳转的页面，
    func pushToReplacement(routeName: String, options: FMMeteorOptions?)

    /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
    ///
    /// @parma routeName 要跳转的页面，
    /// @parma untilRouteName 移除截止页面，默认根页面，
    func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: FMMeteorOptions?)
}


 public extension FlutterMeteorDelegate {

     func handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
         FMNavigator.handleFlutterMethodCall(call, result: result)
     }
    
     var customRouterDelegate: (any FlutterMeteorDelegate)? {
         return FMNavigator.customRouterDelegate
       }
         
     var flutterNavigator: FMFlutterNavigator {
        get {
            return FMNavigator.mainEngineFlutterNaviagtor!
        }
    }
     
     func present(routeName: String, options: FMMeteorOptions?) {
         FMNavigator.present(routeName: routeName, options: options)
    }
    
     func push(routeName: String, options: FMMeteorOptions?) {
         FMNavigator.push(routeName: routeName, options: options)
    }
    
     func popUntil(untilRouteName: String, options: FMMeteorOptions?) {
         FMNavigator.popUntil(untilRouteName: untilRouteName, options: options)
    }
    
     func pushToReplacement(routeName: String, options: FMMeteorOptions?) {
         FMNavigator.pushToReplacement(routeName: routeName, options: options)
    }
    
     func pop(options: FMMeteorOptions?) {
         FMNavigator.pop(options: options)
    }
    
     func popToRoot(options: FMMeteorOptions?) {
         FMNavigator.popToRoot(options: options)
    }
    
     func dismiss(options: FMMeteorOptions?) {
         FMNavigator.dismiss(options: options)
    }
    
     func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: FMMeteorOptions?) {
         FMNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
    }
}
