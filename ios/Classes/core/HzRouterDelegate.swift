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
    
    var customRouterDelegate: (any HzCustomRouterDelegate)? { get  }
    
    func present(routeName: String, options: HzRouterOptions?);
    
    func push(routeName: String, options: HzRouterOptions?);
     
    func pop(options: HzRouterOptions?);
    
    func popUntil(untilRouteName: String, options: HzRouterOptions?);
     
    func popToRoot(options: HzRouterOptions?);
     
    func dismiss(options: HzRouterOptions?);
    
    /// push 到指定页面并替换当前页面
    ///
    /// @parma toPage 要跳转的页面，
    func pushToReplacement(routeName: String, options: HzRouterOptions?);

    /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
    ///
    /// @parma routeName 要跳转的页面，
    /// @parma untilRouteName 移除截止页面，默认根页面，
    func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: HzRouterOptions?);
}


 extension HzRouterDelegate {

     // 自定义路由代理
     public var customRouterDelegate: (any HzCustomRouterDelegate)? {
         return HzRouter.customRouterDelegate
       }
         
    public var flutterNavigator: HzFlutterNavigator {
        get {
            return HzRouter.mainFlutterEngineNavigator!
        }
    }
     
     public func handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
         
         var options = HzRouterOptions.init()
         var routeName: String = ""
         var untilRouteName: String?
         if (call.arguments is Dictionary<String, Any>) {
             let arguments: Dictionary<String, Any> = call.arguments as! Dictionary<String, Any>
             options.newEngineOpaque = (arguments["newEngineOpaque"] != nil) && arguments["newEngineOpaque"] as! Bool == true
             options.withNewEngine = arguments["withNewEngine"] as? Bool ?? false
             routeName = arguments["routeName"] as? String ?? ""
             untilRouteName = arguments["routeName"] as? String
             if (arguments ["arguments"] != nil && arguments ["arguments"] is Dictionary<String, Any>) {
                 options.arguments = arguments["arguments"] as? Dictionary<String, Any>
             }
         }
         
         options.callBack = {response in
             result(response)
         }

         switch call.method {
         case HzRouterPlugin.hzPushNamedMethod:
             self.push(routeName: routeName, options: options)
             break
         case HzRouterPlugin.hzPopMethod:
             self.pop(options: options)
             break
         case HzRouterPlugin.hzPushReplacementNamedMethod:
             self.pushToReplacement(routeName: routeName, options: options)
             break
         case HzRouterPlugin.hzPushNamedAndRemoveUntilMethod:
             self.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
             break
         case HzRouterPlugin.hzPopUntilMethod:
             self.popUntil(untilRouteName: untilRouteName ?? routeName, options: options)
             break
         case HzRouterPlugin.hzPopToRootMethod:
             self.popToRoot(options: options)
             break
         case HzRouterPlugin.hzDismissMethod:
             self.dismiss(options: options)
             break
         default:
           result(FlutterMethodNotImplemented)
         }
     }
    
    public func present(routeName: String, options: HzRouterOptions?) {
        
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[routeName]
        let vc: UIViewController? = vcBuilder?(options?.arguments)
        if (vc != nil) {
            HzNativeNavigator.present(toPage: vc!)
            options?.callBack?(true)
        }else if (self.customRouterDelegate != nil ){
            self.customRouterDelegate?.pushToNative(routeName: routeName, options: options)
        } else {
            options?.callBack?(false)
        }
    }
    
    public func push(routeName: String, options: HzRouterOptions?) {

        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[routeName]
        let vc: UIViewController? = vcBuilder?(options?.arguments)
        if (vc != nil) {
            HzNativeNavigator.push(toPage: vc!)
            options?.callBack?(true)
        }else if (self.customRouterDelegate != nil ){
            self.customRouterDelegate?.pushToNative(routeName: routeName, options: options)
        } else {
            options?.callBack?(false)
        }
    }
    
    public func popUntil(untilRouteName: String, options: HzRouterOptions?) {
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[untilRouteName]
        let vc: UIViewController? = vcBuilder?(options?.arguments)
        if (vc != nil) {
            HzNativeNavigator.popUntil(untilPage: vc!)
            options?.callBack?(true)
        } else if (self.customRouterDelegate != nil) {
            self.customRouterDelegate?.popNativeUntil(untilRouteName: untilRouteName, options: options)
        } else {
            self.flutterNavigator.popUntil(untilRouteName: untilRouteName, options: options)
        }
    }
    
    public func pushToReplacement(routeName: String, options: HzRouterOptions?) {
        
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[routeName]
        let vc: UIViewController? = vcBuilder?(options?.arguments)
        if (vc != nil) {
            HzNativeNavigator.pushToReplacement(toPage: vc!)
            options?.callBack?(true)
        } else {
            self.flutterNavigator.popUntil(untilRouteName: routeName, options: options)
        }
    }
    
    public func pop(options: HzRouterOptions?) {
        HzNativeNavigator.pop()
    }
    
    public func popToRoot(options: HzRouterOptions?) {
        HzNativeNavigator.popToRoot()
        self.flutterNavigator.popToRoot(options: options)
    }
    
    public func dismiss(options: HzRouterOptions?) {
        HzNativeNavigator.dismiss()
    }
    
    public func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: HzRouterOptions?) {
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[routeName]
        let untileVcBuilder: HzRouterBuilder? = HzRouter.routerDict[untilRouteName ?? ""]
        let vc: UIViewController? = vcBuilder?(options?.arguments)
        let untilVc: UIViewController? = untileVcBuilder?(options?.arguments)
        if (vc != nil) {
            HzNativeNavigator.pushToAndRemoveUntil(toPage: vc!, untilPage: untilVc)
        } else {
            self.flutterNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
        }
    }
    /******************** HzRouterDelegate  end****************************/
    
}


// 自定义路由方法，客户端通过实现HzCustomRouterDelegate自定义跳转
public protocol HzCustomRouterDelegate {
    func pushToNative(routeName: String, options: HzRouterOptions?)
    func popNativeUntil(untilRouteName: String, options: HzRouterOptions?)
}

