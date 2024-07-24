//
//  HzNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/12.
//

import Foundation
import Flutter

public class FMNavigator {
       
    public static func push(routeName: String, options: FMMeteorOptions?) {
        print("Call push untilRouteName:\(routeName)")
        let vc: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.push(toPage: vc!, animated: options?.animated ?? true)
           options?.callBack?(nil)
       } else if(options?.withNewEngine != nil && options!.withNewEngine) {
           let flutterVc = createFlutterVc(routeName: routeName, options: options)
           FMNativeNavigator.push(toPage: flutterVc, animated: options?.animated ?? true)
       } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(nil)
       }
   }
    
    public static func present(routeName: String, options: FMMeteorOptions?) {
       
       let vc: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.present(toPage: vc!, animated: options?.animated ?? true)
           options?.callBack?(nil)
       } else if(options?.withNewEngine != nil && options!.withNewEngine) {
           let flutterVc = createFlutterVc(routeName: routeName, options: options)
           FMNativeNavigator.present(toPage: flutterVc, animated: options?.animated ?? true)
       } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           options?.callBack?(nil)
       }
   }
   
    public static func popUntil(untilRouteName: String, options: FMMeteorOptions?) {

        FlutterMeteorRouter.searchRoute(routeName: untilRouteName) { viewController in
            // 1、先查询untilRouteName所在的viewController
            if (viewController != nil) {
                // 2、如果不是最上层的viewController，调用原生的popUntil
                if(viewController != FMNavigatorObserver.shared.routeStack.last) {
                    FMNativeNavigator.popUntil(untilPage: viewController!, animated: options?.animated ?? true)
                }
                if let flutterVc = viewController as? FlutterViewController {
                    // 3、如果是FlutterViewController则通过Channel通道在flutter端popUntil
                    if (flutterVc.engine != nil) {
                        let channel = FlutterMeteor.methodChannel(engine: flutterVc.engine!)
                        if(channel != nil) {
                            var arguments: Dictionary<String, Any?> = options?.arguments ?? [:]
                            if (arguments["untilRouteName"] == nil) {
                                arguments["untilRouteName"] = untilRouteName
                                arguments["arguments"] = arguments
                            }
                            channel!.invokeMethod(FMPopUntilMethod, arguments: arguments) { ret in
                                options?.callBack?(ret)
                            }
                        } else {
                            options?.callBack?(nil)
                            print("MethodChannel 为空")
                        }
                    } else {
                        options?.callBack?(nil)
                        print("引擎为空")
                    }
                }
            } else {
                FMNativeNavigator.pop(animated: options?.animated ?? true)
                options?.callBack?(nil)
                print("查无此路由")
            }
        }
   }
   
    public static func pushToReplacement(routeName: String, options: FMMeteorOptions?) {

        print("Call push pushToReplacement:\(routeName)")
        let vc: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)
       if (vc != nil) {
           FMNativeNavigator.pushToReplacement(toPage: vc!, animated: options?.animated ?? true)
           options?.callBack?(nil)
       } else if(options?.withNewEngine != nil && options!.withNewEngine) {
           let flutterVc = createFlutterVc(routeName: routeName, options: options)
           FMNativeNavigator.pushToReplacement(toPage: flutterVc, animated: options?.animated ?? true)
           options?.callBack?(nil)
       } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           let currentVc = FMNavigatorObserver.shared.routeStack.last
           if let flutterVc = currentVc as? FlutterViewController {
               if (flutterVc.engine != nil) {
                   let channel = FlutterMeteor.methodChannel(engine: flutterVc.engine!)
                   if(channel != nil) {
                       var arguments: Dictionary<String, Any?> = options?.arguments ?? [:]
                       if (arguments["routeName"] == nil) {
                           arguments["routeName"] = routeName
                           arguments["arguments"] = arguments
                       }
                       channel!.invokeMethod(FMPushReplacementNamedMethod, arguments: arguments) { ret in
                           options?.callBack?(ret)
                       }
                   } else {
                       options?.callBack?(nil)
                       print("MethodChannel 为空")
                   }
               } else {
                   options?.callBack?(nil)
                   print("引擎为空")
               }
           } else {
               options?.callBack?(nil)
           }
       }
   }
   
    public static func pop(options: FMMeteorOptions?) {
        FMNativeNavigator.pop()
        options?.callBack?(nil)
   }
   
    public static func popToRoot(options: FMMeteorOptions?) {
        FMNativeNavigator.popToRoot(animated: options?.animated ?? true)
        let vc = FMNavigatorObserver.shared.routeStack.first
        if let flutterVc = vc as? FlutterViewController {
            if let engine = flutterVc.engine {
                if let channel = FlutterMeteor.methodChannel(engine: engine) {
                    channel.invokeMethod(FMPopToRootMethod, arguments: options?.arguments) { response in
                        options?.callBack?(response)
                    }
                } else {
                    print("Failed to create method channel")
                }
            } else {
                print("Flutter engine is nil")
            }
        } else {
            print("ViewController is not a FlutterViewController")
        }
   }
   
    public static func dismiss(options: FMMeteorOptions?) {
        FMNativeNavigator.dismiss(animated: options?.animated ?? true)
        options?.callBack?(nil)
   }
    
    public static func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: FMMeteorOptions?) {
                
        if(untilRouteName != nil) {
            FlutterMeteorRouter.searchRoute(routeName: untilRouteName!) { viewController in
                _realPushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, untilPage: viewController, options: options)
            }
        } else {
            _realPushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, untilPage: nil, options: options)
        }
   }
    
    public static func _realPushToAndRemoveUntil(routeName: String, untilRouteName: String?, untilPage: UIViewController?, options: FMMeteorOptions?) {
        
        let toPage: UIViewController? = FlutterMeteorRouter.viewController(routeName: routeName, arguments: options?.arguments)

        if (toPage != nil) {
            FMNativeNavigator.pushToAndRemoveUntil(toPage: toPage!, untilPage: untilPage, animated: options?.animated ?? true)
            options?.callBack?(nil)
        } else if(options?.withNewEngine != nil && options!.withNewEngine) {
            let flutterVc = createFlutterVc(routeName: routeName, options: options)
            FMNativeNavigator.pushToAndRemoveUntil(toPage: flutterVc, untilPage: untilPage, animated: options?.animated ?? true)
            options?.callBack?(nil)
        } else if(FlutterMeteor.customRouterDelegate != nil) {
            FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
        } else {
            let currentVc = FMNavigatorObserver.shared.routeStack.last
            if let flutterVc = currentVc as? FlutterViewController {
                if (flutterVc.engine != nil) {
                    let channel = FlutterMeteor.methodChannel(engine: flutterVc.engine!)
                    if(channel != nil) {
                        var arguments: Dictionary<String, Any?> = options?.arguments ?? [:]
                        if (arguments["routeName"] == nil) {
                            arguments["routeName"] = routeName
                            arguments["untilRouteName"] = untilRouteName
                            arguments["arguments"] = arguments
                        }
                        channel!.invokeMethod(FMPushNamedAndRemoveUntilMethod, arguments: arguments) { ret in
                            options?.callBack?(ret)
                        }
                    } else {
                        options?.callBack?(nil)
                        print("MethodChannel 为空")
                    }
                } else {
                    options?.callBack?(nil)
                    print("引擎为空")
                }
            } else {
                options?.callBack?(nil)
            }
        }
   }
    
    
    
    private static func createFlutterVc(routeName: String, options: FMMeteorOptions?) -> FMFlutterViewController {
        let newEngineOpaque: Bool = options?.newEngineOpaque ?? true
        let flutterVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: options?.arguments, initialRoute: routeName, nibName: nil, bundle:nil, popCallBack: {result in
            print(result ?? "")
            options?.callBack?(nil)
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
