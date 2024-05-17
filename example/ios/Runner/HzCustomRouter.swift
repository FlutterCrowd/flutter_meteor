//
//  HzMultiEngineHandler.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import flutter_meteor

 class HzCustomRouter: NSObject, FlutterMeteorDelegate {
    
    public func push(routeName: String, options: FMMeteorOptions?) {
        if (routeName == "test1") {
            let vc:TestViewController  = TestViewController.init()
            FMNativeNavigator.push(toPage: vc);
            options?.callBack?(true)
        } else if (routeName == "test2") {
            let newEngineOpaque: Bool = options?.newEngineOpaque ?? true
            let flutterVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: options?.arguments, initialRoute: "popWindow", nibName: nil, bundle:nil, popCallBack: {result in
                print(result ?? "")
            })
            flutterVc.isViewOpaque = newEngineOpaque
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            let naviVc = UINavigationController.init(rootViewController: flutterVc)
            FMNativeNavigator.present(toPage: naviVc)
            options?.callBack?(true)
            
        } else if (routeName == "popWindow") {
            
            let withNewEngine: Bool = options?.withNewEngine ?? false
            if(withNewEngine) {
                let newEngineOpaque: Bool = options?.newEngineOpaque ?? true
                let flutterVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: options?.arguments, initialRoute: routeName, nibName: nil, bundle:nil, popCallBack: {result in
                    print(result ?? "")
                })
                flutterVc.isViewOpaque = newEngineOpaque
                flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                flutterVc.view.backgroundColor = UIColor.clear
                FMNativeNavigator.present(toPage: flutterVc)

            } else {
                let vc:UIViewController  = UIViewController.init()
                vc.view.backgroundColor = UIColor.clear
                let button: UIButton = UIButton.init(frame: CGRect(x: 20, y: 100, width: 200, height: 80))
                button.setTitle("按钮", for: UIControl.State.normal)
                button.backgroundColor = UIColor.red
                vc.view.addSubview(button)
                FMNativeNavigator.present(toPage: vc)
                options?.callBack?(true)
            }
        } else if (routeName == "test3") {
            let newEngineOpaque: Bool = options?.newEngineOpaque ?? true
            let flutterVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: options?.arguments, initialRoute: "popWindow", nibName: nil, bundle:nil, popCallBack: {result in
                print(result ?? "")
            })
            flutterVc.isViewOpaque = newEngineOpaque
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            FMNativeNavigator.present(toPage: flutterVc)
            options?.callBack?(true)
            
        } else  if (routeName == "test4"){
          let newEngineOpaque: Bool = options?.newEngineOpaque ?? true
            let flutterVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: options?.arguments, initialRoute: "multi_engin2", nibName: nil, bundle:nil, popCallBack: {result in
                print(result ?? "")
            })
            flutterVc.isViewOpaque = newEngineOpaque
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            FMNativeNavigator.push(toPage: flutterVc)
            options?.callBack?(true)
        } else {
            let newEngineOpaque: Bool = options?.newEngineOpaque ?? true
            let flutterVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: options?.arguments, initialRoute: "multi_engin2", nibName: nil, bundle:nil, popCallBack: {result in
                print(result ?? "")
            })
            flutterVc.isViewOpaque = newEngineOpaque
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            FMNativeNavigator.push(toPage: flutterVc)
            options?.callBack?(false)
        }
        
    }
    
    public func popNativeUntil(untilRouteName: String, options: FMMeteorOptions?) {
    }
    

   
}
