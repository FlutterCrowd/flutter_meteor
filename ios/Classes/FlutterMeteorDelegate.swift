//
//  HzRouterDelegate.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import Flutter


public let FMRouterMethodChannelName: String = "itbox.meteor.channel"
public let FMPushNamedMethod: String = "pushNamed";
public let FMPushReplacementNamedMethod: String = "pushReplacementNamed";
public let FMPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil";
public let FMPopMethod: String = "pop";
public let FMPopUntilMethod: String = "popUntil";
public let FMPopToRootMethod: String = "popToRoot";
public let FMDismissMethod: String = "dismiss";
public let FMMultiEngineEventCallMethod: String = "cn.itbox.multiEnginEvent";


public typealias FlutterMeteorRouterCallBack = (_ response: Any?) -> Void

public struct FMMeteorOptions {
    public var withNewEngine: Bool = false
    public var newEngineOpaque: Bool = false
    public var present: Bool = false
    public var arguments: Dictionary<String, Any>?
    public var callBack: FlutterMeteorRouterCallBack?
    public init(arguments: Dictionary<String, Any>? = nil, callBack: FlutterMeteorRouterCallBack? = nil) {
        self.arguments = arguments
        self.callBack = callBack
    }
}

public protocol FlutterMeteorCustomDelegate {
        
    func push(routeName: String, options: FMMeteorOptions?)
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

     var flutterNavigator: FMFlutterNavigator {
        get {
            return FlutterMeteor.flutterNavigator
        }
    }

     func handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
         
         var options = FMMeteorOptions.init()
         var routeName: String = ""
         var untilRouteName: String?
         var methodArguments: Dictionary<String, Any>?
         if (call.arguments is Dictionary<String, Any>) {
             methodArguments = call.arguments as? Dictionary<String, Any>
             options.newEngineOpaque = (methodArguments!["newEngineOpaque"] != nil) && methodArguments!["newEngineOpaque"] as! Bool == true
             options.withNewEngine = methodArguments!["withNewEngine"] as? Bool ?? false
             options.present = methodArguments!["present"] as? Bool ?? false
             routeName = methodArguments!["routeName"] as? String ?? ""
             untilRouteName = methodArguments!["untilRouteName"] as? String
         }

         options.callBack = {response in
             result(response)
         }

         switch call.method {
             case FMPushNamedMethod:
                 options.arguments = getPushAguments(call)
                 if(options.present) {
                     self.present(routeName: routeName, options: options)
                 } else {
                     self.push(routeName: routeName, options: options)
                 }
                 break
             case FMPopMethod:
                 options.arguments = getPopResult(call)
                 self.pop(options: options)
                 break
             case FMPushReplacementNamedMethod:
                 options.arguments = getPushAguments(call)
                 self.pushToReplacement(routeName: routeName, options: options)
                 break
             case FMPushNamedAndRemoveUntilMethod:
                 options.arguments = getPushAguments(call)
                 self.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
                 break
             case FMPopUntilMethod:
                 options.arguments = getPopResult(call)
                 self.popUntil(untilRouteName: untilRouteName ?? routeName, options: options)
                 break
             case FMPopToRootMethod:
                 options.arguments = getPopResult(call)
                 self.popToRoot(options: options)
                 break
             case FMDismissMethod:
                 options.arguments = getPopResult(call)
                 self.dismiss(options: options)
                 break
             case FMMultiEngineEventCallMethod:
                 if (call.arguments is Dictionary<String, Any>) {
                     let methodArguments: Dictionary<String, Any> = call.arguments as! Dictionary<String, Any>
                     let eventName = methodArguments["eventName"] as? String ?? ""
                     let arguments = methodArguments["arguments"]
                     FlutterMeteor.sendEvent(eventName: eventName, arguments: arguments)
                 }
                 
                 break
             case FMRouteExists:
                 FlutterMeteorRouter.routeExists(routeName: routeName, result: result)
                 break
             case FMIsRoot:
                 FlutterMeteorRouter.isRoot(routeName: routeName, result: result)
                 break
             case FMRootRouteName:
                 FlutterMeteorRouter.rootRouteName(result: result)
                 break
             case FMTopRouteName:
                 FlutterMeteorRouter.topRouteName(result: result)
                 break
             case FMRouteNameStack:
                 FlutterMeteorRouter.routeNameStack(result: result)
                 break
             default:
               result(FlutterMethodNotImplemented)
             }
     }
     
     
     func present(routeName: String, options: FMMeteorOptions?) {
         FMNavigator.present(routeName: routeName, options: options)
     }
     
      func push(routeName: String, options: FMMeteorOptions?) {
          print("Call push untilRouteName:\(routeName)")
          FMNavigator.push(routeName: routeName, options: options)
     }
     
      func popUntil(untilRouteName: String, options: FMMeteorOptions?) {
          print("Call popUntil untilRouteName:\(untilRouteName)")
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
                 if (methodArguments["arguments"] != nil && methodArguments["arguments"] is Dictionary<String, Any>) {
                     arguments = methodArguments["arguments"] as! [String : Any]
                 } else {
                     print("Invalid arguments type")
                 }
             } else {
                 print("Invalid arguments type")
             }
             return arguments
         } else {
             return nil
         }
     }
}
