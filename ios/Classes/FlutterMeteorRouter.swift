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
    
    private static var routerDict = Dictionary<String, FMRouterBuilder>()
    
    
    public static func insertRouter(routeName:String, routerBuilder: @escaping FMRouterBuilder) {
        routerDict[routeName] = routerBuilder
    }
    
    public static func routerBuilder(routeName:String) -> FMRouterBuilder? {
        return routerDict[routeName]
    }
    
    public static func viewController(routeName: String?, arguments: Dictionary<String, Any>?) -> UIViewController? {
        if(routeName == nil) {
            return nil
        }
        let vcBuilder: FMRouterBuilder? = FlutterMeteorRouter.routerDict[routeName!]
        let vc: UIViewController? = vcBuilder?(arguments)
        vc?.routeName = routeName
        return vc
    }
    
    public static func searchRoute(routeName: String, result: @escaping FMRouterSearchBlock) {
    
        let outSemaphore = DispatchSemaphore(value: 0)
        var routeViewController: UIViewController? = nil
        let vcStack = FMRouterManager.viewControllerStack
        DispatchQueue.global().async { /// 开启异步队列避免阻塞
            let dispatchGroup = DispatchGroup() /// DispatchGroup 用于管理并发任务
            let semaphore = DispatchSemaphore(value: 1) /// 信号量用于同步遍历执行，保证路由栈的顺序
            var shouldBreak = false
            for (_, vc) in vcStack.enumerated().reversed(){
                if(shouldBreak) {
                    outSemaphore.signal()
                    break
                }
                semaphore.wait()
                dispatchGroup.enter()
                if let flutterVc = vc as? FlutterViewController {
                    if let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                            let arguments = ["routeName": routeName]
                            channel.save_invoke(method: FMRouteExists, arguments: arguments) { ret in
                                if let exit = ret as? Bool {
                                    if (exit) {
                                        routeViewController = vc
                                        shouldBreak = true
                                    }
                                }
                                dispatchGroup.leave()
                                semaphore.signal() // 释放信号量
                            }
                    } else {
                        dispatchGroup.leave()
                        semaphore.signal() // 释放信号量
                    }
                } else {
                    if(routeName == vc.routeName) {
                        routeViewController = vc
                        shouldBreak = true
                    }
                    dispatchGroup.leave()
                    semaphore.signal() // 释放信号量
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                result(routeViewController)
            }
        }
    }
    
    
    /*------------------------router method start--------------------------*/
    public static func routeExists(routeName:String, result: @escaping FlutterResult) {
        routeNameStack { routeStack in
            if(routeStack is Array<String>) {
                let stack = routeStack as! Array<String>
                let ret = stack.contains { e in
                    return e == routeName
                }
                result(ret)
            } else {
                result(false)
            }
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
        let vcStack = FMRouterManager.viewControllerStack
        DispatchQueue.global().async { /// 开启异步队列避免阻塞
            let dispatchGroup = DispatchGroup() /// DispatchGroup 用于管理并发任务
            let semaphore = DispatchSemaphore(value: 1) /// 信号量用于同步遍历执行，保证路由栈的顺序
            var routeStack = Array<String>()
            vcStack.forEach { vc in
                semaphore.wait()
                dispatchGroup.enter()
                if let flutterVc = vc as? FlutterViewController {
                   if let channel = FlutterMeteor.methodChannel(flutterVc: flutterVc) {
                       channel.save_invoke(method: FMRouteNameStack, arguments: nil) { ret in
                           if ret is Array<String> {
                               routeStack.append(contentsOf: ret as! Array<String>)
                           }
                           dispatchGroup.leave()
                           semaphore.signal() // 释放信号量
                        }
                    } else {
                        routeStack.append(vc.routeName ?? "\(type(of: vc))")
                        dispatchGroup.leave()
                        semaphore.signal() // 释放信号量
                    }
                } else {
                    routeStack.append(vc.routeName ?? "\(type(of: vc))")
                    dispatchGroup.leave()
                    semaphore.signal() // 释放信号量
                }
            }
            dispatchGroup.notify(queue: .main) {
                result(routeStack)
            }
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
