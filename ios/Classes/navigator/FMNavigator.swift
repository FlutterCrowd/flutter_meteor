//
//  HzNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/12.
//

import Foundation
import Flutter

public class FMNavigator {
       
    public static func push(routeName: String, options: FMPushOptions? = nil) {

        let vc: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
        if (vc != nil) {
           FMNativeNavigator.push(toPage: vc!, animated: options?.animated ?? true)
           options?.callBack?(nil)
        } else if(options?.withNewEngine ?? false) {
           let flutterVc = createFlutterVc(routeName: routeName, options: options)
           FMNativeNavigator.push(toPage: flutterVc, animated: options?.animated ?? true)
           options?.callBack?(nil)
        } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
        } else {
           options?.callBack?(nil)
        }
    }
    
    public static func present(routeName: String, options: FMPushOptions? = nil) {
       
        let vc: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
        if (vc != nil) {
           FMNativeNavigator.present(toPage: vc!, animated: options?.animated ?? true)
           options?.callBack?(nil)
        } else if(options?.withNewEngine ?? false) {
           let flutterVc = createFlutterVc(routeName: routeName, options: options)
           if options?.newEngineOpaque == false {
               FMNativeNavigator.present(toPage: flutterVc, animated: options?.animated ?? true)
           } else {
               let navi = UINavigationController.init(rootViewController: flutterVc)
               navi.navigationBar.isHidden = true
               FMNativeNavigator.present(toPage: navi, animated: options?.animated ?? true)
           }
           options?.callBack?(nil)
        } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
        } else {
           options?.callBack?(nil)
        }
   }
    
    public static func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: FMPushOptions? = nil) {
                
        if  untilRouteName != nil {
            FlutterMeteorRouter.searchRoute(routeName: untilRouteName!) { viewController in
                _realPushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName!, untilPage: viewController, options: options)
            }
        } else {
            _realPushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, untilPage: nil, options: options)
            print("No valid untilRouteName")
        }
    }
    
    
    public static func _realPushToAndRemoveUntil(
        routeName: String,
        untilRouteName: String?,
        untilPage: UIViewController?,
        options: FMPushOptions? = nil) {
                
        if let toPage = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments) {
            if let flutterVc =  untilPage as? FlutterViewController {
                FMNativeNavigator.push(toPage: toPage, animated: options?.animated ?? true)
                FMFlutterNavigator.popUntil(flutterVc: flutterVc, untilRouteName: untilRouteName, options: nil)
            } else {
                FMNativeNavigator.pushToAndRemoveUntil(toPage: toPage, untilPage: untilPage, animated: options?.animated ?? true)
                options?.callBack?(nil)
            }
        } else if(options?.withNewEngine ?? false) {
            let flutterVc = createFlutterVc(routeName: routeName, options: options)
            FMNativeNavigator.pushToAndRemoveUntil(toPage: flutterVc, untilPage: untilPage, animated: options?.animated ?? true)
            options?.callBack?(nil)
        } else if(FlutterMeteor.customRouterDelegate != nil) {
            FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
        } else {
            let currentVc = FMRouterManager.topViewController()
            if let flutterVc = currentVc as? FlutterViewController {
                FMFlutterNavigator.pushToAndRemoveUntil(flutterVc: flutterVc, routeName: routeName, untilRouteName: untilRouteName, options: options)
            } else {
                options?.callBack?(nil)
            }
        }
    }
    
    public static func pushNamedAndRemoveUntilRoot(routeName: String, options: FMPushOptions? = nil) {
        
        func flutterPopRoot(){
            let rootVc = FMRouterManager.rootViewController()
            if let flutterVc = rootVc as? FlutterViewController {
                if let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                    channel.save_invoke(method: FMPopToRootMethod)
                }
            } else if let naviVc = rootVc as? UINavigationController,
                        let flutterVc = naviVc.viewControllers.first as? FlutterViewController {
                if let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                    channel.save_invoke(method: FMPopToRootMethod)
                }
            }
        }
        
        let toPage: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
        if (toPage != nil) {
            FMNativeNavigator.pushToAndRemoveUntilRoot(toPage: toPage!, animated: options?.animated ?? true)
            flutterPopRoot()
            options?.callBack?(nil)
        } else if(options?.withNewEngine ?? false) {
            let flutterVc = createFlutterVc(routeName: routeName, options: options)
            FMNativeNavigator.pushToAndRemoveUntilRoot(toPage: flutterVc, animated: options?.animated ?? true)
            flutterPopRoot()
            options?.callBack?(nil)
        } else {
            if let flutterVc = FMRouterManager.topViewController() as? FlutterViewController {
                FMFlutterNavigator.pushNamedAndRemoveUntilRoot(flutterVc: flutterVc, routeName: routeName, options: options)
            }
        }
    }

   
    public static func pushToReplacement(routeName: String, options: FMPushOptions? = nil) {

       if let vc = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments) {
           FMNativeNavigator.pushToReplacement(toPage: vc, animated: options?.animated ?? true)
           options?.callBack?(nil)
       } else if(options?.withNewEngine ?? false) {
           let flutterVc = createFlutterVc(routeName: routeName, options: options)
           FMNativeNavigator.pushToReplacement(toPage: flutterVc, animated: options?.animated ?? true)
           options?.callBack?(nil)
       } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           let currentVc = FMRouterManager.topViewController()
           if let flutterVc = currentVc as? FlutterViewController {
               FMFlutterNavigator.pushToReplacement(flutterVc: flutterVc, routeName: routeName, options: options)
           } else {
               options?.callBack?(nil)
           }
       }
   }
   
    public static func pop(options: FMPopOptions? = nil) {
        FMNativeNavigator.pop()
        options?.callBack?(nil)
   }
    
    public static func popUntil(untilRouteName: String?, options: FMPopOptions? = nil) {

        if untilRouteName != nil {
            FlutterMeteorRouter.searchRoute(routeName: untilRouteName!) { viewController in
                _popUntil(untilRouteName: untilRouteName!, untilPage: viewController, options: options)
            }
        } else {
            if let flutterVc = FMRouterManager.topViewController() as? FlutterViewController {
                FMFlutterNavigator.pop(flutterVc: flutterVc)
            } else {
                FMNativeNavigator.pop(animated: options?.animated ?? true)
                options?.callBack?(nil)
                print("pop until 查无此路由直接返回上一级页面")
            }
            print("No valid untilRouteName")
        }
   
    }
    
    private static func _popUntil(untilRouteName: String, untilPage: UIViewController?, options: FMPopOptions?) {
        // 1、先查询untilRouteName所在的viewController
        if (untilPage != nil) {
            FMNativeNavigator.popUntil(untilPage: untilPage!, animated: options?.animated ?? true)
            if let flutterVc = untilPage as? FlutterViewController {
                // 3、如果是FlutterViewController则通过Channel通道在flutter端popUntil
                FMFlutterNavigator.popUntil(flutterVc: flutterVc, untilRouteName: untilRouteName, options: options)
            }
        } else { //如果untilPage不存在则返回上一页
            if let flutterVc = FMRouterManager.topViewController() as? FlutterViewController {
                FMFlutterNavigator.pop(flutterVc: flutterVc)
            } else {
                FMNativeNavigator.pop(animated: options?.animated ?? true)
                options?.callBack?(nil)
                print("pop until 查无此路由直接返回上一级页面")
            }
        }
    }
   
    public static func popToRoot(options: FMPopOptions? = nil) {
        
        let rootVc = FMRouterManager.rootViewController()
        if let flutterVc = rootVc as? FlutterViewController {
            FMFlutterNavigator.popToRoot(flutterVc: flutterVc, options: options)
        } else if let naviVc = rootVc as? UINavigationController {
            if let flutterVc = naviVc.viewControllers.first as? FlutterViewController {
                FMFlutterNavigator.popToRoot(flutterVc: flutterVc, options: options)
            }
        } else {
            print("ViewController is not a FlutterViewController")
            options?.callBack?(nil)
        }
        FMNativeNavigator.popToRoot(animated: options?.animated ?? true)

    }
   
    public static func dismiss(options: FMPopOptions? = nil) {
        FMNativeNavigator.dismiss(animated: options?.animated ?? true)
        options?.callBack?(nil)
    }
    
    
    private static func createFlutterVc(routeName: String, options: FMPushOptions?) -> FMFlutterViewController {
        let newEngineOpaque: Bool = options?.newEngineOpaque ?? true
        
        let engineGroupOptions = FMEngineGroupOptions.init(
            entrypoint: "childEntry",
            initialRoute: routeName,
            entrypointArgs: options?.arguments)
        
        let flutterVc = FMFlutterViewController.init(options: engineGroupOptions) { response in
            options?.callBack?(nil)
        }
        flutterVc.routeName = routeName
        flutterVc.isViewOpaque = newEngineOpaque
        flutterVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        if(!newEngineOpaque) {
            flutterVc.view.backgroundColor = UIColor.clear
        }
        return flutterVc
    }
}

