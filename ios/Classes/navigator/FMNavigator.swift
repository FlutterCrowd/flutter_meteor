//
//  HzNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/12.
//

import Foundation
//import Flutter

public class FMNavigator {
       
    public static func push(routeName: String, options: FMMeteorOptions?) {
        print("Call push untilRouteName:\(routeName)")
       let vcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.push(toPage: vc!)
           options?.callBack?(true)
       } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(false)
       }
   }
    
    public static func present(routeName: String, options: FMMeteorOptions?) {
       
       let vcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.present(toPage: vc!)
           options?.callBack?(true)
       } else {
           options?.callBack?(false)
       }
   }
   
    public static func popUntil(untilRouteName: String, options: FMMeteorOptions?) {
        print("Call popUntil untilRouteName:\(untilRouteName)")
       let vcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[untilRouteName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.popUntil(untilPage: vc!)
           options?.callBack?(true)
       } else {
           FlutterMeteor.flutterNavigator.popUntil(untilRouteName: untilRouteName, options: options)
       }
   }
   
    public static func pushToReplacement(routeName: String, options: FMMeteorOptions?) {

       let vcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.pushToReplacement(toPage: vc!)
           options?.callBack?(true)
       } else {
           FlutterMeteor.flutterNavigator.popUntil(untilRouteName: routeName, options: options)
       }
   }
   
    public static func pop(options: FMMeteorOptions?) {
        FMNativeNavigator.pop()
        options?.callBack?(true)
   }
   
    public static func popToRoot(options: FMMeteorOptions?) {
        FMNativeNavigator.popToRoot()
        FlutterMeteor.flutterNavigator.popToRoot(options: options)
   }
   
    public static func dismiss(options: FMMeteorOptions?) {
        FMNativeNavigator.dismiss()
        options?.callBack?(true)
   }
    
    public static func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: FMMeteorOptions?) {
       let vcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[routeName]
       let untileVcBuilder: FMRouterBuilder? = FlutterMeteor.routerDict[untilRouteName ?? ""]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       let untilVc: UIViewController? = untileVcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.pushToAndRemoveUntil(toPage: vc!, untilPage: untilVc)
           options?.callBack?(true)
       } else {
           FlutterMeteor.flutterNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
       }
   }
}
