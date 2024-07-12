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


public typealias FMRouterBuilder = (_ arguments: Dictionary<String, Any>?) -> UIViewController


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
    
    public static func routeExists(routeName:String, result: @escaping FlutterResult) {
        
        var ret = false
        for channel in FlutterMeteor.channelList.allObjects {
            if ret {
                break
            }
            channel.invokeMethod(FMRouteExists, arguments: [
                "routeName": routeName,
            ]) { data in
                if (data is Bool && !ret) {
                    ret = data as! Bool
                    result(ret)
                    return
                }
            }
        }
    }
    
    
    public static func isRoot(routeName:String, result: @escaping FlutterResult) {
//        FlutterMeteor.flutterRootEngineMethodChannel?.invokeMethod(FMIsRoot, arguments: ["routeName": routeName], result: result)

        FlutterMeteor.flutterRootEngineMethodChannel?.invokeMethod(FMIsRoot, arguments: [
            "routeName": routeName,
        ]) { ret in
            result(ret)
        }
    }
    
    public static func rootRouteName(result: @escaping FlutterResult) {
//        FlutterMeteor.flutterRootEngineMethodChannel?.invokeMethod(FMRootRouteName, arguments: nil, result: result)
        FlutterMeteor.flutterRootEngineMethodChannel?.invokeMethod(FMRootRouteName, arguments: nil) { ret in
            result(ret)
        }
    }
    
    public static func topRouteName(result: @escaping FlutterResult) {
        let channel = FlutterMeteor.channelList.allObjects.last
        channel?.invokeMethod(FMTopRouteName, arguments: nil) { ret in
            result(ret)
        }
    }
    
    public static func routeNameStack(result: @escaping FlutterResult) {
        
        let dispatchGroup = DispatchGroup()
        
        var routeStack = Array<String>()
        for channel in FlutterMeteor.channelList.allObjects {
            dispatchGroup.enter()
            channel.invokeMethod(FMRouteNameStack, arguments: nil) { ret in
                if ret is Array<String> {
                    routeStack.append(contentsOf: ret as! Array<String>)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            result(routeStack)
        }
    }

}


public class GlobalRouterManager: NSObject, UINavigationControllerDelegate {
    public static let shared = GlobalRouterManager()
    private override init() { super.init() }
    
    private var viewControllerStack: [UIViewController] = []
    
    public func startMonitoring() {
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            setupViewController(rootViewController)
        }
    }
    
    private func setupViewController(_ viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            navigationController.delegate = self
            viewControllerStack.append(contentsOf: navigationController.viewControllers)
        } else {
            viewControllerStack.append(viewController)
        }
        
        viewController.children.forEach { setupViewController($0) }
        if let presentedViewController = viewController.presentedViewController {
            setupViewController(presentedViewController)
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        updateViewControllerStack()
    }
    
    public func updateViewControllerStack() {
        viewControllerStack.removeAll()
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            collectViewControllers(from: rootViewController)
        }
        printCurrentViewControllerStack()
    }
    
    private func collectViewControllers(from viewController: UIViewController) {
        if !viewControllerStack.contains(viewController) {
            viewControllerStack.append(viewController)
        }
//        viewControllerStack.append(viewController)
//        if let navigationController = viewController as? UINavigationController {
//            viewControllerStack.append(contentsOf: navigationController.viewControllers)
//        }
        if let navigationController = viewController as? UINavigationController {
            for vc in navigationController.viewControllers {
                if !viewControllerStack.contains(vc) {
                    viewControllerStack.append(vc)
                }
            }
        }
        viewController.children.forEach { collectViewControllers(from: $0) }
        if let presentedViewController = viewController.presentedViewController {
            collectViewControllers(from: presentedViewController)
        }
    }
    
    func printCurrentViewControllerStack() {
        let titles = viewControllerStack.map { $0.routeName ?? "No Title" }
        print("Current View Controllers Stack: \(titles)")
        print("Current View Controllers Stack: \(viewControllerStack)")
    }
}


