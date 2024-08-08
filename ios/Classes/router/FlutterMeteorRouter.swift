//
//  FlutterMeteorRouterManager.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/12.
//

import UIKit
import Flutter

public let FMRouteExists: String  = "routeExists";
public let FMIsRoot: String  = "isRoot";
public let FMRootRouteName: String  = "rootRouteName";
public let FMTopRouteName: String  = "topRouteName";
public let FMRouteNameStack: String  = "routeNameStack";
public let FMTopRouteIsNative: String  = "topRouteIsNative";

public typealias FMRouterBuilder = (_ arguments: Dictionary<String, Any>?) -> UIViewController

public typealias FMRouterSearchBlock = (_ viewController: UIViewController?) -> Void

public class FlutterMeteorRouter: NSObject {
    
    private static var routes = Dictionary<String, FMRouterBuilder>()
    
    public static func insertRouter(routeName:String, routerBuilder: @escaping FMRouterBuilder) {
        routes[routeName] = routerBuilder
    }
    
    public static func routerBuilder(routeName:String) -> FMRouterBuilder? {
        return routes[routeName]
    }
    
    public static func viewController(routeName: String?, arguments: Dictionary<String, Any>?) -> UIViewController? {
        if(routeName == nil) {
            return nil
        }
        let vcBuilder: FMRouterBuilder? = FlutterMeteorRouter.routes[routeName!]
        let vc: UIViewController? = vcBuilder?(arguments)
        vc?.routeName = routeName
        return vc
    }
    
    
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
}

extension FlutterMeteorRouter {
    
    /*------------------------router method start--------------------------*/
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
 
