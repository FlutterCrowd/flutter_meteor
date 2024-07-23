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


public class FlutterMeteorRouter: NSObject {
    
    private static var routerDict = Dictionary<String, FMRouterBuilder>()
    
    public static func startMonitoring() {
        FMRouterManager.shared.startMonitoring()
    }
    
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
        
        let rootVc = FMRouterManager.shared.routeStack.first
        if(rootVc is FlutterViewController) {
            let flutterVc = rootVc as! FlutterViewController
            if (flutterVc.engine != nil) {
                let channel = FlutterMeteor.methodChannel(engine: flutterVc.engine!)//FlutterMeteor.channelList.allObjects.last
                channel?.invokeMethod(FMRootRouteName, arguments: nil) { ret in
                    result(ret)
                }
            } else {
                result(rootVc?.routeName)
            }
        } else {
            result(rootVc?.routeName)
        }
        
//        FlutterMeteor.flutterRootEngineMethodChannel?.invokeMethod(FMRootRouteName, arguments: nil) { ret in
//            result(ret)
//        }
    }
    
    public static func topRouteName(result: @escaping FlutterResult) {
        
        let vc = FMRouterManager.shared.routeStack.last
        let topVc = FMRouterManager.getTopVC(withCurrentVC: vc)
        if topVc is FlutterViewController {
            let flutterVc = vc as! FlutterViewController
            if (flutterVc.engine != nil) {
                let channel = FlutterMeteor.methodChannel(engine: flutterVc.engine!)//FlutterMeteor.channelList.allObjects.last
                channel?.invokeMethod(FMTopRouteName, arguments: nil) { ret in
                    result(ret)
                }
            } else {
                result(topVc?.routeName)
            }
    
        } else {
            result(topVc?.routeName)
        }
        
    }
    

    public static func routeNameStack(result: @escaping FlutterResult) {
        let vcStack = FMRouterManager.shared.routeStack
        DispatchQueue.global().async { /// 开启异步队列避免阻塞
            let dispatchGroup = DispatchGroup() /// DispatchGroup 用于管理并发任务
            let semaphore = DispatchSemaphore(value: 1) /// 信号量用于同步遍历执行，保证路由栈的顺序
            var routeStack = Array<String>()
            vcStack.forEach { vc in
//                print("DispatchGroup enter")
                semaphore.wait()
                dispatchGroup.enter()
                if vc is FlutterViewController {
                    let flutterVc = vc as! FlutterViewController
                    if (flutterVc.engine != nil) {
                        let channel = FlutterMeteor.methodChannel(engine: flutterVc.engine!)
                        if(channel != nil) {
//                            routeStack.append(contentsOf: getFlutterRouteStack(channel: channel!))
                            channel!.invokeMethod(FMRouteNameStack, arguments: nil) { ret in
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
                } else {
                    routeStack.append(vc.routeName ?? "\(type(of: vc))")
                    dispatchGroup.leave()
                    semaphore.signal() // 释放信号量
                }
            }
            dispatchGroup.notify(queue: .main) {
//                print("DispatchGroup notify \(routeStack)")
                result(routeStack)
            }
        }
    }
    
    
    
    public static func topRouteIsNative(result: @escaping FlutterResult) {
//        
//        print("routeStack.last:\(String(describing: FMRouterManager.shared.routeStack.last))")
////        print("routeStack.last:\(FMRouterManager.topViewController()!)")
//        if (FMRouterManager.topViewController() == FMRouterManager.shared.routeStack.last) {
//            print("是同一个ViewController")
//        } else {
//            print("不是同一个ViewController")
//        }
        let vc = FMRouterManager.shared.routeStack.last
        let topVc = FMRouterManager.getTopVC(withCurrentVC: vc)
        if topVc is FlutterViewController {
            result(false)
        } else {
            result(true)
        }
        
    }
    
    /*------------------------router method end--------------------------*/


}
