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
        let vc: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.push(toPage: vc!)
           options?.callBack?(true)
       } else if(options?.withNewEngine != nil && options!.withNewEngine) {
           let flutterVc = createFlutterVc(routeName: routeName, options: options)
           FMNativeNavigator.push(toPage: flutterVc)
       } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(false)
       }
   }
    
    public static func present(routeName: String, options: FMMeteorOptions?) {
       
       let vc: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.present(toPage: vc!)
           options?.callBack?(true)
       } else if(options?.withNewEngine != nil && options!.withNewEngine) {
           let flutterVc = createFlutterVc(routeName: routeName, options: options)
           FMNativeNavigator.present(toPage: flutterVc)

       } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(false)
       }
   }
   
    public static func popUntil(untilRouteName: String, options: FMMeteorOptions?) {
        print("Call popUntil untilRouteName:\(untilRouteName)")
        let vc: UIViewController? = FlutterMeteorRouter.viewController(routeName: untilRouteName, arguments: options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.popUntil(untilPage: vc!)
           options?.callBack?(true)
       } else {
           FlutterMeteor.flutterNavigator.popUntil(untilRouteName: untilRouteName, options: options)
       }
   }
   
    public static func pushToReplacement(routeName: String, options: FMMeteorOptions?) {

        let vc: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
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
       let vc: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
       let untilVc: UIViewController? = FlutterMeteorRouter.viewController(routeName: untilRouteName, arguments: nil)
       if (vc != nil) {
           FMNativeNavigator.pushToAndRemoveUntil(toPage: vc!, untilPage: untilVc)
           options?.callBack?(true)
       } else {
           FlutterMeteor.flutterNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
       }
   }
    
    private static func createFlutterVc(routeName: String, options: FMMeteorOptions?) -> FMFlutterViewController {
        let newEngineOpaque: Bool = options?.newEngineOpaque ?? true
        let flutterVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: options?.arguments, initialRoute: routeName, nibName: nil, bundle:nil, popCallBack: {result in
            print(result ?? "")
            options?.callBack?(true)
        })
        flutterVc.routeName = routeName
        flutterVc.isViewOpaque = newEngineOpaque
        flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        if(!newEngineOpaque) {
            flutterVc.view.backgroundColor = UIColor.clear
        }
        return flutterVc
    }
}
