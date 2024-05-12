//
//  HzRouterDelegate.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import Flutter


public typealias HzRouterCallBack = (_ response: Any?) -> Void

public struct HzRouterOptions {
    public var withNewEngine: Bool = false
    public var newEngineOpaque: Bool = false
    public var arguments: Dictionary<String, Any>?
    public var callBack: HzRouterCallBack?
    public init(arguments: Dictionary<String, Any>? = nil, callBack: HzRouterCallBack? = nil) {
        self.arguments = arguments
        self.callBack = callBack
    }
}

public protocol HzRouterDelegate {
        
    func present(routeName: String, options: HzRouterOptions?)
    
    func push(routeName: String, options: HzRouterOptions?)
     
    func pop(options: HzRouterOptions?)
    
    func popUntil(untilRouteName: String, options: HzRouterOptions?)
     
    func popToRoot(options: HzRouterOptions?)
     
    func dismiss(options: HzRouterOptions?)
    
    /// push 到指定页面并替换当前页面
    ///
    /// @parma toPage 要跳转的页面，
    func pushToReplacement(routeName: String, options: HzRouterOptions?)

    /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
    ///
    /// @parma routeName 要跳转的页面，
    /// @parma untilRouteName 移除截止页面，默认根页面，
    func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: HzRouterOptions?)
}


 public extension HzRouterDelegate {

     func handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
         HzNavigator.handleFlutterMethodCall(call, result: result)
     }
    
     var customRouterDelegate: (any HzRouterDelegate)? {
         return HzNavigator.customRouterDelegate
       }
         
     var flutterNavigator: HzFlutterNavigator {
        get {
            return HzNavigator.flutterNavigator
        }
    }
     
     func present(routeName: String, options: HzRouterOptions?) {
         HzNavigator.present(routeName: routeName, options: options)
    }
    
     func push(routeName: String, options: HzRouterOptions?) {
         HzNavigator.push(routeName: routeName, options: options)
    }
    
     func popUntil(untilRouteName: String, options: HzRouterOptions?) {
         HzNavigator.popUntil(untilRouteName: untilRouteName, options: options)
    }
    
     func pushToReplacement(routeName: String, options: HzRouterOptions?) {
         HzNavigator.pushToReplacement(routeName: routeName, options: options)
    }
    
     func pop(options: HzRouterOptions?) {
         HzNavigator.pop(options: options)
    }
    
     func popToRoot(options: HzRouterOptions?) {
         HzNavigator.popToRoot(options: options)
    }
    
     func dismiss(options: HzRouterOptions?) {
         HzNavigator.dismiss(options: options)
    }
    
     func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: HzRouterOptions?) {
         HzNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
    }
}
