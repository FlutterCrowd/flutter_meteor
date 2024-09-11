//
//  FMNavigatorObserver.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/22.
//

import UIKit
import flutter_meteor

public class FMNavigatorObserver: NSObject, UINavigationControllerDelegate {
    public static let shared = FMNavigatorObserver()
    private override init() { super.init() }
    
    private var viewControllerStack: [UIViewController] = []
    
    public var routeStack: [UIViewController] {
        get {
            return viewControllerStack
        }
    }
    
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

            if let tabBarVc = viewController as? UITabBarController {
                if tabBarVc.selectedViewController != nil  {
                    setupViewController(tabBarVc.selectedViewController!)
                } else {
                    viewController.children.forEach { setupViewController($0) }
                }
            } else {
                viewController.children.forEach { setupViewController($0) }
            }
        }

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

        if let navigationController = viewController as? UINavigationController {
            navigationController.delegate = self
            for vc in navigationController.viewControllers {
                if !viewControllerStack.contains(vc) {
                    viewControllerStack.append(vc)
                }
            }
        } else {
            viewController.children.forEach { vc in
                if let navi = vc as? UINavigationController {
                    navi.delegate = self
                }
            }
            if !viewControllerStack.contains(viewController) {
                viewControllerStack.append(viewController)
            }
        }
        if let tabBarVc = viewController as? UITabBarController {
            if tabBarVc.selectedViewController != nil  {
                collectViewControllers(from: tabBarVc.selectedViewController!)
            } else {
                viewController.children.forEach { collectViewControllers(from: $0) }
            }
        } else {
            viewController.children.forEach { collectViewControllers(from: $0) }
        }
//        viewController.children.forEach { collectViewControllers(from: $0) }
        if let presentedViewController = viewController.presentedViewController {
            collectViewControllers(from: presentedViewController)
        }
    }
    
    func printCurrentViewControllerStack() {
//        let routeStack = viewControllerStack.map { $0.routeName ?? "\(type(of: $0))" }
//        print("Current View Controllers Stack: \(routeStack)")
//        let routeStack1 = MeteorNavigatorHelper.viewControllerStack.map { "\(type(of: $0))_\($0.routeName )"}// ??
//        print("-----Current View Controllers Stack1: \(routeStack1)")
//        FlutterMeteorRouter.routeNameStack { ret in
//            print("Current View routeNameStack: \(String(describing: ret))")
//        }
        
//        print("topViewController: \(FMRouterManager.topViewController() ?? nil)")
//        print("lastViewController: \(FMNavigatorObserver.shared.routeStack.last)")
        
//        print("rootViewController: \(FMRouterManager.rootViewController() ?? nil)")
//        print("firstViewController: \(FMNavigatorObserver.shared.viewControllerStack.first)")
        
    }
}


