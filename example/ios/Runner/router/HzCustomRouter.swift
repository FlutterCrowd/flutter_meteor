//
//  HzMultiEngineHandler.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import flutter_meteor

 class HzCustomRouter: NSObject, FlutterMeteorCustomDelegate {
    
     func push(routeName: String, options: MeteorPushOptions?) {
        if (routeName == "push_native") {
            let vc:TestViewController  = TestViewController.init()
            vc.routeName = routeName
            MeteorNativeNavigator.push(toPage: vc);
             options?.callBack?(nil)
        } else if (routeName == "present_native") {
//            let isOpaque: Bool =  options?.isOpaque ?? true
            
            let engineGroupOptions = MeteorEngineGroupOptions.init(
                entrypoint: "main",
                initialRoute: routeName,
                entrypointArgs: options?.arguments)
            
            let flutterVc = MeteorFlutterViewController.init(options: engineGroupOptions) { response in
                 options?.callBack?(nil)
            }
            
            flutterVc.isViewOpaque = options?.isOpaque ?? true
            flutterVc.routeName = routeName
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            let naviVc = UINavigationController.init(rootViewController: flutterVc)
            naviVc.navigationBar.isHidden = true
            MeteorNativeNavigator.present(toPage: naviVc)
            options?.callBack?(nil)
            
        } else if (routeName == "popWindowPage") {
            
            if(options?.withNewEngine ?? false) {
                let engineGroupOptions = MeteorEngineGroupOptions.init(
                    entrypoint: "main",
                    initialRoute: routeName,
                    entrypointArgs:  options?.arguments)
                
                let flutterVc = MeteorFlutterViewController.init(options: engineGroupOptions) { response in
                     options?.callBack?(nil)
                }
                flutterVc.routeName = routeName
                flutterVc.isViewOpaque = options?.isOpaque ?? true
                flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                flutterVc.view.backgroundColor = UIColor.clear
                MeteorNativeNavigator.present(toPage: flutterVc)

            } else {
                let vc:UIViewController  = UIViewController.init()
                vc.view.backgroundColor = UIColor.clear
                let button: UIButton = UIButton.init(frame: CGRect(x: 20, y: 100, width: 200, height: 80))
                button.setTitle("按钮", for: UIControl.State.normal)
                button.backgroundColor = UIColor.red
                vc.view.addSubview(button)
                MeteorNativeNavigator.present(toPage: vc)
                 options?.callBack?(nil)
            }
        } else if ( routeName == "multiEnginePage2") {
            let isOpaque: Bool =  options?.isOpaque ?? true
            let engineGroupOptions = MeteorEngineGroupOptions.init(
                entrypoint: "main",
                initialRoute: routeName,
                entrypointArgs:  options?.arguments)
            
            let flutterVc = MeteorFlutterViewController.init(options: engineGroupOptions) { response in
                 options?.callBack?(nil)
            }
            flutterVc.routeName = routeName
            flutterVc.isViewOpaque = isOpaque
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            MeteorNativeNavigator.push(toPage: flutterVc)
             options?.callBack?(nil)
            
        } else  if (routeName  == "test4"){
            let engineGroupOptions = MeteorEngineGroupOptions.init(
                entrypoint: "main",
                initialRoute: routeName,
                entrypointArgs:  options?.arguments)
            
            let flutterVc = MeteorFlutterViewController.init(options: engineGroupOptions) { response in
                 options?.callBack?(nil)
            }
            MeteorNativeNavigator.push(toPage: flutterVc)
             options?.callBack?(nil)
        } else {
            let engineGroupOptions = MeteorEngineGroupOptions.init(
                entrypoint: "main",
                initialRoute: routeName,
                entrypointArgs:  options?.arguments)
            
            let flutterVc = MeteorFlutterViewController.init(options: engineGroupOptions) { response in
                 options?.callBack?(nil)
            }
            flutterVc.routeName = routeName
            flutterVc.isViewOpaque = options?.isOpaque ?? true
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            MeteorNativeNavigator.push(toPage: flutterVc)
             options?.callBack?(nil)
        }
        
    }
   
}
