//
//  HzNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/12.
//

import Foundation
import Flutter

public class HzNavigator {

    // 自定义路由代理
    public static var customRouterDelegate: (any HzRouterDelegate)?
    // 主引擎flutter导航器
    public static var mainEngineFlutterNaviagtor: HzFlutterNavigator?

    //
    public static var flutterNavigator: HzFlutterNavigator {
        return mainEngineFlutterNaviagtor! 
    }

    public static func  handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
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
    
    public static func present(routeName: String, options: HzRouterOptions?) {
       
       let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           HzNativeNavigator.present(toPage: vc!)
           options?.callBack?(true)
       }else if (self.customRouterDelegate != nil ){
           self.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(false)
       }
   }
   
    public static func push(routeName: String, options: HzRouterOptions?) {

       let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           HzNativeNavigator.push(toPage: vc!)
           options?.callBack?(true)
       }else if (self.customRouterDelegate != nil ){
           self.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(false)
       }
   }
   
    public static func popUntil(untilRouteName: String, options: HzRouterOptions?) {
       let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[untilRouteName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           HzNativeNavigator.popUntil(untilPage: vc!)
           options?.callBack?(true)
       } else if (self.customRouterDelegate != nil) {
           self.customRouterDelegate?.popUntil(untilRouteName: untilRouteName, options: options)
       } else {
           self.flutterNavigator.popUntil(untilRouteName: untilRouteName, options: options)
       }
   }
   
    public static func pushToReplacement(routeName: String, options: HzRouterOptions?) {
       
       let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           HzNativeNavigator.pushToReplacement(toPage: vc!)
           options?.callBack?(true)
       } else {
           self.flutterNavigator.popUntil(untilRouteName: routeName, options: options)
       }
   }
   
    public static func pop(options: HzRouterOptions?) {
       HzNativeNavigator.pop()
   }
   
    public static func popToRoot(options: HzRouterOptions?) {
       HzNativeNavigator.popToRoot()
        self.flutterNavigator.popToRoot(options: options)
   }
   
    public static func dismiss(options: HzRouterOptions?) {
       HzNativeNavigator.dismiss()
   }
   
    public static func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: HzRouterOptions?) {
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
   
}
