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
            let currentVc = FMRouterHelper.topViewController()
            if let flutterVc = currentVc as? FlutterViewController {
                FMFlutterNavigator.pushToAndRemoveUntil(flutterVc: flutterVc, routeName: routeName, untilRouteName: untilRouteName, options: options)
            } else {
                options?.callBack?(nil)
            }
        }
    }
    
    public static func pushNamedAndRemoveUntilRoot(routeName: String, options: FMPushOptions? = nil) {
        
        func flutterPopRoot(){
            let rootVc = FMRouterHelper.rootViewController()
            if let flutterVc = rootVc as? FlutterViewController {
                FMFlutterNavigator.popToRoot(flutterVc: flutterVc)
            } else if let naviVc = rootVc as? UINavigationController,
                        let flutterVc = naviVc.viewControllers.first as? FlutterViewController {
                FMFlutterNavigator.popToRoot(flutterVc: flutterVc)
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
            if let flutterVc = FMRouterHelper.topViewController() as? FlutterViewController {
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
           let currentVc = FMRouterHelper.topViewController()
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
            if let flutterVc = FMRouterHelper.topViewController() as? FlutterViewController {
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
            if let flutterVc = FMRouterHelper.topViewController() as? FlutterViewController {
                FMFlutterNavigator.pop(flutterVc: flutterVc)
            } else {
                FMNativeNavigator.pop(animated: options?.animated ?? true)
                options?.callBack?(nil)
                print("pop until 查无此路由直接返回上一级页面")
            }
        }
    }
   
    public static func popToRoot(options: FMPopOptions? = nil) {
        
        let rootVc = FMRouterHelper.rootViewController()
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
    
    /*------------------------router method start--------------------------*/
    public static func routerChannel(flutterVc: FlutterViewController) -> FlutterMethodChannel? {
        
        let channelProvider = FlutterMeteorPlugin.channelProvider(with: flutterVc.pluginRegistry())
        return channelProvider?.routerChannel
    }
    
    public static func searchRoute(routeName: String, result: @escaping FMRouterSearchBlock) {
    
        let vcStack = FMRouterHelper.viewControllerStack.reversed() // 反转数组，从顶层向下层搜索
        let serialQueue = FMSerialTaskQueue(label: "cn.itbox.serialTaskQueue.routeSearch")

        func callBack(viewController: UIViewController?){
            DispatchQueue.main.async {
                result(viewController)
            }
        }
        
        func search(in stack: [UIViewController], index: Int) {
            
            guard index < stack.count else {
                // 搜索完成，调用结果回调
                callBack(viewController: nil)
//                print("原生结束搜索任务searchRoute")
                return
            }

            let vc = stack[index]
            let continueSearch = {
                search(in: stack, index: index + 1)
            }
            
            serialQueue.addTask { finish in
//                print("原生开始搜索任务searchRoute")
                if let flutterVc = vc as? FlutterViewController,
                   let channel = routerChannel(flutterVc: flutterVc) {
                    let arguments = ["routeName": routeName]
           
                    channel.save_invoke(method: FMRouteExists, arguments: arguments) { ret in
                        defer {
                            finish()
//                            print("原生结束搜索任务searchRoute flutter")
                        }
                        if let exists = ret as? Bool, exists {
                            // 找到匹配的路由，调用结果回调
                            callBack(viewController: vc)
                        } else {
                            // 继续搜索下一个
                            continueSearch()
                        }
                    }
                } else {
                    defer {
                        finish()
                    }
                    if routeName == vc.routeName {
                    
                       // 找到匹配的路由，调用结果回调
                        callBack(viewController: vc)
                   } else {
                       // 继续搜索下一个
                       continueSearch()
                   }
                }
            }
        }

        // 从第一个元素开始搜索
        search(in: Array(vcStack), index: 0)
    }

    
    public static func routeExists(routeName:String, result: @escaping FlutterResult) {
        print("原生开始调用searchRoute")
        searchRoute(routeName: routeName) { viewController in
            let exists = viewController != nil// 没有对应的ViewCOntroller则可以认为没有这个路由
            result(exists)
            print("原生结束调用searchRoute")
        }
    }
    
    
    public static func isRoot(routeName:String, result: @escaping FlutterResult) {
        rootRouteName { rootName in
            if(rootName is String) {
                if(routeName == rootName as! String) {
                    result(true)
                } else {
                    result(false)
                }
            } else {
                result(false)
            }
        }
    }
    
    public static func rootRouteName(result: @escaping FlutterResult) {
        func getFlutterRootRoute(flutterVc: FlutterViewController, result: @escaping FlutterResult){
            if let channel = routerChannel(flutterVc: flutterVc) {
                channel.save_invoke(method:FMRootRouteName, arguments: nil) { response in
                    result(response)
                }
            } else {
                result(flutterVc.routeName)
            }
        }
        
        let rootVc = FMRouterHelper.rootViewController()
        if let flutterVc = rootVc as? FlutterViewController {
            getFlutterRootRoute(flutterVc: flutterVc, result: result)
        } else if let naviVc = rootVc as? UINavigationController {
            let vc = naviVc.viewControllers.first
            if let flutterVc = vc as? FlutterViewController {
                getFlutterRootRoute(flutterVc: flutterVc, result: result)
            } else {
                result(rootVc?.routeName)
            }
        } else {
            result(rootVc?.routeName)

        }
    }
    
    public static func topRouteName(result: @escaping FlutterResult) {
        
        let topVc = FMRouterHelper.topViewController()
        if let flutterVc = topVc as? FlutterViewController {
            if let channel = routerChannel(flutterVc: flutterVc) {
                channel.save_invoke(method: FMTopRouteName, arguments: nil, result: result)
            } else {
                result(topVc?.routeName)
            }
        } else {
            result(topVc?.routeName)

        }
    }
    

    public static func routeNameStack(result: @escaping FlutterResult) {
        
        let vcStack = FMRouterHelper.viewControllerStack
        let dispatchGroup = DispatchGroup() // DispatchGroup 用于管理并发任务
        var routeStack = [String]()
        
        var vcMap = [UIViewController: [String]]()
        
        print("原生开始调用routeNameStack")
        vcStack.forEach { vc in
            dispatchGroup.enter()
            if let flutterVc = vc as? FlutterViewController,
               let channel = routerChannel(flutterVc: flutterVc) {
                channel.save_invoke(method: FMRouteNameStack, arguments: nil) { ret in
                    defer {
                        dispatchGroup.leave()
                    }
                    if let retArray = ret as? [String] {
                        vcMap[vc] = retArray
                    } else {
                        vcMap[vc] = [vc.routeName ?? "\(type(of: vc))"]
                    }
                }
            } else {
                defer {
                    dispatchGroup.leave()
                }
                vcMap[vc] = [vc.routeName ?? "\(type(of: vc))"]
            }
        }

        dispatchGroup.notify(queue: .main) {
            vcStack.forEach { vc in
                routeStack.append(contentsOf: vcMap[vc] ?? [vc.routeName ?? "\(type(of: vc))"])
            }
            result(routeStack)
            print("原生结束调用routeNameStack")
        }
    }
    
    
    
    public static func topRouteIsNative(result: @escaping FlutterResult) {
        let vc = FMRouterHelper.topViewController()
        let topVc = FMRouterHelper.getTopVC(withCurrentVC: vc)
        if topVc is FlutterViewController {
            result(false)

        } else {
            result(true)
        }
    }
    /*------------------------router method end--------------------------*/

}


