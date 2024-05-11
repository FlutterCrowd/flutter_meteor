//
//  HzMultiEngineHandler.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import hz_router

public class HzCustomRouter: NSObject, HzCustomRouterDelegate {
        
    public func pushToNative(routeName: String, arguments: Dictionary<String, Any>?, callBack: hz_router.HzRouterCallBack?) {
        
        if (routeName == "test1") {
            let vc:TestViewController  = TestViewController.init()
            HzNativeNavigator.present(toPage: vc, arguments: arguments, callBack: callBack);
        } else if (routeName == "test2") {
            let vc:UIViewController  = UIViewController.init()
            vc.view.backgroundColor = UIColor.clear
            let button: UIButton = UIButton.init(frame: CGRect(x: 20, y: 100, width: 200, height: 80))
            button.setTitle("按钮", for: UIControl.State.normal)
            button.backgroundColor = UIColor.red
            vc.view.addSubview(button)
            HzNativeNavigator.present(toPage: vc, arguments: arguments, callBack: callBack)
        } else if (routeName == "test3") {
            let vc:HzFlutterViewController = HzFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: nil, initialRoute: "popWindow")
            HzNativeNavigator.push(toPage: vc, arguments: arguments, callBack: callBack)
        } else {
            let vc:HzFlutterViewController = HzFlutterViewController.init(engine: HzEngineManager.createFlutterEngineNoGroup(), nibName: nil, bundle: nil)
            vc.isViewOpaque = false
            HzNativeNavigator.push(toPage: vc, arguments: arguments, callBack: callBack)
        }
        
    }
    
    public func popNativeUntil(untilRouteName: String, arguments: Dictionary<String, Any>?, callBack: hz_router.HzRouterCallBack?) {
        
    }
    
   
}
