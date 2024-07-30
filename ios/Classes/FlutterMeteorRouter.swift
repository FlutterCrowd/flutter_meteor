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
    
    var semaphore = DispatchSemaphore(value: 1)
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
    
    
    
    
    public static func searchRoute(routeName: String, result: @escaping FMRouterSearchBlock) {
    
        let vcStack = FMRouterManager.viewControllerStack.reversed() // 反转数组，从顶层向下层搜索
        let serialQueue = FMSerialTaskQueue(label: "cn.itbox.serialTaskQueue.routeSearch")

        func search(in stack: [UIViewController], index: Int) {
            guard index < stack.count else {
                // 搜索完成，调用结果回调
                result(nil)
                return
            }

            let vc = stack[index]
            let continueSearch = {
                search(in: stack, index: index + 1)
            }

            serialQueue.addTask { finish in
                defer { finish() }
                if let flutterVc = vc as? FlutterViewController,
                   let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                    let arguments = ["routeName": routeName]
                    channel.save_invoke(method: FMRouteExists, arguments: arguments) { ret in
                        if let exists = ret as? Bool, exists {
                            // 找到匹配的路由，调用结果回调
                            result(vc)
                        } else {
                            // 继续搜索下一个
                            continueSearch()
                        }
                    }
                } else if routeName == vc.routeName {
                    // 找到匹配的路由，调用结果回调
                    result(vc)
                } else {
                    // 继续搜索下一个
                    continueSearch()
                }
            }
        }

        // 从第一个元素开始搜索
        search(in: Array(vcStack), index: 0)
    }
    
    
    /*------------------------router method start--------------------------*/
    public static func routeExists(routeName:String, result: @escaping FlutterResult) {
        searchRoute(routeName: routeName) { viewController in
            let exists = viewController != nil// 没有对应的ViewCOntroller则可以认为没有这个路由
            result(exists)
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
        
        let rootVc = FMRouterManager.viewControllerStack.first
        if(rootVc is FlutterViewController) {
            let flutterVc = rootVc as! FlutterViewController
            let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc)//FlutterMeteor.channelList.allObjects.last
            channel?.save_invoke(method:FMRootRouteName, arguments: nil) { ret in
                result(ret)
            }
        } else {
            result(rootVc?.routeName)
        }
        
    }
    
    public static func topRouteName(result: @escaping FlutterResult) {
        
        let vc = FMRouterManager.viewControllerStack.last
        let topVc = FMRouterManager.getTopVC(withCurrentVC: vc)
        if topVc is FlutterViewController {
            let flutterVc = vc as! FlutterViewController
            let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc)//FlutterMeteor.channelList.allObjects.last
            channel?.save_invoke(method: FMTopRouteName, arguments: nil) { ret in
                result(ret)
            }
        } else {
            result(topVc?.routeName)
        }
    }
    

    public static func routeNameStack(result: @escaping FlutterResult) {
        let serialQueue = FMSerialTaskQueue(label: "cn.itbox.serialTaskQueue.routeNameStack")
        let vcStack = FMRouterManager.viewControllerStack
        let dispatchGroup = DispatchGroup() // DispatchGroup 用于管理并发任务
        var routeStack = [String]()
        
        vcStack.forEach { vc in
            dispatchGroup.enter()
            serialQueue.addTask { finish in
                if let flutterVc = vc as? FlutterViewController,
                   let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                    channel.save_invoke(method: FMRouteNameStack, arguments: nil) { ret in
                        if let retArray = ret as? [String] {
                            routeStack.append(contentsOf: retArray)
                        } else {
                            routeStack.append(vc.routeName ?? "\(type(of: vc))")
                        }
                        dispatchGroup.leave()
                        finish()
                    }
                } else {
                    routeStack.append(vc.routeName ?? "\(type(of: vc))")
                    dispatchGroup.leave()
                    finish()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            result(routeStack)
        }
    }
    
    
    
    public static func topRouteIsNative(result: @escaping FlutterResult) {
        let vc = FMRouterManager.viewControllerStack.last
        let topVc = FMRouterManager.getTopVC(withCurrentVC: vc)
        if topVc is FlutterViewController {
            result(false)
        } else {
            result(true)
        }
        
    }
    
    /*------------------------router method end--------------------------*/

}
