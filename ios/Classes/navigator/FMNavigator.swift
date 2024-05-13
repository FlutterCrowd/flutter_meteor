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

    private static var mainEngineFlutterNaviagtor: FMFlutterNavigator?
    // 主引擎MethodChannel
    public static var flutterNavigator: FMFlutterNavigator {
        get {
            if (mainEngineFlutterNaviagtor == nil) {
                mainEngineFlutterNaviagtor = FMFlutterNavigator.init(methodChannel: FMMethodChannel.flutterRootEngineMethodChannel)
            }
            return mainEngineFlutterNaviagtor!
        }
        set {
            mainEngineFlutterNaviagtor = newValue
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
