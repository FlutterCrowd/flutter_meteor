//
//  HzRouterDelegate.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import Flutter


public let FmRouterMethodChannelName = "itbox.meteor.channel"
public let fmPushNamedMethod: String = "pushNamed";
public let fmPushReplacementNamedMethod: String = "pushReplacementNamed";
public let fmPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil";
public let fmPopMethod: String = "pop";
public let fmPopUntilMethod: String = "popUntil";
public let fmPopToRootMethod: String = "popToRoot";
public let fmDismissMethod: String = "dismiss";


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

//     func handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//         FMMethodChannel.handleFlutterMethodCall(call, result: result)
//     }
//    
     var customRouterDelegate: (any FlutterMeteorDelegate)? {
         return FMNavigator.customRouterDelegate
       }
         
     var flutterNavigator: FMFlutterNavigator {
        get {
            return FMNavigator.flutterNavigator
        }
    }
     
     func  handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
         
         var options = FMMeteorOptions.init()
         var routeName: String = ""
         var untilRouteName: String?
         if (call.arguments is Dictionary<String, Any>) {
             let arguments: Dictionary<String, Any> = call.arguments as! Dictionary<String, Any>
             options.newEngineOpaque = (arguments["newEngineOpaque"] != nil) && arguments["newEngineOpaque"] as! Bool == true
             options.withNewEngine = arguments["withNewEngine"] as? Bool ?? false
             routeName = arguments["routeName"] as? String ?? ""
             untilRouteName = arguments["routeName"] as? String
         }

         options.callBack = {response in
             result(response)
         }

         switch call.method {
         case fmPushNamedMethod:
             options.arguments = getPushAguments(call)
             self.push(routeName: routeName, options: options)
             break
         case fmPopMethod:
             options.arguments = getPopResult(call)
             self.pop(options: options)
             break
         case fmPushReplacementNamedMethod:
             options.arguments = getPushAguments(call)
             self.pushToReplacement(routeName: routeName, options: options)
             break
         case fmPushNamedAndRemoveUntilMethod:
             options.arguments = getPushAguments(call)
             self.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
             break
         case fmPopUntilMethod:
             options.arguments = getPopResult(call)
             self.popUntil(untilRouteName: untilRouteName ?? routeName, options: options)
             break
         case fmPopToRootMethod:
             options.arguments = getPopResult(call)
             self.popToRoot(options: options)
             break
         case fmDismissMethod:
             options.arguments = getPopResult(call)
             self.dismiss(options: options)
             break
         default:
           result(FlutterMethodNotImplemented)
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
     
     private func  getPopResult(_ call: FlutterMethodCall) -> Dictionary<String, Any>? {
     
         if (call.arguments != nil) {
             var arguments = Dictionary<String, Any>.init();
             arguments["result"] = call.arguments
             return arguments
         } else {
             return nil
         }
     }
     
     private func  getPushAguments(_ call: FlutterMethodCall) -> Dictionary<String, Any>? {
         if (call.arguments != nil) {
             var arguments = Dictionary<String, Any>.init();
             
             if (call.arguments is Dictionary<String, Any>) {
                 let methodArguments :Dictionary<String, Any>  = call.arguments as! Dictionary<String, Any>;
                 if (methodArguments["arguments"] != nil) {
                     arguments = methodArguments
                 } else {
                     arguments["arguments"] = methodArguments
                 }
             } else {
                 arguments["arguments"] = call.arguments
             }
             return arguments
         } else {
             return nil
         }
     }
}
