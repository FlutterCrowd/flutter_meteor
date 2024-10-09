//
//  HzCustomRouter.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/8.
//

import flutter_meteor
import Foundation

class HzCustomRouter: NSObject, FlutterMeteorCustomDelegate {
    func openFlutterPage(routeName: String, options: flutter_meteor.MeteorPushOptions?) {
        openNativePage(routeName: routeName, options: options)
    }

    func openNativePage(routeName: String, options: MeteorPushOptions?) {
        
        if options?.pageType == .newEngine {
            let flutterVc = getDefaultFlutterViewController(routeName: routeName, options: options)
            if options?.present == true {
                let navi = UINavigationController(rootViewController: flutterVc)
                navi.navigationBar.isHidden = true
                navi.view.backgroundColor = UIColor.clear
                navi.modalPresentationStyle = .overFullScreen
                navi.view.isOpaque = options?.isOpaque ?? false
                MeteorNativeNavigator.present(toPage: navi, animated: options?.animated ?? true) {
                    options?.callBack?(nil)
                }
            } else {
                MeteorNativeNavigator.push(toPage: flutterVc, animated: options?.animated ?? true)
                options?.callBack?(nil)
            }
        } else {
            
            var viewController: UIViewController!
            
            if routeName == "native_page" {
                let vc = TestViewController()
                vc.routeName = routeName
                viewController = vc
            } else if routeName == "native_page1" {
                viewController = TestViewController1()
            }  else if routeName == "native_page2" {
                viewController = TestViewController2()
            } else if routeName == "native_page3" {
                viewController = TestViewController3()
            } else if routeName == "native_page4" {
                viewController = TestViewController4()
            }else {
                let vc = TestViewController()
                vc.view.backgroundColor = UIColor.clear
                let button = UIButton(frame: CGRect(x: 20, y: 100, width: 200, height: 80))
                button.setTitle("按钮", for: UIControl.State.normal)
                button.backgroundColor = UIColor.red
                vc.view.addSubview(button)
                MeteorNativeNavigator.present(toPage: vc, animated: options?.animated ?? true) {
                    options?.callBack?(nil)
                }
            }
            
            if options?.present == true {
                let navi = UINavigationController(rootViewController: viewController)
                navi.navigationBar.isHidden = true
                navi.view.backgroundColor = UIColor.clear
                navi.modalPresentationStyle = .overFullScreen
                navi.view.isOpaque = options?.isOpaque ?? false
                MeteorNativeNavigator.present(toPage: navi, animated: options?.animated ?? true) {
                    options?.callBack?(nil)
                }
            } else {
                MeteorNativeNavigator.push(toPage: viewController, animated: options?.animated ?? true)
                options?.callBack?(nil)
            }
        }
    }
    
    
    func getDefaultFlutterViewController(routeName: String,
                                        entrypoint: String? = "main",
                                           options: MeteorPushOptions?) -> MeteorFlutterViewController
    {
        let isOpaque: Bool = options?.isOpaque ?? true
        let engineGroupOptions = MeteorEngineGroupOptions(
            entrypoint: entrypoint,
            initialRoute: routeName,
            entrypointArgs: options?.arguments
        )

        let flutterVc = MeteorFlutterViewController(options: engineGroupOptions) { _ in
            options?.callBack?(nil)
        }
        flutterVc.routeName = routeName
        flutterVc.isViewOpaque = isOpaque
        flutterVc.modalPresentationStyle = .overFullScreen
        if !isOpaque {
            flutterVc.view.backgroundColor = UIColor.clear
        }
        return flutterVc
    }
}
