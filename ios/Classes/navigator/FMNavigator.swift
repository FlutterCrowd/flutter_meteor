//
//  HzNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/12.
//

import Foundation
import Flutter

public class FMNavigator {

    // 自定义路由代理
    public static var customRouterDelegate: (any FlutterMeteorDelegate)?
    // 主引擎flutter导航器
    public static var mainEngineFlutterNaviagtor: FMFlutterNavigator?

    //
    private static var flutterNavigator: FMFlutterNavigator {
        return mainEngineFlutterNaviagtor!
    }
    
    static let hzPushNamedMethod: String = "pushNamed";
    static let hzPushReplacementNamedMethod: String = "pushReplacementNamed";
    static let hzPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil";
    static let hzPopMethod: String = "pop";
    static let hzPopUntilMethod: String = "popUntil";
    static let hzPopToRootMethod: String = "popToRoot";
    static let hzDismissMethod: String = "dismiss";


    public static func  handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        var options = FMMeteorOptions.init()
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
        case hzPushNamedMethod:
            self.push(routeName: routeName, options: options)
            break
        case hzPopMethod:
            self.pop(options: options)
            break
        case hzPushReplacementNamedMethod:
            self.pushToReplacement(routeName: routeName, options: options)
            break
        case hzPushNamedAndRemoveUntilMethod:
            self.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
            break
        case hzPopUntilMethod:
            self.popUntil(untilRouteName: untilRouteName ?? routeName, options: options)
            break
        case hzPopToRootMethod:
            self.popToRoot(options: options)
            break
        case hzDismissMethod:
            self.dismiss(options: options)
            break
        default:
          result(FlutterMethodNotImplemented)
        }
    }
    
    public static func present(routeName: String, options: FMMeteorOptions?) {
       
       let vcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.present(toPage: vc!)
           options?.callBack?(true)
       }else if (self.customRouterDelegate != nil ){
           self.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(false)
       }
   }
   
    public static func push(routeName: String, options: FMMeteorOptions?) {

       let vcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.push(toPage: vc!)
           options?.callBack?(true)
       }else if (self.customRouterDelegate != nil ){
           self.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(false)
       }
   }
   
    public static func popUntil(untilRouteName: String, options: FMMeteorOptions?) {
       let vcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[untilRouteName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.popUntil(untilPage: vc!)
           options?.callBack?(true)
       } else if (self.customRouterDelegate != nil) {
           self.customRouterDelegate?.popUntil(untilRouteName: untilRouteName, options: options)
       } else {
           self.flutterNavigator.popUntil(untilRouteName: untilRouteName, options: options)
       }
   }
   
    public static func pushToReplacement(routeName: String, options: FMMeteorOptions?) {
       
       let vcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.pushToReplacement(toPage: vc!)
           options?.callBack?(true)
       } else {
           self.flutterNavigator.popUntil(untilRouteName: routeName, options: options)
       }
   }
   
    public static func pop(options: FMMeteorOptions?) {
       FMNativeNavigator.pop()
   }
   
    public static func popToRoot(options: FMMeteorOptions?) {
       FMNativeNavigator.popToRoot()
        self.flutterNavigator.popToRoot(options: options)
   }
   
    public static func dismiss(options: FMMeteorOptions?) {
       FMNativeNavigator.dismiss()
   }
   
    public static func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: FMMeteorOptions?) {
       let vcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[routeName]
       let untileVcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[untilRouteName ?? ""]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       let untilVc: UIViewController? = untileVcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.pushToAndRemoveUntil(toPage: vc!, untilPage: untilVc)
       } else {
           self.flutterNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
       }
   }
   
}
