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
//        if options?.present == true {
//            let navi = UINavigationController.init(rootViewController: flutterViewController)
//            MeteorNavigatorHelper.topViewController()?.present(navi, animated: options?.animated ?? true)
//        } else {
//            if let navigationController = MeteorNavigatorHelper.topViewController()?.navigationController {
//                navigationController.pushViewController(flutterViewController, animated: options?.animated ?? true)
//            }
//        }
    }

    func openNativePage(routeName: String, options: MeteorPushOptions?) {
        if routeName == "push_native" {
            let vc = TestViewController()
            vc.routeName = routeName
            MeteorNativeNavigator.push(toPage: vc)
            options?.callBack?(nil)
        } else if routeName == "present_native" {
            //            let isOpaque: Bool =  options?.isOpaque ?? true

            let engineGroupOptions = MeteorEngineGroupOptions(
                entrypoint: "main",
                initialRoute: routeName,
                entrypointArgs: options?.arguments
            )

            let flutterVc = MeteorFlutterViewController(options: engineGroupOptions) { _ in
                options?.callBack?(nil)
            }

            flutterVc.isViewOpaque = options?.isOpaque ?? true
            flutterVc.routeName = routeName
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            let naviVc = UINavigationController(rootViewController: flutterVc)
            naviVc.navigationBar.isHidden = true
            MeteorNativeNavigator.present(toPage: naviVc)
            options?.callBack?(nil)

        } else if routeName == "popWindowPage" {
            if options?.pageType == .newEngine {
                let engineGroupOptions = MeteorEngineGroupOptions(
                    entrypoint: "main",
                    initialRoute: routeName,
                    entrypointArgs: options?.arguments
                )

                let flutterVc = MeteorFlutterViewController(options: engineGroupOptions) { _ in
                    options?.callBack?(nil)
                }
                flutterVc.routeName = routeName
                flutterVc.isViewOpaque = options?.isOpaque ?? true
                flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                flutterVc.view.backgroundColor = UIColor.clear
                MeteorNativeNavigator.present(toPage: flutterVc)

            } else {
                let vc = UIViewController()
                vc.view.backgroundColor = UIColor.clear
                let button = UIButton(frame: CGRect(x: 20, y: 100, width: 200, height: 80))
                button.setTitle("按钮", for: UIControl.State.normal)
                button.backgroundColor = UIColor.red
                vc.view.addSubview(button)
                MeteorNativeNavigator.present(toPage: vc)
                options?.callBack?(nil)
            }
        } else if routeName == "multiEnginePage2" {
            let isOpaque: Bool = options?.isOpaque ?? true
            let engineGroupOptions = MeteorEngineGroupOptions(
                entrypoint: "main",
                initialRoute: routeName,
                entrypointArgs: options?.arguments
            )

            let flutterVc = MeteorFlutterViewController(options: engineGroupOptions) { _ in
                options?.callBack?(nil)
            }
            flutterVc.routeName = routeName
            flutterVc.isViewOpaque = isOpaque
            flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            flutterVc.view.backgroundColor = UIColor.clear
            MeteorNativeNavigator.push(toPage: flutterVc)
            options?.callBack?(nil)

        } else if routeName == "native_page4" {
            let engineGroupOptions = MeteorEngineGroupOptions(
                entrypoint: "main",
                initialRoute: routeName,
                entrypointArgs: options?.arguments
            )

            let flutterVc = MeteorFlutterViewController(options: engineGroupOptions) { _ in
                options?.callBack?(nil)
            }
            MeteorNativeNavigator.push(toPage: flutterVc)
            options?.callBack?(nil)
        } else {
            let engineGroupOptions = MeteorEngineGroupOptions(
                entrypoint: "main",
                initialRoute: routeName,
                entrypointArgs: options?.arguments
            )

            let flutterVc = MeteorFlutterViewController(options: engineGroupOptions) { _ in
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
