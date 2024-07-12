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
       let vcBuilder: FMRouterBuilder? = FlutterMeteorRouter.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.push(toPage: vc!)
           options?.callBack?(true)
       } else if(options?.withNewEngine != nil && options!.withNewEngine) {
           let newEngineOpaque: Bool = options?.newEngineOpaque ?? true
           let flutterVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: options?.arguments, initialRoute: routeName, nibName: nil, bundle:nil, popCallBack: {result in
               print(result ?? "")
               options?.callBack?(true)
           })
           flutterVc.isViewOpaque = newEngineOpaque
           flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
           if(!newEngineOpaque) {
               flutterVc.view.backgroundColor = UIColor.clear
           }
           FMNativeNavigator.push(toPage: flutterVc)
       } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(false)
       }
   }
    
    public static func present(routeName: String, options: FMMeteorOptions?) {
       
       let vcBuilder: FMRouterBuilder? = FlutterMeteorRouter.routerDict[routeName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.present(toPage: vc!)
           options?.callBack?(true)
       } else if(options?.withNewEngine != nil && options!.withNewEngine) {
           let newEngineOpaque: Bool = options?.newEngineOpaque ?? true
           let flutterVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: options?.arguments, initialRoute: routeName, nibName: nil, bundle:nil, popCallBack: {result in
               print(result ?? "")
               options?.callBack?(true)
           })
           flutterVc.isViewOpaque = newEngineOpaque
           flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
           if(!newEngineOpaque) {
               flutterVc.view.backgroundColor = UIColor.clear
           }
           FMNativeNavigator.present(toPage: flutterVc)

       } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(false)
       }
   }
   
    public static func popUntil(untilRouteName: String, options: FMMeteorOptions?) {
        print("Call popUntil untilRouteName:\(untilRouteName)")
       let vcBuilder: FMRouterBuilder? = FlutterMeteorRouter.routerDict[untilRouteName]
       let vc: UIViewController? = vcBuilder?(options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.popUntil(untilPage: vc!)
           options?.callBack?(true)
       } else {
           FlutterMeteor.flutterNavigator.popUntil(untilRouteName: untilRouteName, options: options)
       }
   }
   
    public static func pushToReplacement(routeName: String, options: FMMeteorOptions?) {

       let vcBuilder: FMRouterBuilder? = FlutterMeteorRouter.routerDict[routeName]
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
       let vcBuilder: FMRouterBuilder? = FlutterMeteorRouter.routerDict[routeName]
       let untileVcBuilder: FMRouterBuilder? = FlutterMeteorRouter.routerDict[untilRouteName ?? ""]
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
