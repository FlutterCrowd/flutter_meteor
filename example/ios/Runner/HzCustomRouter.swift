//
//  HzMultiEngineHandler.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import flutter_meteor

 class HzCustomRouter: NSObject, FlutterMeteorCustomDelegate {
    
     func push(routeName: String, options: FMPushOptions?) {
        if (routeName == "push_native") {
            let vc:TestViewController  = TestViewController.init()
            FMNativeNavigator.push(toPage: vc);
             options?.callBack?(nil)
        } else if (routeName == "present_native") {
//            let newEngineOpaque: Bool =  options?.newEngineOpaque ?? true
            
            let engineGroupOptions = FMEngineGroupOptions.init(
                entrypoint: "childEntry",
                initialRoute: routeName,
                entrypointArgs: options?.arguments)
            
            let flutterVc = FMFlutterViewController.init(options: engineGroupOptions) { response in
                 options?.callBack?(nil)
            }
            
            flutterVc.isViewOpaque = options?.newEngineOpaque ?? true
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            let naviVc = UINavigationController.init(rootViewController: flutterVc)
            naviVc.navigationBar.isHidden = true
            FMNativeNavigator.present(toPage: naviVc)
            options?.callBack?(nil)
            
        } else if (routeName == "popWindow") {
            
            if(options?.withNewEngine ?? false) {
                let engineGroupOptions = FMEngineGroupOptions.init(
                    entrypoint: "childEntry",
                    initialRoute: routeName,
                    entrypointArgs:  options?.arguments)
                
                let flutterVc = FMFlutterViewController.init(options: engineGroupOptions) { response in
                     options?.callBack?(nil)
                }
                flutterVc.isViewOpaque = options?.newEngineOpaque ?? true
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
                 options?.callBack?(nil)
            }
        } else if ( routeName == "multi_engin2") {
            let newEngineOpaque: Bool =  options?.newEngineOpaque ?? true
            let engineGroupOptions = FMEngineGroupOptions.init(
                entrypoint: "childEntry",
                initialRoute: routeName,
                entrypointArgs:  options?.arguments)
            
            let flutterVc = FMFlutterViewController.init(options: engineGroupOptions) { response in
                 options?.callBack?(nil)
            }
            flutterVc.isViewOpaque = newEngineOpaque
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            FMNativeNavigator.push(toPage: flutterVc)
             options?.callBack?(nil)
            
        } else  if (routeName  == "test4"){
            let engineGroupOptions = FMEngineGroupOptions.init(
                entrypoint: "childEntry",
                initialRoute: routeName,
                entrypointArgs:  options?.arguments)
            
            let flutterVc = FMFlutterViewController.init(options: engineGroupOptions) { response in
                 options?.callBack?(nil)
            }
            FMNativeNavigator.push(toPage: flutterVc)
             options?.callBack?(nil)
        } else {
            let engineGroupOptions = FMEngineGroupOptions.init(
                entrypoint: "childEntry",
                initialRoute: routeName,
                entrypointArgs:  options?.arguments)
            
            let flutterVc = FMFlutterViewController.init(options: engineGroupOptions) { response in
                 options?.callBack?(nil)
            }
            flutterVc.isViewOpaque = options?.newEngineOpaque ?? true
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            FMNativeNavigator.push(toPage: flutterVc)
             options?.callBack?(nil)
        }
        
    }
   
}
