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
                if let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                    var arguments: Dictionary<String, Any?> = options?.arguments ?? [:]
                    if (arguments["routeName"] == nil) {
                        arguments["routeName"] = untilRouteName
                        arguments["arguments"] = arguments
                    }
                    channel.save_invoke(method: FMPopUntilMethod, arguments: arguments) { ret in
                        options?.callBack?(ret)
                    }
                } else {
                    options?.callBack?(nil)
                    print("MethodChannel 为空")
                }
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
                if let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                    var arguments: Dictionary<String, Any?> = options?.arguments ?? [:]
                    if (arguments["routeName"] == nil) {
                        arguments["routeName"] = routeName
                        arguments["untilRouteName"] = untilRouteName
                        arguments["arguments"] = arguments
                    }
                    channel.save_invoke(method: FMPushNamedAndRemoveUntilMethod, arguments: arguments) { ret in
                        options?.callBack?(ret)
                    }
                } else {
                    options?.callBack?(nil)
                    print("MethodChannel 为空")
                }
            } else {
                options?.callBack?(nil)
            }
        }
    }
    
    public static func pushNamedAndRemoveUntilRoot(routeName: String, options: FMPushOptions? = nil) {
           
        func flutterPopToRoot() {
            if let flutterVc = FMRouterManager.topViewController() as? FlutterViewController {
                if let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                    var arguments: Dictionary<String, Any?> = options?.arguments ?? [:]
                    if (arguments["routeName"] == nil) {
                        arguments["routeName"] = routeName
                        arguments["arguments"] = arguments
                    }
                    channel.save_invoke(method: FMPushNamedAndRemoveUntilRootMethod, arguments: arguments) { ret in
                        options?.callBack?(ret)
                    }
                } else {
                    options?.callBack?(nil)
                    print("MethodChannel 为空")
                }
            }
        }
        let toPage: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
        if (toPage != nil) {
            FMNativeNavigator.pushToAndRemoveUntilRoot(toPage: toPage!, animated: options?.animated ?? true)
            options?.callBack?(nil)
        } else if(options?.withNewEngine ?? false) {
            let flutterVc = createFlutterVc(routeName: routeName, options: options)
            FMNativeNavigator.pushToAndRemoveUntilRoot(toPage: flutterVc, animated: options?.animated ?? true)
            options?.callBack?(nil)
        }
        flutterPopToRoot()
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
               if let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                   var arguments: Dictionary<String, Any?> = options?.arguments ?? [:]
                   if (arguments["routeName"] == nil) {
                       arguments["routeName"] = routeName
                       arguments["arguments"] = arguments
                   }
                   channel.save_invoke(method: FMPushReplacementNamedMethod, arguments: arguments) { ret in
                       options?.callBack?(ret)
                   }
               } else {
                   options?.callBack?(nil)
                   print("MethodChannel 为空")
               }
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
            pop(options: options)
            print("No valid untilRouteName")
        }
   
    }
    
    private static func _popUntil(untilRouteName: String, untilPage: UIViewController?, options: FMPopOptions?) {
        // 1、先查询untilRouteName所在的viewController
        if (untilPage != nil) {
            FMNativeNavigator.popUntil(untilPage: untilPage!, animated: options?.animated ?? true)
            if let flutterVc = untilPage as? FlutterViewController {
                // 3、如果是FlutterViewController则通过Channel通道在flutter端popUntil
                if let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                    var arguments: Dictionary<String, Any?> = options?.result ?? [:]
                    if (arguments["routeName"] == nil) {
                        arguments["routeName"] = untilRouteName
                        arguments["arguments"] = arguments
                    }
                    channel.save_invoke(method: FMPopUntilMethod, arguments: arguments) { ret in
                        options?.callBack?(ret)
                    }
                } else {
                    options?.callBack?(nil)
                    print("MethodChannel 为空")
                }
            }
        } else { //如果untilPage不存在则返回上一页
            FMNativeNavigator.pop(animated: options?.animated ?? true)
            options?.callBack?(nil)
            print("pop until 查无此路由直接返回上一级页面")
        }
    }
   
    public static func popToRoot(options: FMPopOptions? = nil) {
        
        func flutterPopRoot(flutterVc: FlutterViewController, options: FMPopOptions?){
            if let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                channel.save_invoke(method: FMPopToRootMethod, arguments: options?.result) { response in
                    options?.callBack?(response)
                }
            } else {
                options?.callBack?(nil)
                print("No valid method channel")
            }
        }
        
        let rootVc = FMRouterManager.rootViewController()
        if let flutterVc = rootVc as? FlutterViewController {
            flutterPopRoot(flutterVc: flutterVc, options: options)
        } else if let naviVc = rootVc as? UINavigationController {
            if let flutterVc = naviVc.viewControllers.first as? FlutterViewController {
                flutterPopRoot(flutterVc: flutterVc, options: options)
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

