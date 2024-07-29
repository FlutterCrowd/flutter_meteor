//
//  FMNavigatorObserver.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/22.
//

import UIKit

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
        let titles = viewControllerStack.map { $0.routeName ?? "\(type(of: $0))" }
        print("Current View Controllers Stack: \(titles)")
        FlutterMeteorRouter.routeNameStack { ret in
            print("Current View routeNameStack: \(String(describing: ret))")
        }
        
        print("topViewController: \(FMNavigatorObserver.topViewController() ?? nil)")
        print("lastViewController: \(FMNavigatorObserver.shared.viewControllerStack.last)")
        
        print("rootViewController: \(FMNavigatorObserver.rootViewController() ?? nil)")
        print("firstViewController: \(FMNavigatorObserver.shared.viewControllerStack.first)")
        
    }
    
    /// 获取顶部控制器
    public static func rootViewController() -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        // 是否为当前显示的window
        if ((window?.windowLevel.rawValue) != 0) {
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel.rawValue == 0{
                    window = windowTemp
                    break
                }
            }
        }

        let vc = window?.rootViewController
        return vc
    }
    
    /// 获取顶部控制器 无要求
    public static func topViewController() -> UIViewController? {
        let vc = rootViewController()
        return getTopVC(withCurrentVC: vc)
    }
    
    public static func getTopVC(withCurrentVC VC: UIViewController?) -> UIViewController? {
        guard let currentVC = VC else {
            return nil
        }
        
        if let presentedVC = currentVC.presentedViewController {
            // Modal出来的控制器
            return getTopVC(withCurrentVC: presentedVC)
        } else if let tabVC = currentVC as? UITabBarController {
            // tabBar 的根控制器
            if let selectedVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectedVC)
            }
            return tabVC
        } else if let navVC = currentVC as? UINavigationController {
            // 控制器是导航控制器
            return getTopVC(withCurrentVC: navVC.visibleViewController)
        } else {
            // 返回顶层控制器
            return currentVC
        }
    }
}


